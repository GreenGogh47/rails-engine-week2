class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price, :merchant_id

  def self.find_by_name_fragment(fragment)
    where("name ILIKE ?", "%#{fragment}%").order(:name).first
  end

  def self.find_by_min_price(price)
    where("unit_price >= ?", price).order(:name).first
  end
end
