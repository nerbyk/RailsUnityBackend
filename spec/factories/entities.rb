FactoryBot.define do
  factory :entity do
    name { "MyString" }
    farm { nil }

    transient do
      position { nil }
    end

    after(:create) do |entity, evaluator|
      return unless evaluator.position.present?

      evaluator.position[:x].each_with_index do |x, index|
        entity.entity_locations.create!(x: x, y: evaluator.position[:y][index], farm: entity.farm)
      end
    end
  end
end
