# frozen_string_literal: true

class Comment < ApplicationRecord
  include HasUuid

  belongs_to :tweet

  validates :content, presence: true
end
