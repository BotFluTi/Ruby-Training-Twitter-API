# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :tweets,
          [ Types::TweetType, null: false ],
          null: false

    def tweets
      Tweet.includes(:resources).order(:id)
    end
  end
end
