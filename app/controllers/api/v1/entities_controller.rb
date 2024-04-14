module Api::V1
  class EntitiesController < ApplicationController
    before_action :authenticate_user!

    before_action :set_entity, only: %i[move destroy level_up]

    before_action -> { set_entity_static(entity_params[:name]) }, only: %i[create]
    before_action -> { set_entity_static(@entity.name) }, only: %i[level_up destroy move]

    PERMITTED_PARAMS = [
      :name,
      location: [
        x: [],
        y: []
      ]
    ].freeze

    def create
      CreateEntityInteractor.call(
        farm: current_user.farm,
        entity_static: @entity_static,
        entity_params: entity_params
      ).tap do |interactor|
        if interactor.success?
          render json: interactor.entity, status: :created
        else
          render json: {error: interactor.message}, status: :unprocessable_entity
        end
      end
    end

    def level_up
      UpgradeEntityInteractor.call(entity: @entity, entity_static: @entity_static).tap do |interactor|
        if interactor.success?
          head :ok
        else
          render json: {error: interactor.message}, status: :unprocessable_entity
        end
      end
    end

    def move
      MoveEntityInteractor.call(
        entity: @entity,
        entity_static: @entity_static,
        new_position: entity_params.fetch(:location)
      ).tap do |interactor|
        if interactor.success?
          head :ok
        else
          render json: {error: interactor.message}, status: :unprocessable_entity
        end
      end
    end

    def destroy
      DestroyEntityInteractor.call(entity: @entity, entity_static: @entity_static).tap do |interactor|
        if interactor.success?
          head :ok
        else
          render json: {error: interactor.message}, status: :unprocessable_entity
        end
      end
    end

    private

    def set_entity
      @entity = current_user.farm.entities.find_by(guid: params[:id])
    end

    def set_entity_static(name)
      @entity_static = GameplayStatic.entities[name.to_sym]
    end

    def entity_params
      params.require(:data).permit(PERMITTED_PARAMS).to_h.deep_symbolize_keys.tap do |it|
        next if it[:location].blank?

        it[:location] = it[:location].each { |_, v| v.map!(&:to_i) }
      end
    end
  end
end
