class CreateMailchimpDbs < ActiveRecord::Migration[5.1]
  def change
    create_table :mailchimp_dbs do |t|
      t.datetime :date
      t.string :title
      t.integer :email_sent
      t.integer :open
      t.integer :open_rate
      t.integer :click
      t.integer :click_rate
      t.string :most_click_title
      t.integer :most_click_time

      t.timestamps
    end
  end
end
