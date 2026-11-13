class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :reviewer, null: false, foreign_key: { to_table: :users }
      t.references :reviewee, null: false, foreign_key: { to_table: :users }
      t.references :adoption_request, null: false, foreign_key: true
      t.integer :rating, null: false
      t.string :comment, limit: 500

      t.timestamps
    end

    add_index :reviews, [:adoption_request_id, :reviewer_id], unique: true,
      name: "index_reviews_one_per_reviewer_per_request"
  end
end
