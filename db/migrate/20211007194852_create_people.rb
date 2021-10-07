class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.integer :doc_number
      t.string :phone_number
      t.string :address
      t.string :sex
      t.references :project, null: true, foreign_key: true
      t.references :role, null: true, foreign_key: true
      t.references :country, null: true, foreign_key: true

      t.timestamps
    end
  end
end
