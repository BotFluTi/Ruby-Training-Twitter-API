# frozen_string_literal: true

require "rails_helper"

RSpec.describe Tweet, type: :model do
  it "generates a UUID when it is created" do
    tweet = described_class.create!(content: "Hello")

    expect(tweet.uuid).to be_present
  end

  it "is invalid without content" do
    tweet = described_class.new(content: "")

    expect(tweet).not_to be_valid
    expect(tweet.errors[:content]).to be_present
  end

  it "does not allow duplicate UUIDs" do
    existing_tweet = described_class.create!(content: "First tweet")
    duplicate = described_class.new(
      content: "Second tweet",
      uuid: existing_tweet.uuid
    )

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:uuid]).to be_present
  end
end
