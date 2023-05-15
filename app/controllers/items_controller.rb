class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find_by(id: params[:user_id])
      if user
        items = user.items
        render json: items
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = Item.find(params[:id])
    render json: item, include: :user
  end

  def create
    user = User.find_by(id: params[:user_id])
    if user
      item = user.items.create(item_params)
      render json: item, status: :created
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def render_not_found_response
    render json: { error: 'Item not found' }, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end
end
