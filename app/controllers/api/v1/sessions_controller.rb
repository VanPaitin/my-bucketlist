class Api::V1::SessionsController < ApplicationController
  skip_before_action :ensure_login, only: :create
  before_action :set_user, only: :create

  def create
    if @user && @user.authenticate(params[:password])
      token = JsonWebToken.issue_token(@user)
      render json: { success: language.login, auth_token: token },
             status: 200
    else
      render json: { error: language.wrong_email_or_password },
             status: 422
    end
  end

  def destroy
    current_user.update_attribute(:logged_in, false)
    @current_user = nil
    render json: { success: language.logout }, status: 200
  end

  private

  def set_user
    @user = User.find_by(email: params[:email].downcase)
  rescue
    render json: { email: language.invalid_email }, status: 400
  end
end
