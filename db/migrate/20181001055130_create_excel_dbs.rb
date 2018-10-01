class CreateExcelDbs < ActiveRecord::Migration[5.1]
  def change
    create_table :excel_dbs do |t|
      t.string :start
      t.string :before
      t.timestamps
    end
  end
end
