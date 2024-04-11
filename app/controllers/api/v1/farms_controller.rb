module Api::V1
  class FarmsController < ApplicationController
    respond_to :json
    
    def show
      respond_with current_user.farm
    end
  end
end
