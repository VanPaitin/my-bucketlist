class Api::V1::BucketlistsController < ApplicationController
  # before_action :ensure_login
  def index
    bucket_lists = current_user.bucketlists
    render json: bucket_lists
  end

  def show
    bucket_list = Bucketlist.find(params[:id])
    render json: bucket_list
  end

  def create
    bucket_list = Bucketlist.new(bucketlist_params)
    # bucket_list.user_id = current_user.id
    if bucket_list.save
      render json: bucket_list, status: 201, location: [:api, :v1, bucket_list],
        root: false
    else
      render json: { errors: bucket_list.errors }, status: 422
    end
  end

  def update
    bucket_list = Bucketlist.find_by_id(params[:id])
    bucket_list.update_attributes(name: params[:bucketlist][:name])
    if bucket_list.save
      render json: bucket_list, status: 201, location: [:api, :v1, bucket_list]
    else
      render json: { errors: bucket_list.errors }, status: 422
    end
  end

  def destroy
    Bucketlist.delete_all(id: params[:id])
    redirect_to :index
  end

  private

  def bucketlist_params
    params.require(:bucketlist).permit(:name)
  end
end
