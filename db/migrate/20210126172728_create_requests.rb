class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.belongs_to :requester
      t.belongs_to :service
      t.string :text
      t.string :file
      t.column :status, :integer, defoult: 0

      t.timestamps
    end
  end
end
