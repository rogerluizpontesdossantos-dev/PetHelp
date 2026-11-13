class CreateFollowUps < ActiveRecord::Migration[7.1]
  def change
    create_table :follow_ups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true
      t.string :milestone, null: false # day7, day30, day90
      t.string :status, null: false, default: "pending"
      t.date :due_date, null: false
      t.datetime :answered_at
      t.integer :well_being_rating
      t.text :notes

      t.timestamps
    end

    add_index :follow_ups, :status
    add_index :follow_ups, :due_date
    add_index :follow_ups, [:pet_id, :user_id, :milestone], unique: true,
      name: "index_follow_ups_uniqueness"
  end
end
