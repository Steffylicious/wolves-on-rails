FactoryBot.define do
  factory :game do
  end

  factory :player do
    name { Faker::Name.name }
    game
    role { "villager" }
  end
end
