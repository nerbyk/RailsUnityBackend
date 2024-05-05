class MoveEntityInteractor
  include TransactionalInteractor

  delegate :entity, :entity_schema, :new_position, to: :context

  def call
    context.fail!(message: "Garbage entities can't be moved") if entity_schema.garbage?
    context.fail!(message: "Position is already taken") unless entity.update(location: new_position.to_h)
  end
end
