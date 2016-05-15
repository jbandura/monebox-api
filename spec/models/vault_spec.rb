require 'rails_helper'
RSpec.describe Vault do
  it { is_expected.to have_attribute('name') }
  it { is_expected.to have_attribute('start_state') }
  it { is_expected.to belong_to('user') }
end
