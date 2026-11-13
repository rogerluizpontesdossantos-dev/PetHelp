class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :cpf, null: false
      t.string :phone, null: false
      t.string :password_digest, null: false
      t.decimal :reputation_score, precision: 3, scale: 2, default: 0.0, null: false
      t.integer :reviews_count, default: 0, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :cpf, unique: true
  end
end
