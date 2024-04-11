require 'spec_helper'
require "rails_helper"

RSpec.describe "Authentication", type: :request do
  describe "POST /api/v1/auth" do
    let(:created_user) { User.find_by(email: req_params[:email]) }
    let(:req_params) do
      { email: "pupa@acc.com", password: "12345678", password_confirmation: "12345678" }
    end

    def do_request = post("/api/v1/auth", params: req_params)

    before { do_request }

    it "sign up user" do
      expect(response).to have_http_status(:ok)
    end

    it "creates default farm user" do
      expect(created_user).to be_present
      expect(created_user.farm).to be_present
      expect(created_user.farm.entities).to be_present
    end
  end

  describe "POST /api/v1/auth/sign_in" do
    let(:req_params) do
      { email: "pupa@acc.com", password: "12345678" }
    end

    let!(:user) { User.create!(req_params) }

    before { do_request }

    def do_request = post("/api/v1/auth/sign_in", params: req_params)

    it "signs in user" do
      expect(response).to have_http_status(:ok)
    end

    it "returns valid token" do
      expect(response).to have_http_status(:ok)

      get("/api/v1/auth/validate_token", params: response.headers.slice("access-token", "uid", "client"))

      expect(response).to have_http_status(:ok)
    end
  end
end
