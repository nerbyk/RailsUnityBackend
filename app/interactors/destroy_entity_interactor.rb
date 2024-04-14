class DestroyEntityInteractor
  include TransactionalInteractor

  delegate :entity, :entity_static, to: :context

  def call
    if entity_static.garbage?
      destroy_garbage_entity
    else
      destroy_entity
    end
  end

  def destroy_garbage_entity
    if entity.farm.spend_item(entity_static.destroy_cost)
      destroy_entity
    else
      context.fail!(message: "Not enough resources")
    end
  end

  def destroy_entity
    entity.destroy!
  end
end
