class CreateCommands < ActiveRecord::Migration
  def change
    create_table :commands do |t|
      t.string :name
      t.text :text
      t.integer :args

      t.timestamps null: false
    end
  end
end
