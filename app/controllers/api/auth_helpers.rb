module API
  module AuthHelpers
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
end
