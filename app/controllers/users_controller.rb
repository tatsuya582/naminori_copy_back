class UsersController < ApplicationController
  include RackSessionFix
  before_action :set_jwt_from_cookie, only: [ :me ]
  before_action :authenticate_user!
  def me
    render json: current_user, status: :ok
  end

  private
  def set_jwt_from_cookie
    if cookies.signed[:jwt]
      request.headers["Authorization"] = "Bearer #{cookies.signed[:jwt]}"
    end
  end
end
