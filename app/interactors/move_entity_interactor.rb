class MoveEntityInteractor
  include TransactionalInteractor

  delegate :entity, :new_position, to: :context

  before do
    new_position.transform_values! { |it| it.map(&:to_i) }
    new_position.transform_keys!(&:to_sym)
  end

  def call
    context.fail!(message: "Garbage entities can't be moved") if GameplayStatic.entities[entity.name.to_sym].garbage?
    context.fail!(message: "Position is already taken") unless entity.update(location: new_position.to_h)
  end
end
