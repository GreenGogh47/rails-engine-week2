class Api::V1::Merchant::SearchController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find_all_like(params[:name]))
  end
end