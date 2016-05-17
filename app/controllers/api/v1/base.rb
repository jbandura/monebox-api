module API
  module V1
    class Base < Grape::API
      mount API::V1::Users
      mount API::V1::Sessions
      mount API::V1::Vaults
    end
  end
end
