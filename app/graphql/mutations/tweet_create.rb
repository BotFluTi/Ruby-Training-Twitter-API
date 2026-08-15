# frozen_string_literal: true

module Mutations
  class TweetCreate < Mutations::BaseMutation
    argument :content, String, required: true

    field :tweet, Types::TweetType, null: true
    field :errors, [ String, null: false ], null: false

    def resolve(content:)
      tweet = Tweet.new(content: content)

      if tweet.save
        OpenGraphScraperJob.perform_later(tweet_id: tweet.id)

        {
          tweet: tweet,
          errors: []
        }
      else
        {
          tweet: nil,
          errors: tweet.errors.full_messages
        }
      end
    end
  end
end
