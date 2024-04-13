FactoryBot.define do
  factory :entity do
    name { "tree" }
    location { {x: [0, 1], y: [0, 1]} }

    before :create do |entity| # skip farm initialization
      next unless entity.farm.nil?

      user_id = User.insert({email: "t@t.com"}).then { |r| r.first["id"] }
      farm_id = Farm.insert({user_id: user_id}).then { |r| r.first["id"] }

      entity.user_id = user_id
      entity.farm_id = farm_id
    end
  end
end
