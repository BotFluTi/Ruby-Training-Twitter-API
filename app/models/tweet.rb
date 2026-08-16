# frozen_string_literal: true

class Tweet < ApplicationRecord
  include HasUuid

  has_many :resources, dependent: :destroy

  validates :content, presence: true
end
