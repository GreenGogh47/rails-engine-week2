require "rails_helper"

describe "Merchants API" do
  describe "merchant index happy path" do
    it "sends a list of ALL merchants" do
      create_list(:merchant, 5)

      get "/api/v1/merchants"

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.count).to eq(5)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(Integer)

        expect(merchant).to have_key(:name)
        expect(merchant[:name]).to be_a(String)
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
  
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(Integer)

        expect(merchant).to have_key(:name)
        expect(merchant[:name]).to be_a(String)
      end
    end
  end
end