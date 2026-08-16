# frozen_string_literal: true

require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:tweet) do
    Tweet.create!(content: "I don't know what I am doing!")
  end

  it "generates a UUID when it is created" do
    comment = described_class.create!(
      tweet: tweet,
      content: "Nice link! https://12ft.io/"
    )

    expect(comment.uuid).to be_present
  end

  it "is invalid without content" do
    comment = described_class.new(tweet: tweet, content: "")

    expect(comment).not_to be_valid
    expect(comment.errors[:content]).to be_present
  end

  it "is invalid without a tweet" do
    comment = described_class.new(tweet: nil, content: "Nice link!")

    expect(comment).not_to be_valid
    expect(comment.errors[:tweet]).to be_present
  end

  it "owns Open Graph resources" do
    comment = described_class.create!(
      tweet: tweet,
      content: "Nice link! https://12ft.io/"
    )

    resource = comment.resources.create!(
      title: "I don't know what I am doing!",
      description: "An Open Graph description",
      url: "https://12ft.io/",
      image_url: "https://12ft.io/og-banner.png",
      image_byte_size: 1024
    )

    expect(resource.resourceable).to eq(comment)
  end
end
