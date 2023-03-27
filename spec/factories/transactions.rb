FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Finance.credit_card(:visa) }
    credit_card_expiration_date { "2024-6-9" } # nil in csv file?
    result { Faker::Number.between(from: 0, to: 1) }
  end
end
