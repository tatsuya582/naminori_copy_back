# frozen_string_literal: true

require "warden/jwt_auth"

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  include JwtCookieHelper

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)

    if self.resource
      sign_in(resource_name, resource)
      set_jwt_cookie(resource)
      render json: { message: "Logged in successfully." }, status: :ok
    else
      render json: { error: "Invalid Email or password." }, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  # ルーティング層で認証が保証されているため、単純にsuperを呼ぶだけで良い
  def destroy
    super
  end

  private

  def respond_with(resource, _opts = {})
    # このメソッドは現在のcreateアクションからは呼ばれていませんが、念のため残します
    render json: { message: "Logged in successfully.", user: resource }, status: :ok
  end

  def respond_to_on_destroy
    delete_jwt_cookie
    render json: { message: "Logged out successfully." }, status: :ok
  end
end