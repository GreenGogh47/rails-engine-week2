require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }
  end

  describe 'class methods' do
    describe '::find_by_name_fragment' do
      it 'returns the first (alpha) item that matches the fragment' do
        merchant = create(:merchant)
        item_1 = create(:item, name: 'Timmys Adventure', merchant: merchant)
        item_2 = create(:item, name: 'Johns Adventure', merchant: merchant)
        item_3 = create(:item, name: 'Allisons Adventure', merchant: merchant)

        expect(Item.find_by_name_fragment('advent')).to eq(item_3)
      end
    end

    describe '::find_by_min_price' do
      it 'returns the first (alpha) item that matches the min price' do
        merchant = create(:merchant, id: 1)
        i1 = create(:item, name: "AAAA Item", unit_price: 1000, merchant_id: 1)
        i2 = create(:item, name: "AAAA Item 2", unit_price: 500, merchant_id: 1)
        i3 = create(:item, name: "AAAA Item 3", unit_price: 1, merchant_id: 1)
        i4 = create(:item, name: "AAAB Item 4", unit_price: 1, merchant_id: 1)

        expect(Item.find_by_min_price(1.00)).to eq(i3)
        expect(Item.find_by_min_price(1.00)).to_not eq(i4)
      end
    end
  end
end
