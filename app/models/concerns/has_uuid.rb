# frozen_string_literal: true

module HasUuid
  extend ActiveSupport::Concern

  included do
    before_validation :generate_uuid, on: :create

    validates :uuid, presence: true, uniqueness: true
  end

  private

  def generate_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
