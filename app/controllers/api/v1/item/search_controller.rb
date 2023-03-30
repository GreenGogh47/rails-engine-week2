class Api::V1::Item::SearchController < ApplicationController
  def show
    if params[:name].present?
      render json: ItemSerializer.new(Item.find_by_name_fragment(params[:name]))
    elsif params[:min_price].present?
      render json: ItemSerializer.new(Item.find_by_min_price(params[:min_price]))
    elsif params[:max_price].present?
      render json: ItemSerializer.new(Item.find_by_max_price(params[:max_price]))
    end
  end
end