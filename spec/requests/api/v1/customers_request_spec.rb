require "rails_helper"

describe "Customers API" do
  it "sends a list of customers" do
    create_list(:customer, 3)

    get "/api/vi/customers"

    expect(response).to be_successful
  end
end