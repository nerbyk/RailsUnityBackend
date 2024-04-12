class DestroyEntityInteractor
  include TransactionalInteractor

  delegate :entity, :static_entity, to: :context

  before do
    context.static_entity = GameplayStatic.entities[entity.name.to_sym]
  end

  def call
    if static_entity.type == :garbage
      destroy_garbage_entity
    else
      destroy_entity
    end
  end

  def destroy_garbage_entity
    cost = static_entity.levels.first.cost
    item = entity.farm.items.find_by(name: cost.item_name)

    if item.amount >= cost.amount
      item.decrement!(:amount, cost.amount)

      destroy_entity
    else 
      context.fail!(message: 'Not enough resources')
    end
  end

  def destroy_entity
    entity.destroy!
  end
end
