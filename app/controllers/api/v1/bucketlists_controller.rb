class Api::V1::BucketlistsController < ApplicationController
  before_action :ensure_login
  def index
    q = params[:q]
    search(q) if q
    page = params[:page]
    limit = params[:limit]
    bucket_lists = current_user.bucketlists
    Bucketlist.paginate(bucket_lists, page, limit)
    render json: bucket_lists
  end

  def show
    bucket_list = Bucketlist.find(params[:id])
    render json: bucket_list, root: false
  end

  def create
    bucket_list = Bucketlist.new(bucketlist_params)
    bucket_list.user_id = current_user.id
    if bucket_list.save
      render json: bucket_list, status: 201, location: [:api, :v1, bucket_list],
             root: false
    else
      render json: { errors: bucket_list.errors }, status: 422
    end
  end

  def update
    bucket_list = Bucketlist.find_by(id: params[:id], user_id: current_user.id)
    bucket_list.update_attributes(name: params[:bucketlist][:name])
    if bucket_list.save
      render json: bucket_list, status: 200, location: [:api, :v1, bucket_list]
    else
      render json: { errors: bucket_list.errors }, status: 422
    end
  end

  def destroy
    Bucketlist.delete_all(id: params[:id])
    head 204
  end

  private

  def bucketlist_params
    params.require(:bucketlist).permit(:name)
  end

  def search(query)
    results = current_user.bucketlists.select do |bucketlist|
                bucketlist.name.downcase.include? query.downcase
              end
    if results.length > 0
      render json: results, status: 200
    else
      head 404
    end
  end
end
