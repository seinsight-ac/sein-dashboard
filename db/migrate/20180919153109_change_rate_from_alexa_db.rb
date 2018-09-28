class ChangeRateFromAlexaDb < ActiveRecord::Migration[5.1]
  def change
    change_column :alexa_dbs, :newsmarket_bounce_rate, :float
    change_column :alexa_dbs, :pansci_bounce_rate, :float
    change_column :alexa_dbs, :einfo_bounce_rate, :float
    change_column :alexa_dbs, :npost_bounce_rate, :float
    change_column :alexa_dbs, :womany_bounce_rate, :float
    change_column :alexa_dbs, :sein_bounce_rate, :float
    change_column :alexa_dbs, :sein_pageview, :float
    change_column :alexa_dbs, :newsmarket_pageview, :float
    change_column :alexa_dbs, :pansci_pageview, :float
    change_column :alexa_dbs, :einfo_pageview, :float
    change_column :alexa_dbs, :npost_pageview, :float
    change_column :alexa_dbs, :womany_pageview, :float
  end
end
