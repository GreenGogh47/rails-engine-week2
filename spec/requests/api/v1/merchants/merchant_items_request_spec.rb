require "rails_helper"

describe "Merchants Items Endpoint" do
  describe "happy path" do
    it "sends a list of a merchants items" do
      create(:merchant, id: 1)
      create(:item, merchant_id: 1)
      create(:item, merchant_id: 1)
      create(:item, merchant_id: 1)
      create(:item, merchant_id: 1)

      get "/api/v1/merchants/1/items"

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_items.count).to eq(4)

      merchant_items.each do |merchant_item|
        expect(merchant_item).to have_key(:id)
        expect(merchant_item[:id]).to be_an(Integer)

        expect(merchant_item).to have_key(:name)
        expect(merchant_item[:name]).to be_a(String)

        expect(merchant_item).to have_key(:description)
        expect(merchant_item[:description]).to be_a(String)

        expect(merchant_item).to have_key(:unit_price)
        expect(merchant_item[:unit_price]).to be_a(Float)
      end
    end
  end
end