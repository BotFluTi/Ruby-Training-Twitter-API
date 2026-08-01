# frozen_string_literal: true

require "rails_helper"

RSpec.describe Resource, type: :model do
  let(:tweet) do
    Tweet.create!(content: "I don't know what I am doing!")
  end

  let(:valid_attributes) do
    {
      tweet: tweet,
      title: "I don't know what I am doing!",
      description: "An Open Graph description",
      url: "https://12ft.io/",
      image_url: "https://12ft.io/og-banner.png",
      image_byte_size: 1024
    }
  end

  it "is valid with Open Graph metadata" do
    resource = described_class.new(valid_attributes)

    expect(resource).to be_valid
  end

  it "is invalid without a tweet" do
    resource = described_class.new(
      valid_attributes.merge(tweet: nil)
    )

    expect(resource).not_to be_valid
  end

  it "is invalid without a URL" do
    resource = described_class.new(
      valid_attributes.merge(url: nil)
    )

    expect(resource).not_to be_valid
  end
end
