class RemoveGoogleLoginDataFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :google_uid
    remove_column :users, :google_token
    remove_column :users, :google_refresh_token
    remove_column :users, :sign_in_count
  end
end
