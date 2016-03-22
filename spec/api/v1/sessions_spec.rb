require 'rails_helper'

RSpec.describe 'API::V1::Sessions' do
  describe 'GET /api/v1/sessions' do
    let(:args) { { email: 'admin@user.rb', password: 'foopassword' } }
    it 'returns auth token for user' do
      post '/api/v1/sessions', args
      expect(JSON.parse(response.body)['msg']).to eq 'Auth token'
    end
  end
end
