class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.belongs_to :owner
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
