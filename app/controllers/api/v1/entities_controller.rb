module Api::V1
  class EntitiesController < ApplicationController
    before_action :set_entity, only: %i[move destroy level_up]

    PERMITTED_PARAMS = [
      :name,
      location: [
        x: [],
        y: []
      ]
    ].freeze

    def create
      CreateEntityInteractor.call(farm: current_user.farm, entity_params: entity_params).tap do |interactor|
        if interactor.success?
          render json: interactor.entity, status: :created
        else
          render json: {error: interactor.message}, status: :unprocessable_entity
        end
      end
    end

    def level_up
      UpgradeEntityInteractor.call(entity: @entity).tap do |interactor|
        if interactor.success?
          head :ok
        else
          render json: {error: interactor.message}, status: :unprocessable_entity
        end
      end
    end

    def move
      MoveEntityInteractor.call(entity: @entity, new_position: entity_params.fetch(:location)).tap do |interactor|
        if interactor.success?
          head :ok
        else
          render json: {error: interactor.message}, status: :unprocessable_entity
        end
      end
    end

    def destroy
      DestroyEntityInteractor.call(entity: @entity).tap do |interactor|
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

    def entity_params
      params.require(:data).permit(PERMITTED_PARAMS).to_h.deep_symbolize_keys.tap do |it|
        next if it[:location].blank?

        it[:location].transform_keys!(&:to_sym)
        it[:location] = it[:location].each { |_, v| v.map!(&:to_i) }
      end
    end
  end
end
