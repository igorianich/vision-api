class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.string :description
      t.column :role, :integer, default: 0
      t.integer :balance, default: 0

      t.timestamps
    end
  end
end
