# frozen_string_literal: true

require "rails_helper"

RSpec.describe OpenGraphScraperJob, type: :job do
  fixtures :tweets

  subject(:perform_job) do
    described_class.perform_now(tweet_id: tweet.id)
  end

  let(:tweet) { tweets(:with_url) }
  let(:urls) { ["https://12ft.io/"] }

  let(:metadata) do
    {
      title: "I don't know what I am doing!",
      description: "An Open Graph description",
      url: "https://12ft.io/",
      image_url: "https://12ft.io/og-banner.png",
      image_byte_size: 1024
    }
  end

  before do
    allow(UrlExtractor)
      .to receive(:call)
            .with(tweet.content)
            .and_return(urls)

    allow(OpenGraphFetch)
      .to receive(:call)
            .and_return(metadata)
  end

  it "creates a resource for the tweet" do
    expect { perform_job }
      .to change(Resource, :count).by(1)
  end

  it "saves the Open Graph metadata" do
    perform_job

    expect(tweet.resources.first).to have_attributes(metadata)
  end

  context "when the tweet has no URLs" do
    let(:tweet) { tweets(:without_url) }
    let(:urls) { [] }

    it "does not create resources" do
      expect { perform_job }
        .not_to change(Resource, :count)
    end
  end

  context "when the tweet has multiple URLs" do
    let(:urls) do
      [
        "https://12ft.io/",
        "https://example.com/"
      ]
    end

    it "creates one resource for every URL" do
      expect { perform_job }
        .to change(Resource, :count).by(2)
    end
  end
end
