class UserAuthenticator
  def authenticate(email, password)
    return false if email.nil? || password.nil?
    user = User.where(email: email.downcase).first
    return false if user.nil? || !user.valid_password?(password)
    user.authentication_token.to_s
  end

  def destroy_token(token)
    user = User.where(authentication_token: token).first
    return false if user.nil?
    user.reset_authentication_token
  end

  def data_from_string_token(token)
    return nil if token.nil? || !token.include?('Token token')
    data = token.gsub('Token ', '').split(',')
    {
      token: data[0].gsub('token: ', '').strip,
      email: data[1].gsub('email: ', '').strip
    }
  end
end
