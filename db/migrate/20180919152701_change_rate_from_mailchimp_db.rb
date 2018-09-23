class ChangeRateFromMailchimpDb < ActiveRecord::Migration[5.1]
  def change
    change_column :mailchimp_dbs, :open_rate, :float
    change_column :mailchimp_dbs, :click_rate, :float
  end
end
