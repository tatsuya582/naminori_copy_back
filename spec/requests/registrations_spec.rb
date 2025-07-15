require 'rails_helper'

RSpec.describe "User Registration API", type: :request do
  let(:valid_params) do
    {
      user: {
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123",
        first_name: "太郎",
        last_name: "山田",
        first_name_kana: "たろう",
        last_name_kana: "やまだ",
        birth_date: "2000-01-01",
        phone_number: "09012345678",
        gender: "male",
        prefecture: "東京都"
      }
    }
  end

  let(:invalid_params) do
    {
      user: {
        email: "",
        password: "short",
        password_confirmation: "mismatch"
      }
    }
  end

  describe "POST /signup" do
    it "creates a new user with valid params" do
      post "/signup", params: valid_params

      expect(response).to have_http_status(:created).or have_http_status(:ok)
      expect(JSON.parse(response.body)["user"]["email"]).to eq("test@example.com")
      expect(response.headers["Authorization"]).to be_present
    end

    it "returns errors with invalid params" do
      post "/signup", params: invalid_params

      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to have_key("errors").or have_key("message")
    end

    it "returns an error when email is already taken" do
      # 先にユーザーを作成しておく
      post "/signup", params: valid_params
      expect(response).to have_http_status(:created).or have_http_status(:ok)

      # 同じemailで再登録を試みる
      post "/signup", params: valid_params

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Signed up failure.")
      expect(json["errors"]).to include("Email has already been taken")
    end
  end
end
