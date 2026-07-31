# frozen_string_literal: true

module Types
  class TweetType < Types::BaseObject
    field :uuid, ID, null: false
  end
end
