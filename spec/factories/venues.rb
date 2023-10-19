 FactoryBot.define do
    factory :venue do
      location { Faker::Address.city }
      date  { '12.12' }
      time { '10.00' }
      chat_id { rand(1...100000) }
      chat_title { Faker::Company.name }
    end
  end 