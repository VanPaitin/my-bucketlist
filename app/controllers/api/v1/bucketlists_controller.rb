class Api::V1::BucketlistsController < ApplicationController
  before_action :ensure_login
  before_action :set_bucketlist, except: [:index, :create]
  def index
    q = params[:q]
    bucketlists = get_bucketlists(q)
    page = Pagination.new(params, bucketlists)
    if !page.paginate.empty?
      render json: page.paginate, root: false, status: 200
    else
      render json: { message: "No records found" }, status: 404
    end
  end

  def show
    render json: @bucketlist, root: false
  end

  def create
    @bucketlist = current_user.bucketlists.new(bucketlist_params)
    if @bucketlist.save
      successful_rendering(201)
    else
      error_rendering
    end
  end

  def update
    if @bucketlist.update(bucketlist_params)
      successful_rendering(200)
    else
      error_rendering
    end
  end

  def destroy
    @bucketlist.destroy
    head 204
  end

  private

  def bucketlist_params
    params.require(:bucketlist).permit(:name)
  end

  def successful_rendering(status)
    render json: @bucketlist, status: status,
           location: [:api, :v1, @bucketlist], root: false
  end

  def error_rendering
    render json: { errors: @bucketlist.errors }, status: 422
  end

  def set_bucketlist
    @bucketlist = Bucketlist.find_by(query_conditions)
    head 404 unless @bucketlist
  end

  def get_bucketlists(q)
    if q
      Bucketlist.search(current_user, q)
    else
      current_user.bucketlists
    end
  end
end
