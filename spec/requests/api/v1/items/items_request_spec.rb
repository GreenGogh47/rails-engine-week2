require "rails_helper"

describe "Items API Endpoint" do
  describe "All Items (Index)" do
    it "can get a list of all items" do
      create(:merchant, id: 1)
      create_list(:item, 5, merchant_id: 1)

      get "/api/v1/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(5)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
      end
    end
  end
end