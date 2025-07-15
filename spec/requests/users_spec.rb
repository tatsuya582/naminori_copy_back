require 'rails_helper'

RSpec.describe "GET /me", type: :request do
  let!(:user) do
    create(:user, email: "me@example.com", password: "password123", password_confirmation: "password123")
  end

  let(:login_params) do
    {
      user: {
        email: "me@example.com",
        password: "password123"
      }
    }
  end

  it "returns current user info when authorized" do
    # 1. ログインしてJWTを取得
    post "/login", params: login_params
    token = response.headers["Authorization"]

    # 2. JWT付きで /me を叩く
    get "/me", headers: { "Authorization" => token }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["email"]).to eq("me@example.com")
    expect(json["first_name"]).to eq(user.first_name)
    expect(json["last_name"]).to eq(user.last_name)
  end

  it "returns unauthorized without JWT" do
    get "/me"
    expect(response).to have_http_status(:unauthorized)
  end
end
