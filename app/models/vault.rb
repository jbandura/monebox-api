class Vault < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :start_state
  validates_numericality_of :start_state
end
