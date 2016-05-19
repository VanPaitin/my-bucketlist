class Api::V1::BucketlistsController < ApplicationController
  before_action :set_bucketlist, except: [:index, :create]
  include Rendering
  include FindBucketlist

  def index
    page = Pagination.new(params, get_bucketlists)
    if page.paginate
      render json: page.paginate, root: false, status: 200
    else
      render json: { message: "No records found" }, status: 404
    end
  end

  def show
    render json: @bucketlist, root: false
  end

  def create
    bucketlist = current_user.bucketlists.new(bucketlist_params)
    if bucketlist.save
      successful_rendering(bucketlist, 201)
    else
      error_rendering(bucketlist)
    end
  end

  def update
    if @bucketlist.update(bucketlist_params)
      successful_rendering(@bucketlist, 200)
    else
      error_rendering(@bucketlist)
    end
  end

  def destroy
    @bucketlist.destroy
    render json: { success: "bucketlist destroyed successfully" }, status: 200
  end

  private

  def bucketlist_params
    params.permit(:name)
  end

  def get_bucketlists(search_term = params[:q])
    if search_term
      Bucketlist.search(current_user, search_term)
    else
      current_user.bucketlists
    end
  end
end
