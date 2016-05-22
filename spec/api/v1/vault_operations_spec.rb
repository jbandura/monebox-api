RSpec.describe 'API::V1::VaultOperations' do
  let(:user) { create(:user) }
  let(:vault) { create(:vault, user: user) }
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:authenticated?).and_return(true)
      allow(endpoint).to receive(:current_user).and_return(user)
    end
  end

  describe 'GET /api/v1/vault_operations' do
    let(:resp) { JSON.parse(response.body) }
    it 'should fetch list of vault operations scoped to user' do
      vault_operations = create_list(:vault_operation, 3, {
        user: user,
        vault: vault
      })
      get '/api/v1/vault_operations'
      expect(response.status).to eq(200)
      expect(resp["vault_operations"].length).to eq(vault_operations.length)
    end
  end

  describe 'POST /api/v1/vault_operations' do
    let(:params) do
      {
        vault_operation: {
          type: 'withdrawal',
          amount: 50,
          user_id: user.id,
          vault_id: vault.id
        }
      }
    end

    subject { post '/api/v1/vault_operations', params }

    it 'should create new vault_operations' do
      expect { subject }.to change { VaultOperation.count }.by(1)
    end
  end

  context 'with given id' do
    let(:vault_operation) { create(:vault_operation, vault: vault, user: user) }

    describe 'GET /api/v1/vault_operations/:id' do
      let(:response_body) { JSON.parse(response.body) }
      it 'should fetch vault operation with given id' do
        get "/api/v1/vault_operations/#{vault_operation.id}"
        retrieved_operation = response_body["vault_operation"]
        expect(retrieved_operation["type"]).to eq(vault_operation[:type])
        expect(retrieved_operation["amount"]).to eq(vault_operation[:amount])
      end
    end

    describe 'PUT /api/v1/vault_operations/:id' do
      let(:params) do
        {
          vault_operation: {
            type: 'deposit',
            amount: 110,
            user_id: user.id,
            vault_id: vault.id
          }
        }
      end

      it 'should persist the changes whne editing vault operation' do
        put "/api/v1/vault_operations/#{vault_operation.id}", params
        operation = VaultOperation.find(vault_operation.id)
        expect(operation.type).to eq('deposit')
        expect(operation.amount).to eq(110)
      end
    end

    describe 'DELETE /api/v1/vault_operations/:id' do
      it 'should delete vault operation with given in' do
        vault_op = create(:vault_operation, vault: vault, user: user)
        vault_op_count = VaultOperation.count
        delete "/api/v1/vault_operations/#{vault_op.id}"
        expect(VaultOperation.count).to eq(vault_op_count - 1)
      end
    end
  end
end
