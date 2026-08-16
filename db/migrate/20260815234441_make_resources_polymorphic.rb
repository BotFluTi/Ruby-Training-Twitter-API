class MakeResourcesPolymorphic < ActiveRecord::Migration[8.1]
  def up
    add_reference :resources, :resourceable, polymorphic: true, null: true

    execute(<<~SQL.squish)
      UPDATE resources
      SET resourceable_type = 'Tweet', resourceable_id = tweet_id
    SQL

    change_column_null :resources, :resourceable_type, false
    change_column_null :resources, :resourceable_id, false

    remove_reference :resources, :tweet, null: false, foreign_key: true
  end

  def down
    add_reference :resources, :tweet, null: true, foreign_key: true

    execute(<<~SQL.squish)
      UPDATE resources
      SET tweet_id = resourceable_id
      WHERE resourceable_type = 'Tweet'
    SQL

    execute("DELETE FROM resources WHERE resourceable_type != 'Tweet'")

    change_column_null :resources, :tweet_id, false

    remove_reference :resources, :resourceable, polymorphic: true, null: false
  end
end
