class VaultOperationSerializer < ActiveModel::Serializer
  attributes :id, :type, :amount
  has_one :user
  has_one :vault
end
