class Api::V1::SessionsController < ApplicationController
  skip_before_action :ensure_login, only: :create
  before_action :set_user, only: :create

  def create
    if @user && @user.authenticate(params[:password])
      token = issue_token
      render json: { success: "Successfully logged in", auth_token: token },
             status: 200
    else
      render json: { error: "invalid email/password combination" },
             status: 422
    end
  end

  def destroy
    current_user.update_attribute(:logged_in, false)
    @current_user = nil
    render json: { success: "You are logged out now" }, status: 200
  end

  private

  def set_user
    @user = User.find_by(email: params[:email].downcase)
  rescue
    render json: { email: "please pass in a valid email address" },
           status: 400
  end
end
