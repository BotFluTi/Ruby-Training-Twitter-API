# frozen_string_literal: true

require "nokogiri"
require "open-uri"

class OpenGraphFetch
  def self.call(url)
    document = Nokogiri::HTML(URI.open(url))
    image_url = metadata(document, "og:image")

    {
      title: metadata(document, "og:title"),
      description: metadata(document, "og:description"),
      url: metadata(document, "og:url"),
      image_url: image_url,
      image_byte_size: URI.open(image_url).read.bytesize
    }
  end

  def self.metadata(document, property)
    document
      .at_xpath("//meta[@property='#{property}']")["content"]
  end

  private_class_method :metadata
end
