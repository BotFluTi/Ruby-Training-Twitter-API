# frozen_string_literal: true

class Tweet < ApplicationRecord
  include HasUuid

  has_many :resources, as: :resourceable, dependent: :destroy

  validates :content, presence: true
end
