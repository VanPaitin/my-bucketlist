class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && !!user.authenticate(params[:password])
      log_in user
      render json: { success: "Successfully logged in" }, status: 200
    else
      render json: { error: "invalid email/password combination" }, status: 422
    end
  end

  def destroy
  end
end
