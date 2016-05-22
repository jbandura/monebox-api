RSpec.describe Vault do
  it { is_expected.to have_attribute('name') }
  it { is_expected.to have_attribute('start_state') }
  it { is_expected.to belong_to('user') }
  it { is_expected.to have_many('vault_operations') }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_state) }
  it { should validate_numericality_of(:start_state) }
end
