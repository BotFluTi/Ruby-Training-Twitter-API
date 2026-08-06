# frozen_string_literal: true

module Types
  class ImageType < Types::BaseObject
    field :url, String, null: false
    field :byte_size, Integer, null: false
  end
end
