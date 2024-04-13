class DestroyEntityInteractor
  include TransactionalInteractor

  delegate :entity, :static_entity, to: :context

  before do
    context.static_entity = GameplayStatic.entities[entity.name.to_sym]
  end

  def call
    if static_entity.garbage?
      destroy_garbage_entity
    else
      destroy_entity
    end
  end

  def destroy_garbage_entity
    if entity.farm.spend_item(static_entity.destroy_cost)
      destroy_entity
    else
      context.fail!(message: "Not enough resources")
    end
  end

  def destroy_entity
    entity.destroy!
  end
end
