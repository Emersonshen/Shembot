class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers do |t|
      t.string :name
      t.integer :points

      t.timestamps null: false
    end
  end
end
