class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.bigint :customer_id
      t.bigint :merchant_id
      t.string :status

      t.timestamps
    end
  end
end
