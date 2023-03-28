class Api::V1::Merchant::ItemsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find(params[:merchant_id]))
  end
end