# frozen_string_literal: true

require "rails_helper"

RSpec.describe "tweetCreate mutation", type: :request do
  subject(:perform_request) do
    post "/graphql",
         params: { query: mutation, variables: variables },
         as: :json
  end

  let(:mutation) do
    <<~GRAPHQL
      mutation($input: TweetCreateInput!) {
        tweetCreate(input: $input) {
          tweet {
            uuid
          }
          errors
        }
      }
    GRAPHQL
  end

  let(:content) { "I don't know what I am doing!" }

  let(:variables) do
    {
      input: {
        content: content
      }
    }
  end

  it "creates a tweet" do
    expect { perform_request }
      .to change(Tweet, :count).by(1)
  end

  it "returns the tweet UUID" do
    perform_request

    result = JSON.parse(response.body)

    expect(result.dig("data", "tweetCreate", "tweet", "uuid"))
      .to be_present
  end

  it "returns no errors" do
    perform_request

    result = JSON.parse(response.body)

    expect(result.dig("data", "tweetCreate", "errors")).to eq([])
  end

  it "adds the Open Graph scraper job" do
    expect { perform_request }
      .to have_enqueued_job(OpenGraphScraperJob)
  end

  context "when content is empty" do
    let(:content) { "" }

    it "does not create a tweet" do
      expect { perform_request }
        .not_to change(Tweet, :count)
    end

    it "does not add the scraper job" do
      expect { perform_request }
        .not_to have_enqueued_job(OpenGraphScraperJob)
    end

    it "returns the validation error" do
      perform_request

      result = JSON.parse(response.body)
      payload = result.dig("data", "tweetCreate")

      expect(payload["tweet"]).to be_nil
      expect(payload["errors"]).to include("Content can't be blank")
    end
  end
end
