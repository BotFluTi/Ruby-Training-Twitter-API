# frozen_string_literal: true

require "rails_helper"

RSpec.describe Resource, type: :model do
  subject(:resource) do
    described_class.new(
      resourceable: resourceable,
      title: "I don't know what I am doing!",
      description: "An Open Graph description",
      url: url,
      image_url: "https://12ft.io/og-banner.png",
      image_byte_size: 1024
    )
  end

  let(:resourceable) do
    Tweet.create!(content: "I don't know what I am doing!")
  end

  let(:url) { "https://12ft.io/" }

  it "is valid with Open Graph metadata" do
    expect(resource).to be_valid
  end

  context "without a resourceable" do
    let(:resourceable) { nil }

    it "is invalid" do
      expect(resource).not_to be_valid
    end
  end

  context "without a URL" do
    let(:url) { nil }

    it "is invalid" do
      expect(resource).not_to be_valid
    end
  end
end
