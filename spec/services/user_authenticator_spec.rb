require 'rails_helper'
RSpec.describe UserAuthenticator do
  context '#authenticate' do
    let(:subject) { UserAuthenticator.new }
    let(:user_stub) do
      User.new(
        email: 'admin@email.com',
        password: 'foobarpassword',
        authentication_token: 'AUTHENTICATION_TOKEN'
      )
    end

    it 'returns false when email or password missing' do
      expect(subject.authenticate(nil, nil)).to eq(false)
      expect(subject.authenticate(nil, 'foopassword')).to eq(false)
      expect(subject.authenticate('email', nil)).to eq(false)
    end

    it 'return false when user not found' do
      expect(User).to receive(:where)
        .with(email: user_stub.email)
        .and_return([])
      jwt = subject.authenticate('admin@email.com', 'foobarpassword')
      expect(jwt).to eq(false)
    end

    it 'return false when credentials do not match' do
      expect(User).to receive(:where)
        .with(email: 'notmatch@email.com')
        .and_return([user_stub])
      jwt = subject.authenticate('notmatch@email.com', 'badpassword')
      expect(jwt).to eq(false)
    end

    it 'returns JWT when proper credentials passed' do
      expect(User).to receive(:where)
        .with(email: user_stub.email)
        .and_return([user_stub])
      jwt = subject.authenticate('admin@email.com', 'foobarpassword')
      expect(jwt).to eq(user_stub.authentication_token)
    end
  end
end
