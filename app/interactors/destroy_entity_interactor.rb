class DestroyEntityInteractor
  include TransactionalInteractor

  delegate :entity, :entity_schema, to: :context

  def call
    if entity_schema.garbage?
      destroy_garbage_entity
    else
      destroy_entity
    end
  end

  def destroy_garbage_entity
    entity.farm.spend_item!(entity_schema.destroy_cost)
    destroy_entity
  end

  def destroy_entity
    entity.destroy!
  end
end
