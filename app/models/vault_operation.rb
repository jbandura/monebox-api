class VaultOperation < ActiveRecord::Base
  belongs_to :vault
  belongs_to :user

  validates_presence_of :type, :amount
  validates_numericality_of :amount, greater_than: 0
  validates_inclusion_of :type, in: %w{withdrawal deposit}
end
