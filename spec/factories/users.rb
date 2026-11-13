FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Usuário #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    valid_cpfs = %w[52998224725 11144477735 96432617003 39053344705 71563465020 88512437019]
    sequence(:cpf) { |n| valid_cpfs[(n - 1) % valid_cpfs.size] }
    phone { "11999990000" }
    password { "senha123456" }
    password_confirmation { "senha123456" }
  end
end
