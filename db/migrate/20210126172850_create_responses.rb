class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.belongs_to :request
      t.string :text
      t.string :file

      t.timestamps
    end
  end
end
