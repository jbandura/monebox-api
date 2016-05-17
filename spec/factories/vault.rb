FactoryGirl.define do
  factory :vault do
    sequence :name do |n|
      "Vault #{n}"
    end
    start_state "1000"
  end
end
