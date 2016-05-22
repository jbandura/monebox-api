class Vault < ActiveRecord::Base
  belongs_to :user
  has_many :vault_operations, class_name: 'VaultOperation'

  validates_presence_of :name, :start_state
  validates_numericality_of :start_state
end
