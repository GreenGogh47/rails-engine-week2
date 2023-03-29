class Api::V1::Merchant::SearchController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find_by_name_fragment(params[:name]))
  end
end