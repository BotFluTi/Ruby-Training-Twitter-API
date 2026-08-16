# frozen_string_literal: true

class Comment < ApplicationRecord
  include HasUuid

  belongs_to :tweet

  has_many :resources, as: :resourceable, dependent: :destroy

  validates :content, presence: true
end
