class Api::V1::Item::SearchController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.where("name LIKE ?", "%#{params[:name]}%").order(:name).first)
  end
end