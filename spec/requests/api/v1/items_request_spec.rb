require "rails_helper"

describe "Items API Endpoint" do
  before(:each) do
    @merchant = create(:merchant, id: 1)
    create_list(:item, 5, merchant_id: 1)
  end

  describe "All Items (Index)" do
    it "can get a list of all items" do

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

  describe "One Item (Show)" do
    it "can get one item by its id" do
      get "/api/v1/items/#{Item.first.id}"

      expect(response).to be_successful

      data = JSON.parse(response.body, symbolize_names: true)
      item = data[:data]

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

  describe "Create Item" do
    it "can create a new item" do
      item_params = ({
        name: "New Item",
        description: "New Description",
        unit_price: 999.99,
        merchant_id: @merchant.id
      })

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      item = Item.last

      expect(response).to be_successful
      expect(item.name).to eq(item_params[:name])
      expect(item.description).to eq(item_params[:description])
      expect(item.unit_price).to eq(item_params[:unit_price])
      expect(item.merchant_id).to eq(item_params[:merchant_id])
    end

    it "can't create a new item with missing params" do
      item_params = ({
        name: "oof",
        unit_price: 99.99,
        merchant_id: @merchant.id
      })

      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "Update Item" do
    it "can update an existing item" do
      id = create(:item, merchant_id: 1).id
      previous_name = Item.last.name
      item_params = { name: "New Name" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to be_successful
      expect(item.name).to_not eq(previous_name)
      expect(item.name).to eq("New Name")
    end

    it "can't update an item with missing params" do
      id = create(:item, merchant_id: 1).id
      item_params = { name: "" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
      item = Item.find_by(id: id)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "Delete Item" do
    it "can delete an item" do
      id = create(:item, merchant_id: 1).id

      expect(Item.count).to eq(6)

      headers = {"CONTENT_TYPE" => "application/json"}
      delete "/api/v1/items/#{id}", headers: headers

      expect(response).to be_successful
      expect(Item.count).to eq(5)
      expect(Item.find_by(id: id)).to eq(nil)
    end

    xit "destroy any invoice if this was the only item on an invoice" do
      create(:invoice_item, item_id: 1)

    end
  end

  describe "Merchant info" do
    it "can get the merchant info for an item" do
      id = create(:item, merchant_id: 1).id

      get "/api/v1/items/#{id}/merchant"

      expect(response).to be_successful

      data = JSON.parse(response.body, symbolize_names: true)
      merchant = data[:data]

      expect(merchant[:id]).to eq(@merchant.id.to_s)
    end
  end

  describe "Item Search" do
    describe "happy path" do
      it "finds a the first item which matches a search term" do
        id2 = create(:item, name: "An AAAA Item", merchant_id: 1).id
        id = create(:item, name: "AAAAnItem", merchant_id: 1).id
        
        get "/api/v1/items/find?name=AAAA"

        expect(response).to be_successful
        
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data.count).to eq(1)
        
        item = data[:data]
        expect(item[:id]).to eq(id.to_s)
        expect(item[:id]).to_not eq(id2.to_s)
      end

      it "finds one item by min price" do
        id = create(:item, name: "AAAA Item", unit_price: 1000, merchant_id: 1).id
        id2 = create(:item, name: "AAAA Item 2", unit_price: 500, merchant_id: 1).id
        id3 = create(:item, name: "AAAA Item 3", unit_price: 1, merchant_id: 1).id

        get "/api/v1/items/find?min_price=999.00"

        expect(response).to be_successful

        data = JSON.parse(response.body, symbolize_names: true)
        expect(data.count).to eq(1)

        item = data[:data]
        expect(item[:id]).to eq(id.to_s)
        expect(item[:id]).to_not eq(id2.to_s)
        expect(item[:id]).to_not eq(id3.to_s)
      end
    end

    describe "sad path" do
      xit "returns an error if parameter is missing" do

      end

      xit "returns an error if parameter is empty" do

      end

      xit "cannot send both name and min_price" do

      end

      xit "cannot send both name and min_price and max_price" do
        
      end
    end
  end
end