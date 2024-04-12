module Api::V1
  class EntitiesController < ApplicationController
    before_action :set_entity, only: %i[move destroy]
    
    def move
      MoveEntityInteractor.call(entity: @entity, new_position: move_entity_params).tap do |interactor|
        if interactor.success?
          head :ok
        else 
          render json: { error: interactor.message }, status: :unprocessable_entity
        end
      end
    end

    def destroy
      @entity.destroy!
    end

    private

    def set_entity
      @entity = current_user.farm.entities.find_by(guid: params[:id])
    end

    def move_entity_params
      params.require(:position).permit(x: [], y: [])
    end
  end
end
