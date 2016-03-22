module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      resource :users do
        get "" do
          'Siema'
        end
      end
    end
  end
end
