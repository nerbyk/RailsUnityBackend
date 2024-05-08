module Api::V1::Entity
  class ReceiptsController < ApplicationController
    before_action :authenticate_user!

    before_action :set_entity
    before_action :set_receipt, only: %i[level_up]

    PERMITTED_PARAMS = [
      :name
    ].freeze

    def create
      Entity::CreateReceiptInteractor.call(entity: @entity, create_params: receipt_params).tap do |interactor|
        if interactor.success?
          render json: interactor.receipt, status: :created
        else
          render json: {error: interactor.message}, status: :unprocessable_entity
        end
      end
    end

    def level_up
      Entity::UpgradeReceiptInteractor.call(receipt: @receipt, entity: @entity).tap do |interactor|
        if interactor.success?
          head :ok
        else
          render json: {error: interactor.message}, status: :unprocessable_entity
        end
      end
    end

    private

    def set_entity
      @entity = current_user.farm.entities.find_by(guid: params[:entity_id])
    end

    def set_receipt
      @receipt = @entity.receipts.find(params[:receipt_id])
    end

    def receipt_params
      params.require(:data).permit(PERMITTED_PARAMS)
    end
  end
end
