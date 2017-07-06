class CreatePointConfigs < ActiveRecord::Migration
  def change
    create_table :point_configs do |t|
      t.string :name
      t.integer :period
      t.integer :points


      t.timestamps null: false
    end
  end
end
