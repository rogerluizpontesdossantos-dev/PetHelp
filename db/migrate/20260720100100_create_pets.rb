class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.integer :species, null: false, default: 0
      t.integer :size, null: false, default: 0
      t.text :description
      t.string :city, null: false
      t.string :state, null: false
      t.string :status, null: false, default: "available"
      t.boolean :vaccination_status, null: false, default: false

      t.timestamps
    end

    add_index :pets, :status
    add_index :pets, :city
    add_index :pets, :species
  end
end
