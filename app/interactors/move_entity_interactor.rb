class MoveEntityInteractor
  include TransactionalInteractor

  delegate :entity, :new_position, to: :context
  delegate :entity_locations, to: :entity

  alias_method :old_position, :entity_locations

  before do
    new_position.transform_values! { |it| it.map(&:to_i) }
  end

  def call
    context.fail!(message: "Garbage entities can't be moved") if Entity::GARBAGE_ENTITIES_NAMES.include?(entity.name)

    if old_position.any? && position_available?
      old_position.each(&:destroy!)

      new_position[:x].zip(new_position[:y]).each do |x, y|
        entity.farm.entity_locations.create!(x:, y: , entity:)
      end
    else
      context.fail!(message: 'Position is already taken')
    end
  end

  private def position_available?
    entity.farm.entity_locations
      .where(x: new_position[:x], y: new_position[:y])
      .where.not(entity:)
      .empty?
  end
end
