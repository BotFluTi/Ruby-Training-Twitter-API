# frozen_string_literal: true

class OpenGraphScraperJob < ApplicationJob
  queue_as :default

  def perform(record:)
    UrlExtractor.call(record.content).each do |url|
      metadata = OpenGraphFetch.call(url)

      record.resources.create!(metadata)
    end
  end
end
