require 'rails_helper'

RSpec.describe "Entities", type: :request do

  describe "PATCH /api/v1/entities/:id/move" do
    sign_in(:user)
    
    let(:user) { create(:user) }
    let(:entity) { create(:entity, user: user, farm: user.farm, location: old_position) }

    let(:old_position) { { x: [1, 2, 3], y: [1,2,3] } }
    let(:new_position) { { x: [1, 2, 3], y: [4, 5, 6] } }

    def do_request
      patch "/api/v1/entities/#{entity.guid}/move", params: { position: new_position }
    end

    before do
      user.farm.entities.delete_all
    end

    context "when entity moved to empty position" do
      before { do_request }

      it "should return 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when entity moved to position with same entity" do
      let(:new_position) { { x: [2, 3, 4], y: [2, 3, 4] } }

      before { do_request }

      it "should return 200" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when entity moved to position with another entity" do
      before do 
        create(:entity, user: user, farm: user.farm, location: new_position) 
        do_request
      end

      it "should return 422" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Position is already taken")
      end
    end

    context "when entity is garbage" do
      let(:entity) { create(:entity, user: user, farm: user.farm, location: old_position, name: Entity::GARBAGE_ENTITIES_NAMES.sample) }

      before { do_request }

      it "should return 422" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Garbage entities can't be moved")
      end
    end
  end
end
