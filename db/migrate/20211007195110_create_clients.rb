class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.references :person, null: false, foreign_key: true
      t.string :client_doc_number
      t.string :fantasy_name

      t.timestamps
    end
  end
end
