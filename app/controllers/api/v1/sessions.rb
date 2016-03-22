module API
  module V1
    class Sessions < Grape::API
      include API::V1::Defaults

      resource :sessions do
        desc "Authenticate user and return user object / access token"

        params do
          requires :email, type: String, desc: "User email"
          requires :password, type: String, desc: "User password"
        end

        post do
          { msg: "Auth token" }
        end
      end
    end
  end
end
