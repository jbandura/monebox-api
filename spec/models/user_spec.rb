RSpec.describe User do
  it { is_expected.to have_many('vaults') }
end
