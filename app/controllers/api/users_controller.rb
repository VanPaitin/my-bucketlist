class Api::UsersController < ApplicationController
  before_action :find_user, only: [:show, :update]
  def show
    render json: @user unless @user.nil?
    head 404
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    head 404 unless @user
    if @user.update(user_params)
      render json: @user, status: 201, location: [:api, @user]
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def destroy
    User.delete_all(id: set_id)
    head 204
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def find_user
    @user = User.find_by_id(set_id)
  end
end
