class CreateResources < ActiveRecord::Migration[8.1]
  def change
    create_table :resources do |t|
      t.references :tweet, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.string :url, null: false
      t.string :image_url, null: false
      t.integer :image_byte_size, null: false

      t.timestamps
    end
  end
end
