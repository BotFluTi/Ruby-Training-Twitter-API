# frozen_string_literal: true

module Mutations
  class CommentCreate < Mutations::BaseMutation
    argument :tweet_uuid, ID, required: true
    argument :content, String, required: true

    field :comment, Types::CommentType, null: true
    field :errors, [ String, null: false ], null: false

    def resolve(tweet_uuid:, content:)
      tweet = Tweet.find_by(uuid: tweet_uuid)

      raise GraphQL::ExecutionError, "Tweet not found" if tweet.nil?

      comment = tweet.comments.new(content: content)

      if comment.save
        OpenGraphScraperJob.perform_later(record: comment)

        {
          comment: comment,
          errors: []
        }
      else
        {
          comment: nil,
          errors: comment.errors.full_messages
        }
      end
    end
  end
end
