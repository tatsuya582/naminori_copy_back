# frozen_string_literal: true

module Api
  module V1
    class AuthCallbacksController < ApplicationController
      # CSRF保護を無効にする（APIのため）
      protect_from_forgery with: :null_session, only: [:create]

      # POST /api/v1/auth/callback
      def create
        # 'credentials' パラメータからemailとpasswordを取得
        credentials = params.require(:credentials).permit(:email, :password)
        email = credentials[:email].downcase
        password = credentials[:password]

        # emailでユーザーを検索
        user = User.find_for_database_authentication(email: email)

        # ユーザーが存在し、パスワードが有効な場合
        if user&.valid_password?(password)
          # Wardenにユーザーを設定してログイン状態を確立
          warden.set_user(user, scope: :user)

          # JWTを生成
          token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first

          # レスポンスヘッダーにJWTを設定
          response.headers['Authorization'] = "Bearer #{token}"

          # Auth.jsが期待する形式でユーザー情報を返す
          render json: {
            id: user.id,
            name: "#{user.last_name} #{user.first_name}",
            email: user.email
            # 必要に応じて他のユーザー情報もここに追加
          }, status: :ok
        else
          # 認証失敗
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    end
  end
end