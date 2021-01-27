class CreateServices < ActiveRecord::Migration[6.0]
  def change
    create_table :services do |t|
      t.belongs_to :owner
      t.string :name
      t.float :price
      t.string :description

      t.timestamps
    end
  end
end
