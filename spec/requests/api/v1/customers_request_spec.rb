require "rails_helper"

describe "Customers API" do
  describe "happy path" do
    it "sends a list of customers" do
      create_list(:customer, 3)

      get "/api/v1/customers"

      expect(response).to be_successful

      customers = JSON.parse(response.body, symbolize_names: true)

      expect(customers.count).to eq(3)

      customers.each do |customer|
        expect(customer).to have_key(:id)
        expect(customer[:id]).to be_an(Integer)

        expect(customer).to have_key(:first_name)
        expect(customer[:first_name]).to be_a(String)

        expect(customer).to have_key(:last_name)
        expect(customer[:last_name]).to be_a(String)
      end
    end

    xdescribe "sad path - extension" do
      it "sends an error if incorrect url" do
        create_list(:customer, 3)
  
        get "/api/v1/customerz"

        require 'pry'; binding.pry
  
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
  end
end