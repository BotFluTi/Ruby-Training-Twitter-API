# frozen_string_literal: true

require "uri"

class UrlExtractor
  def self.call(content)
    URI.extract(content, %w[http https]).uniq
  end
end
