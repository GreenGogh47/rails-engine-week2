class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.find_all_by_name_fragment(fragment)
    where("name ILIKE ?", "%#{fragment}%").order(:name)
  end
end
