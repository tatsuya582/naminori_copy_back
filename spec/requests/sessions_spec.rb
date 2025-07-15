require 'rails_helper'

RSpec.describe "User Login API", type: :request do
  let!(:user) { create(:user, email: "login@example.com", password: "password123", password_confirmation: "password123") }

  let(:valid_params) do
    {
      user: {
        email: "login@example.com",
        password: "password123"
      }
    }
  end

  let(:invalid_params) do
    {
      user: {
        email: "login@example.com",
        password: "wrongpassword"
      }
    }
  end

  describe "POST /login" do
    it "logs in the user with valid credentials" do
      post "/login", params: valid_params

      expect(response).to have_http_status(:ok).or have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Logged in successfully.")
      expect(response.headers["Authorization"]).to be_present
    end

    it "fails to log in with invalid credentials" do
      post "/login", params: invalid_params

      expect(response).to have_http_status(:unauthorized).or have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Invalid Email or password.")
    end
  end
end
