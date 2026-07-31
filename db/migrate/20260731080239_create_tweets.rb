class CreateTweets < ActiveRecord::Migration[8.1]
  def change
    create_table :tweets do |t|
      t.string :uuid, null: false
      t.text :content, null: false

      t.timestamps
    end

    add_index :tweets, :uuid, unique: true
  end
end
