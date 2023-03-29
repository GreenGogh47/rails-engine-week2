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

        expect(Item.find_by_name_fragment('adventure')).to eq(item_3)
      end
    end
  end
end
