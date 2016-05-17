module API
  module V1
    class Vaults < Grape::API
      include API::V1::Defaults
      before { unauthorized_error unless authenticated? }

      resource :vaults do
        desc 'Get all vaults'
        get { current_user.vaults }

        desc 'Create a new vault'
        params do
          requires :vault, type: Hash do
            requires :name, type: String, desc: 'Vault name'
            requires :start_state, type: Float, desc: 'Vault start state'
            requires :user_id, type: Integer
          end
        end

        post do
          vault_params = params["vault"]
          Vault.create!({
            name: vault_params["name"],
            start_state: vault_params["start_state"],
            user_id: vault_params["user_id"]
          })
        end

        route_param :id do
          desc 'Get a vault'
          get do
            current_user.vaults.find(params[:id])
          end

          desc 'Update a vault'
          params do
            requires :vault, type: Hash do
              requires :name, type: String, desc: 'Vault name'
              requires :start_state, type: Float, desc: 'Vault start state'
              requires :user_id, type: Integer
            end
          end

          put do
            vault_params = declared(params)[:vault]
            vault = current_user.vaults.find(params[:id])
            vault.update!({
              name: vault_params[:name],
              start_state: vault_params[:start_state]
            })
            vault
          end

          desc 'Delete a vault'
          delete do
            vault = current_user.vaults.find(params[:id])
            vault.destroy!
            status 204
            nil
          end
        end
      end
    end
  end
end
