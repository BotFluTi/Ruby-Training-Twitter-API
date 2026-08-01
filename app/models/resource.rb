# frozen_string_literal: true

class Resource < ApplicationRecord
  belongs_to :tweet

  validates :title, presence: true
  validates :description, presence: true
  validates :url, presence: true
  validates :image_url, presence: true
  validates :image_byte_size,
            presence: true
end
