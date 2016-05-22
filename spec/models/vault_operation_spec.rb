RSpec.describe VaultOperation do
  it { is_expected.to have_attribute('type') }
  it { is_expected.to have_attribute('amount') }
  it { is_expected.to belong_to('user') }
  it { is_expected.to belong_to('vault') }

  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount).is_greater_than(0) }
  it { should validate_inclusion_of(:type).in_array(['withdrawal', 'deposit']) }
end
