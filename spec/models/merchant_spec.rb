require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoice_items }
    it { should have_many :invoices }
    it { should have_many :customers }
    it { should have_many :transactions }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'class methods' do
    describe '.find_all_by_name_fragment' do
      it 'returns merchants that matches the fragment' do
        merchant_1 = create(:merchant, name: 'Bob')
        merchant_2 = create(:merchant, name: 'Bobby')
        merchant_3 = create(:merchant, name: 'Bobert')
        merchant_4 = create(:merchant, name: 'tim')

        expect(Merchant.find_all_by_name_fragment('bOb')).to eq([merchant_1, merchant_2, merchant_3])
      end
    end
  end
end
