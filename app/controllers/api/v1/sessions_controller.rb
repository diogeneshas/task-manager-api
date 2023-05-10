class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_param[:email])

    if user && user.valid_password?(session_param[:password])
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200
    else
      render json: { error: "Invalid email or password" }, status: 401
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end

  private

  def session_param
    params.require(:sessions).permit(:email, :password)
  end
end
