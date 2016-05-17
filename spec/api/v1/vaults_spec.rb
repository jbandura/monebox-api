RSpec.describe 'API::V1::Vaults' do
  let(:user) { create(:user) }
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:authenticated?).and_return(true)
      allow(endpoint).to receive(:current_user).and_return(user)
    end
  end

  describe 'GET /api/v1/vaults' do
    it 'should fetch list of vaults' do
      vaults = create_list(:vault, 10, user: user)
      get '/api/v1/vaults'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["vaults"].length).to eq(vaults.length)
    end

    it 'should fetch list of vaults for current_user only' do
      second_user = create(:user)
      create_list(:vault, 5, user: second_user)
      get '/api/v1/vaults'
      expect(JSON.parse(response.body)["vaults"]).to be_empty
    end
  end

  describe 'POST /api/v1/vaults' do
    let(:params) do
      {
        vault: {
          name: 'New Vault',
          start_state: 500,
          user_id: user.id
        }
      }
    end
    subject { post '/api/v1/vaults', params }
    it 'should create a new vault for a user' do
      expect { subject }.to change { Vault.count }.by(1)
      expect(user.vaults.last.name).to eq(params[:vault][:name])
    end
  end

  describe 'PUT /api/v1/vaults' do
    let(:vault) { create(:vault, user: user) }
    let(:params) do
      {
        vault: {
          id: vault.id,
          name: 'Edited Vault Name',
          start_state: 300,
          user_id: user.id
        }
      }
    end
    let(:response_body) { JSON.parse(response.body) }

    it 'should change vault params' do
      put "/api/v1/vaults/#{vault.id}", params
      vault_params = params[:vault]
      changed_vault = response_body["vault"]
      expect(changed_vault["name"]).to eq(vault_params[:name])
      expect(changed_vault["start_state"]).to eq(vault_params[:start_state])
    end
  end

  describe 'DELETE /api/v1/vaults/:id' do
    let(:user) { create(:user) }

    it 'should delete vault' do
      vault = create(:vault, user: user)
      vault_count = Vault.count
      delete "/api/v1/vaults/#{vault.id}"
      expect(Vault.count).to eq(vault_count - 1)
      expect(response.status).to eq(204)
    end
  end

  describe 'GET /api/v1/vaults/:id' do
    let(:vault) { create(:vault, user: user) }
    let(:response_body) { JSON.parse(response.body) }

    it 'should retrieve vault for logged in user' do
      get "/api/v1/vaults/#{vault.id}"
      retrieved_vault = response_body["vault"]
      expect(retrieved_vault["name"]).to eq(vault[:name])
      expect(retrieved_vault["start_state"]).to eq(vault[:start_state])
    end
  end
end
