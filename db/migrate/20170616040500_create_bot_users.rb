class CreateBotUsers < ActiveRecord::Migration
  def change
    create_table :bot_users do |t|
      t.string :botname
      t.string :clientid
      t.string :clientsecret
      t.string :channeluser
      t.string :channelname
      t.string :redirecturi
      t.string :botoauth
      t.string :useroauth

      t.timestamps null: false
    end
  end
end
