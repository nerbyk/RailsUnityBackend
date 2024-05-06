class MoveEntityInteractor
  include TransactionalInteractor

  delegate :entity, :entity_schema, :new_position, to: :context

  def call
    entity.update!(location: new_position.to_h)
  end
end
