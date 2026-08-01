# frozen_string_literal: true

require "rails_helper"

RSpec.describe OpenGraphFetch do
  subject(:metadata) do
    described_class.call(page_url)
  end

  let(:page_url) { "https://12ft.io/" }
  let(:image_url) { "https://12ft.io/og-banner.png" }
  let(:image_body) { "fake-image-content" }

  let(:html) do
    Rails.root
         .join("spec/fixtures/open_graph_page.html")
         .read
  end

  before do
    stub_request(:get, page_url)
      .to_return(status: 200, body: html)

    stub_request(:get, image_url)
      .to_return(status: 200, body: image_body)
  end

  it "returns all Open Graph metadata" do
    expect(metadata).to eq(
                          {
                            title: "I don't know what I am doing!",
                            description: "An Open Graph description",
                            url: "https://12ft.io/",
                            image_url: "https://12ft.io/og-banner.png",
                            image_byte_size: image_body.bytesize
                          }
                        )
  end
end
