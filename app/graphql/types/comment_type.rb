# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    field :uuid, ID, null: false
  end
end
