# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :comment_create, mutation: Mutations::CommentCreate
    field :tweet_create, mutation: Mutations::TweetCreate
  end
end
