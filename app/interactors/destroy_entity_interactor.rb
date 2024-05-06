class DestroyEntityInteractor
  include TransactionalInteractor

  delegate :entity, to: :context

  def call
    if entity.schema.garbage?
      destroy_garbage_entity
    else
      destroy_entity
    end
  end

  def destroy_garbage_entity
    entity.farm.spend_item!(**entity.schema.destroy_cost.to_h)
    destroy_entity
  end

  def destroy_entity
    entity.destroy!
  end
end
