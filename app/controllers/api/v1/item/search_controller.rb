class Api::V1::Item::SearchController < ApplicationController
  def show
    if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
      render json: { data: {} }
    elsif params[:name].present?
      item = Item.find_by_name_fragment(params[:name])
      if item != nil
        render json: ItemSerializer.new(item)
      else
        render json: { data: {} }
      end
    elsif params[:min_price].present? && params[:max_price].present?
      min_max_item = Item.where("unit_price >= ? AND unit_price <= ?", params[:min_price], params[:max_price]).order(:name).first
      if min_max_item != nil
        render json: ItemSerializer.new(min_max_item)
      else
        render json: { data: {} }
      end
    elsif params[:min_price].present?
      min_item = Item.find_by_min_price(params[:min_price])
      if min_item != nil
        render json: ItemSerializer.new(min_item)
      else
        render json: { data: {} }
      end
    elsif params[:max_price].present?
      max_item = Item.find_by_max_price(params[:max_price])
      if max_item != nil
        render json: ItemSerializer.new(max_item)
      else
        render json: { data: {} }
      end
    else
      render json: { errors: item.errors.full_messages }, status: :unprocessable_entity
    end
  end
end