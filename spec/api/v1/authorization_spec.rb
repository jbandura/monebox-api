RSpec.describe 'Authorization' do
  context 'as a logged in user' do
    let(:user) { create(:user) }
    let(:vault) { create(:vault, user:user) }
    let(:token) { UserAuthenticator.new.authenticate(user.email, user.password) }

    it 'should fetch current_user based on token' do
      get "/api/v1/vaults/#{vault.id}", nil, 'Authorization': "Token token: #{token}, email: #{user.email}"
      expect(response.status).not_to eq(401)
    end

    it 'should not allow accessing with wrong token' do
      other_user = create(:user)
      get "/api/v1/vaults/#{vault.id}", nil, 'Authorization': "Token token: BAD_TOKEN, email: #{other_user.email}"
      expect(response.status).to eq(401)
    end

    it 'should not allow accessing with wrong token' do
      other_user = create(:user)
      other_token = UserAuthenticator.new.authenticate(other_user.email, other_user.password)
      get "/api/v1/vaults/#{vault.id}", nil, 'Authorization': "Token token: #{other_token}, email: #{other_user.email}"
      expect(response.status).to eq(404)
    end
  end
end
