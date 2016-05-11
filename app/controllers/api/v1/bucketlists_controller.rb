class Api::V1::BucketlistsController < ApplicationController
  before_action :ensure_login
  before_action :pagination_integrity, only: :index
  def index
    q = params[:q]
    @bucketlists = q ? search(q) : current_user.bucketlists
    page = params[:page] || 1
    limit = params[:limit] || 20
    limit = limit.to_i > 100 ? 100 : limit.to_i
    paginate(page, limit)
  end

  def show
    bucket_list = Bucketlist.find_by(id: params[:id], user_id: current_user.id)
    head 404 unless bucket_list
    render json: bucket_list, root: false
  end

  def create
    bucket_list = Bucketlist.new(bucketlist_params)
    bucket_list.user_id = set_id
    if bucket_list.save
      render json: bucket_list, status: 201,
             location: [:api, :v1, bucket_list], root: false
    else
      render json: { errors: bucket_list.errors }, status: 422
    end
  end

  def update
    bucket_list = Bucketlist.find_by(id: params[:id], user_id: set_id)
    head 404 unless bucket_list
    bucket_list.name = params[:bucketlist][:name]
    if bucket_list.save
      render json: bucket_list, status: 200,
             location: [:api, :v1, bucket_list], root: false
    else
      render json: { errors: bucket_list.errors }, status: 422
    end
  end

  def destroy
    Bucketlist.delete_all(id: params[:id], user_id: set_id)
    head 204
  end

  private

  def bucketlist_params
    params.require(:bucketlist).permit(:name)
  end

  def search(query)
    current_user.bucketlists.select do |bucketlist|
      bucketlist.name.downcase.include? query.downcase
    end
  end

  def pagination_integrity
    head 404 unless params[:page] > 0 || params[:page].nil?
    head 404 unless params[:limit] > 0 || params[:limit].nil?
  end

  def paginate(page, records_per_page)
    page_offset = (page - 1) * limit
    bucketlists = @bucketlists.offset(page_offset).limit(records_per_page)
    if bucketlists.empty?
      render json: { error: "No bucketlist found" }, status: 404
    else
      render json: bucketlists, status: 200, root: false
    end
  end
end
