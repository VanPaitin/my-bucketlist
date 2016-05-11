class Api::V1::SessionsController < ApplicationController
  before_action :set_user
  def create
    if @user && !!@user.authenticate(params[:user][:password])
      @user.update_attribute(:logged_in, true)
      token = JsonWebToken.encode user_id: @user.id
      render json: { auth_token: token }, status: 200
    else
      render json: { error: "invalid email/password combination" },
             status: 422
    end
  end

  def destroy
    if @user
      @user.update_attribute(:logged_in, false)
    else
      head 404
    end
    @current_user = nil
    render json: { msg: "You are logged out now" }, status: 200
  end

  private

  def set_user
    @user = User.find_by(email: params[:user][:email].downcase)
  end
end
