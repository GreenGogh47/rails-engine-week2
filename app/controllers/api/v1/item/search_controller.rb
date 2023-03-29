class Api::V1::Item::SearchController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.find_by_name_fragment(params[:name]))
  end
end