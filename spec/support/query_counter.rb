# frozen_string_literal: true

# Counts the database queries a block of code runs, so specs can assert that a
# query count stays constant instead of growing with the size of the data set.
module QueryCounter
  IGNORED_QUERY_NAMES = [ "SCHEMA", "TRANSACTION" ].freeze

  def count_queries(&block)
    count = 0

    counter = lambda do |_name, _started, _finished, _id, payload|
      count += 1 unless IGNORED_QUERY_NAMES.include?(payload[:name])
    end

    ActiveSupport::Notifications.subscribed(counter, "sql.active_record", &block)

    count
  end
end

RSpec.configure do |config|
  config.include QueryCounter
end
