module API
  module V1
    class Sessions < Grape::API
      include API::V1::Defaults

      resource :sessions do
        desc 'Authenticate user and return user object / access token'

        params do
          requires :user, type: Hash do
            requires :email, type: String, desc: 'User email'
            requires :password, type: String, desc: 'User password'
          end
        end

        post do
          email = params[:user][:email]
          token = UserAuthenticator.new.authenticate(email, params[:user][:password])
          return { token: token, email: email } if token
          return error!(
            { error_code: 404, error_message: 'Invalid Email or Password.' },
            401
          )
        end

        params do
          requires :authentication_token, type: String, desc: 'Users auth token'
        end

        delete do
          UserAuthenticator.new.destroy_token(params[:authentication_token])
        end
      end
    end
  end
end
