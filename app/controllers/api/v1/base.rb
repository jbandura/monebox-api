module API
  module V1
    class Base < Grape::API
      helpers API::AuthHelpers
      mount API::V1::Users
      mount API::V1::Sessions
      mount API::V1::Vaults
    end
  end
end
