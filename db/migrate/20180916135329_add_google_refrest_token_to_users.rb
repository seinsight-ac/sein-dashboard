class AddGoogleRefrestTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :fb_uid
    remove_column :users, :fb_token
    remove_column :users, :name
    add_column :users, :google_refresh_token, :string
  end
end
