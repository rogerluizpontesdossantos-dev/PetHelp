class CreateAdoptionRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :adoption_requests do |t|
      t.references :adopter, null: false, foreign_key: { to_table: :users }
      t.references :pet, null: false, foreign_key: true
      t.text :message
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :adoption_requests, :status
    add_index :adoption_requests, [:pet_id, :adopter_id], unique: true,
      where: "status IN ('pending', 'accepted')",
      name: "index_unique_active_request_per_pet_and_adopter"
  end
end
