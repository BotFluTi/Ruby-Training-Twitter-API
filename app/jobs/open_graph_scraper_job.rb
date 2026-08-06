# frozen_string_literal: true

class OpenGraphScraperJob < ApplicationJob
  queue_as :default

  def perform(tweet_id:)
    tweet = Tweet.find(tweet_id)

    UrlExtractor.call(tweet.content).each do |url|
      metadata = OpenGraphFetch.call(url)

      tweet.resources.create!(metadata)
    end
  end
end
