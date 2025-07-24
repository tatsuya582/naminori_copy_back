# frozen_string_literal: true

require "warden/jwt_auth"

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  include JwtCookieHelper
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)

    if self.resource
      sign_in(resource_name, resource)
      set_jwt_cookie(resource)
      render json: { message: "ログインに成功しました", user: resource }, status: :ok
    else
      render json: { message: "ログインに失敗しました", errors: [ "メールアドレスまたはパスワードが正しくありません" ] }, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private

  def respond_with(resource, _opts = {})
    render json: { message: "Logged in successfully.", user: resource }, status: :ok
  end

  def respond_to_on_destroy
    delete_jwt_cookie
    render json: { message: "Logged out successfully." }, status: :ok
  end
end
