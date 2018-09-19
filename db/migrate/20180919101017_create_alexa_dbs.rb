class CreateAlexaDbs < ActiveRecord::Migration[5.1]
  def change
    create_table :alexa_dbs do |t|
      t.integer :sein_rank
      t.integer :newsmarket_rank
      t.integer :pansci_rank
      t.integer :einfo_rank
      t.integer :npost_rank
      t.integer :womany_rank

      t.integer :sein_bounce_rate
      t.integer :newsmarket_bounce_rate
      t.integer :pansci_bounce_rate
      t.integer :einfo_bounce_rate
      t.integer :npost_bounce_rate
      t.integer :womany_bounce_rate

      t.integer :sein_pageview
      t.integer :newsmarket_pageview
      t.integer :pansci_pageview
      t.integer :einfo_pageview
      t.integer :npost_pageview
      t.integer :womany_pageview

      t.integer :sein_on_site
      t.integer :newsmarket_on_site
      t.integer :pansci_on_site
      t.integer :einfo_on_site
      t.integer :npost_on_site
      t.integer :womany_on_site

      t.timestamps
    end
  end
end
