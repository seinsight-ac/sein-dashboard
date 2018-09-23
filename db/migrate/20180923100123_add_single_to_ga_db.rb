class AddSingleToGaDb < ActiveRecord::Migration[5.1]
  def change
    add_column :ga_dbs, :single_session, :integer
  end
end
