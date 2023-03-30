require "rails_helper"

describe "Merchants API" do
  describe "merchant index happy path" do
    it "sends a list of ALL merchants" do
      create_list(:merchant, 5)

      get "/api/v1/merchants"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(5)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end

    xdescribe "merchant index sad path - extension" do
      it "sends an error if incorrect url" do
        create_list(:customer, 3)
  
        get "/api/v1/customerz"
  
        expect(response).to be({
          "message": "your query could not be completed",
          "errors": [
            "string of error message one",
            "string of error message two",
            "etc"
          ]
        })
      end
    end

    describe "merchant show happy path" do
      it "sends a list of ALL merchants" do
        merchant = create(:merchant, id: 1)
  
        get "/api/v1/merchants/1"
  
        expect(response).to be_successful
  
        merchant = JSON.parse(response.body, symbolize_names: true)
  
        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data][:id]).to be_an(String)

        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to be_a(String)
      end
    end

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

          expect(merchant_items[:data].count).to eq(4)

          merchant_items[:data].each do |item|
            expect(item).to have_key(:id)
            expect(item[:id]).to be_a(String)
    
            expect(item[:attributes]).to have_key(:name)
            expect(item[:attributes][:name]).to be_a(String)
    
            expect(item[:attributes]).to have_key(:description)
            expect(item[:attributes][:description]).to be_a(String)
    
            expect(item[:attributes]).to have_key(:unit_price)
            expect(item[:attributes][:unit_price]).to be_a(Float)
          end
        end
      end
    end

    describe "Merchant Search" do
      it "can find all merchants by name fragment" do
        merchant = create(:merchant, name: "Bob's Burgers")
        merchant2 = create(:merchant, name: "Rob's Burgers")
        merchant3 = create(:merchant, name: "Job's Burgers")
        merchant4 = create(:merchant, name: "Fish and Chips, a weekend experience")

        get "/api/v1/merchants/find_all?name=burgers"

        expect(response).to be_successful
      
        data = JSON.parse(response.body, symbolize_names: true)
        item = data[:data]
        
        expect(item.count).to eq(3)
        expect(item[0][:attributes][:name]).to eq(merchant.name)
        expect(item[1][:attributes][:name]).to eq(merchant3.name)
        expect(item[2][:attributes][:name]).to eq(merchant2.name)
      end
    end
  end
end