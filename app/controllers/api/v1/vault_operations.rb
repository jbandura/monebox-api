module API
  module V1
    class VaultOperations < Grape::API
      include API::V1::Defaults
      before { unauthorized_error unless authenticated? }

      resource :vault_operations do
        desc 'Get all vault operations'
        get do
          current_user.vault_operations
        end

        desc 'Create vault operations'
        params do
          requires :vault_operation, type: Hash do
            requires :type, type: String, desc: 'Operation type'
            requires :amount, type: Integer, desc: 'Operation amount'
            requires :user_id, type: Integer, desc: 'Operation owner'
            requires :vault_id, type: Integer, desc: 'Vault id'
          end
        end

        post do
          vault_operation_params = params["vault_operation"]
          VaultOperation.create!({
            type: vault_operation_params["type"],
            amount: vault_operation_params["amount"],
            user_id: vault_operation_params["user_id"],
            vault_id: vault_operation_params["vault_id"]
          })
        end

        route_param :id do
          desc 'Get an operation with given id'
          get do
            vault_operation = current_user.vault_operations.find(params[:id])
            return vault_operation if vault_operation
            return error!('Couldn\'t find vault operation with given id', 401)
          end

          desc 'Update an operation with given id'
          params do
            requires :vault_operation, type: Hash do
              requires :type, type: String, desc: 'Operation type'
              requires :amount, type: Integer, desc: 'Operation amount'
              requires :user_id, type: Integer, desc: 'Operation owner'
              requires :vault_id, type: Integer, desc: 'Vault id'
            end
          end
          put do
            operation = current_user.vault_operations.find(params[:id])
            operation.update!({
              type: params["vault_operation"]["type"],
              amount: params["vault_operation"]["amount"]
            })
          end

          desc 'Delete an operation with given id'
          delete do
            vault_operation = current_user.vault_operations.find(params[:id])
            vault_operation.destroy!
            status 204
          end
        end
      end
    end
  end
end
