class RemoveWeekFromGaDb < ActiveRecord::Migration[5.1]
  def change
    remove_column :ga_dbs, :social_user_week
    remove_column :ga_dbs, :social_user_month
    remove_column :ga_dbs, :oganic_search_week
    remove_column :ga_dbs, :oganic_search_month
  end
end
