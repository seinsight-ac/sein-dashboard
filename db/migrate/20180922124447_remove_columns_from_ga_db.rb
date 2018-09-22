class RemoveColumnsFromGaDb < ActiveRecord::Migration[5.1]
  def change
    remove_column :ga_dbs, :active_users_day
    remove_column :ga_dbs, :active_users_week
    remove_column :ga_dbs, :active_users_month
    remove_column :ga_dbs, :bouce_rate_week
    remove_column :ga_dbs, :bouce_rate_month
    remove_column :ga_dbs, :avg_time_on_page_week
    remove_column :ga_dbs, :avg_time_on_page_month
    add_column :ga_dbs, :referral_bounce, :float
  end
end
