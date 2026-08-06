# frozen_string_literal: true

module Types
  class ResourceDescriptionType < Types::BaseObject
    field :title, String, null: false
    field :description, String, null: false
    field :url, String, null: false
    field :image, Types::ImageType, null: false

    def image
      {
        url: object.image_url,
        byte_size: object.image_byte_size
      }
    end
  end
end
