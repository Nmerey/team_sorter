require 'rails_helper'

RSpec.describe "Venues", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/venue/index"
      expect(response).to have_http_status(:success)
    end
  end

end
