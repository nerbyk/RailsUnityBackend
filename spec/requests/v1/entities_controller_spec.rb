require 'rails_helper'

RSpec.describe "Entities", type: :request do
  let(:user) { create(:user) }
  let(:entity) { create(:entity, user: user, farm: user.farm, location: location) }
  let(:location) { { x: [1, 2, 3], y: [1,2,3] } }

  before do
    user.farm.entities.delete_all
  end

  describe "PATCH /api/v1/entities/:id/move" do
    sign_in(:user)
    
    let(:new_position) { { x: [1, 2, 3], y: [4, 5, 6] } }

    def do_request
      patch "/api/v1/entities/#{entity.guid}/move", params: { position: new_position }
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
      let!(:another_entity) { create(:entity, user: user, farm: user.farm, location: new_position)  }

      before { do_request }

      it "should return 422" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Position is already taken")
      end
    end

    context "when entity is garbage" do
      let(:entity) { create(:entity, user: user, farm: user.farm, location: location, name: Entity::GARBAGE_ENTITIES_NAMES.sample) }

      before { do_request }

      it "should return 422" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Garbage entities can't be moved")
      end
    end
  end

  describe "DELETE /api/v1/entities/:id" do
    sign_in(:user)

    def do_request
      delete "/api/v1/entities/#{entity.guid}"
    end

    context "when garbage entity" do
      let(:entity) { create(:entity, user:, location:, farm: user.farm, name: "tree") }
      let(:item) { user.farm.items.find_by(name: "coins") }

      context "when farm has enough resources" do
        before { item.update(amount: 100); do_request }

        it "should return 200" do
          expect(response).to have_http_status(:ok)
        end

        it "should decrement item amount" do
          expect(item.reload.amount).to eq(90)
        end

        it "should delete entity" do
          expect(Entity.find_by(id: entity.id)).to be_nil
        end
      end

      context "when farm has not enough resources" do
        before { item.update(amount: 0); do_request }

        it "should return 422" do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Not enough resources")
        end
      end
    end
  end
end
