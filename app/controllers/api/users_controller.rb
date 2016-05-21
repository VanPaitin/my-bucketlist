class Api::UsersController < ApplicationController
  skip_before_action :ensure_login, only: :create
  before_action :find_user, except: :create

  def show
    render json: @user, root: false
  end

  def create
    @user = User.new(user_params)
    if @user.save
      token = issue_token
      render json: { success: language.successful_creation, auth_token: token,
                     user_details: UserSerializer.new(@user) }, status: 201
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, root: false, status: 200, location: [:api, @user]
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def destroy
    @user.destroy
    render json: { success: language.successful_deletion("Account") },
           status: 200
  end

  private

  def user_params
    params.permit(:name, :email, :password,
                  :password_confirmation)
  end

  def find_user
    @user = User.find_by_id(set_id)
  end
end
