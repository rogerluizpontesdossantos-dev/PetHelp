class CreateAdoptionTerms < ActiveRecord::Migration[7.1]
  def change
    create_table :adoption_terms do |t|
      t.references :adoption_request, null: false, foreign_key: true, index: { unique: true }
      t.text :content, null: false
      t.datetime :signed_at

      t.timestamps
    end
  end
end
