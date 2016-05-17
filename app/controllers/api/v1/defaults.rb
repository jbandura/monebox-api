module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        version 'v1'
        default_format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers
        format :json

        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def logger
            Rails.logger
          end

          def current_user
            return nil if token_data.nil?
            User.find_by({
              email: token_data[:email],
              authentication_token: token_data[:token]
            })
          end

          def authenticated?
            !!current_user
          end

          def token_data
            UserAuthenticator.new.data_from_string_token(
              request.headers['Authorization']
            )
          end

          def unauthorized_error
            error!('401 Unauthorized', 401)
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: e.message, status: 422)
        end
      end
    end
  end
end
