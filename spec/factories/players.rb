 FactoryBot.define do
    factory :player do
      name { Faker::Name.first_name }
      surname { Faker::Name.last_name }
      nickname { Faker::Games::Dota.player }
      t_id { rand(1...100000000) }
      rating { rand(1.0...10.0) }
    end
  end 

#  create_table 'players', force: :cascade do |t|
#   t.string 'name'
#   t.string 'surname'
#   t.string 'nickname'
#   t.bigint 't_id'
#   t.bigint 'friend_id'
#   t.float 'rating', default: 5.0, null: false
#   t.datetime 'created_at', null: false
#   t.datetime 'updated_at', null: false
# end