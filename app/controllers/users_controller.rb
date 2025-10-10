class UsersController < ApplicationController
  include RackSessionFix
  before_action :authenticate_user!

  def me
    # テストがユーザーオブジェクト全体を期待しているため、current_userを直接返すように修正
    render json: current_user, status: :ok
  end
end