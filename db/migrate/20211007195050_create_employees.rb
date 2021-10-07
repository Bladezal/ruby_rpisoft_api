class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      t.references :person, null: false, foreign_key: true
      t.string :section
      t.float :salary
      t.date :start_date

      t.timestamps
    end
  end
end
