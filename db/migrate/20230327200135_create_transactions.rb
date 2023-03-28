class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.bigint :invoice_id
      t.string :credit_card_number
      t.string :credit_card_expiration_date

      t.timestamps
    end
  end
end
