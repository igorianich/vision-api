# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.belongs_to :request
      t.belongs_to :payer
      t.belongs_to :seller
      t.float :service_price
      t.float :net
      t.float :commission
      t.column :status, :integer, defoult: 0

      t.timestamps
    end
  end
end
