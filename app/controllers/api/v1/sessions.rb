module API
  module V1
    class Sessions < Grape::API
      include API::V1::Defaults

      resource :sessions do
        desc 'Authenticate user and return user object / access token'

        params do
          requires :email, type: String, desc: 'User email'
          requires :password, type: String, desc: 'User password'
        end

        post do
          token = UserAuthenticator.new.authenticate(params[:email], params[:password])
          return { status: 'ok', token: token } if token
          return error!(
            { error_code: 404, error_message: 'Invalid Email or Password.' },
            401
          )
        end
      end
    end
  end
end
