class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.belongs_to :request
      t.float :service_price
      t.float :net
      t.float :commission
      t.column :status, :integer, defoult: 0

      t.timestamps
    end
  end
end
