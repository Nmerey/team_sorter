# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/admin/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/admin/update'
      expect(response).to have_http_status(:success)
    end
  end
end
