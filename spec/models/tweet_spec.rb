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

  it "returns its comments in a deterministic order" do
    tweet = described_class.create!(content: "Hello")
    ids = Array.new(3) do |index|
      Comment.create!(tweet: tweet, content: "Comment #{index}").id
    end

    # SQLite happens to return rows in insertion order, so the ordering has to
    # be pinned by the query itself rather than left to the database.
    expect(tweet.comments.to_sql).to include('ORDER BY "comments"."id" ASC')
    expect(tweet.comments.map(&:id)).to eq(ids)
  end

  it "destroys its comments and their resources" do
    tweet = described_class.create!(content: "Hello")
    comment = Comment.create!(tweet: tweet, content: "Nice link! https://12ft.io/")

    comment.resources.create!(
      title: "I don't know what I am doing!",
      description: "An Open Graph description",
      url: "https://12ft.io/",
      image_url: "https://12ft.io/og-banner.png",
      image_byte_size: 1024
    )

    expect { tweet.destroy }
      .to change(Comment, :count).by(-1)
      .and change(Resource, :count).by(-1)
  end
end
