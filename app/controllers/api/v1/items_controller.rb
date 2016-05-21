class Api::V1::ItemsController < ApplicationController
  before_action :set_bucketlist
  before_action :find_item, except: :create
  include Rendering
  include FindBucketlist

  def create
    item = @bucketlist.items.new(item_params)
    if item.save
      successful_rendering(item, 201)
    else
      error_rendering(item)
    end
  end

  def update
    if @item.update(item_params)
      successful_rendering(@item, 200)
    else
      error_rendering(@item)
    end
  end

  def destroy
    @item.destroy
    render json: { success: language.successful_deletion("Item") }, status: 200
  end

  private

  def item_params
    params.permit(:name, :done)
  end

  def find_item
    @item = Item.find_by(bucketlist_id: @bucketlist.id, id: params[:id])
    render json: { error: language.not_found("Item") }, status: 404 unless @item
  end
end
