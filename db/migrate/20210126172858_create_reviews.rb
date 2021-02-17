class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.belongs_to :response
      t.string :text
      t.integer :rate
      t.string :file

      t.timestamps
    end
  end
end
