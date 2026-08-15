# frozen_string_literal: true

require "rails_helper"

RSpec.describe UrlExtractor do
  describe ".call" do
    it "returns an empty array when the content has no URLs" do
      result = described_class.call(
        "I don't know what I am doing!"
      )

      expect(result).to eq([])
    end

    it "extracts URL from the content" do
      result = described_class.call(
        "I don't know what I am doing! https://12ft.io/"
      )

      expect(result).to eq([ "https://12ft.io/" ])
    end

    it "extracts multiple URLs" do
      result = described_class.call(
        "I don't know what I am doing! https://example.com http://example.org"
      )

      expect(result).to eq(
                          [ "https://example.com", "http://example.org" ]
                        )
    end

    it "does not return duplicate URLs" do
      result = described_class.call(
        "I don't know what I am doing! https://example.com https://example.com"
      )

      expect(result).to eq([ "https://example.com" ])
    end
  end
end
