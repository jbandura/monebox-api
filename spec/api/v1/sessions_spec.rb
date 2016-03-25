require 'rails_helper'

RSpec.describe 'API::V1::Sessions' do
  describe 'GET /api/v1/sessions' do
    let (:user) do
      User.create!(
        email: 'foo@admin.local',
        password: 'password',
        password_confirmation: 'password'
      )
    end
    let (:token) { JSON.parse(response.body)["token"]}
    it 'returns auth token for user' do
      post '/api/v1/sessions', { email: user.email, password: 'password' }
      expect(token).to eq user.authentication_token
    end
  end
end
