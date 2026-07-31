# frozen_string_literal: true

class Tweet < ApplicationRecord
  before_validation :generate_uuid, on: :create

  validates :uuid, presence: true, uniqueness: true
  validates :content, presence: true

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
