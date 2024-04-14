require "rails_helper"

RSpec.describe "EntityReceipts", type: :request do
  let(:user) { create(:user) }

  let(:receipts_static) { GameplayStatic.entities[:garden].levels.first.receipts }

  before do
    allow(Farm).to receive(:create_initial_farm) do |u| # avoid creation of 2k initial entities
      Farm.create(user: u)
    end
  end

  describe "POST /api/v1/entities/:entity_id/receipt" do
    sign_in(:user)

    let(:receipt_params) { {name: receipts_static.keys.first} }
    let(:receipt_cost) { receipts_static[receipt_params[:name].to_sym].levels.first.cost.amount }

    let!(:entity) { create(:entity, farm: user.farm, name: "garden") }
    let!(:item) { create(:item, name: "seed", farm: user.farm, amount: 100) }

    def do_request
      post "/api/v1/entities/#{entity.guid}/receipts", params: {data: receipt_params}
    end

    context "when receipt is valid" do
      let(:response_body) { JSON.parse(response.body, symbolize_names: true) }

      before { do_request }

      it "should return 201" do
        expect(response).to have_http_status(:created)
      end

      it "should return created entity" do
        expect(response_body).to include(:id, :name, :level, :status, :completed_at)

        expect(response_body[:name]).to eq(receipt_params[:name].to_s)
        expect(response_body[:level]).to eq(1)
        expect(response_body[:status]).to eq("pending")
        expect(response_body[:id]).to be_present
        expect(response_body[:completed_at]).to be_present
      end

      it "should decrement item amount" do
        expect { item.reload }.to change { item.amount }.by(-receipt_cost)
      end
    end

    context "when receipt is invalid" do
      context "when farm has not enough resources" do
        let!(:item) { create(:item, name: "seed", farm: user.farm, amount: 0) }

        before { do_request }

        it "should return 422" do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Not enough resources")
        end
      end

      context "when invalid receipt name passed" do
        let(:receipts_static) { GameplayStatic.entities[:garden].levels.second.receipts }

        before { do_request }

        it "should return 422" do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to include("Undefined receipt name: #{receipt_params[:name]}")
        end
      end
    end
  end

  describe "PATCH /api/v1/entities/:entity_id/receipts/:receipt_id/level_up" do
    sign_in(:user)

    let!(:entity) { create(:entity, name: "garden", farm: user.farm) }
    let!(:receipt) { create(:entity_receipt, entity: entity, name: receipts_static.keys.first, status: :completed) }
    let!(:item) { create(:item, name: "energy", farm: user.farm, amount: 100) }
    let(:cost) { receipts_static[receipt.name.to_sym].levels.second.cost }

    def do_request
      patch "/api/v1/entities/#{entity.guid}/receipts/#{receipt.id}/level_up"
    end

    context "when entity is valid" do
      before { do_request }

      it "should return 200" do
        expect(response).to have_http_status(:ok)
      end

      it "should increment receipt level" do
        expect(receipt.reload.level).to eq(2)
      end

      it "should decrement item amount" do
        expect(item.reload.amount).to eq(100 - cost.amount)
      end
    end

    context "when farm has not enough resources" do
      let!(:item) { create(:item, name: "energy", farm: user.farm, amount: 0) }

      before { do_request }

      it "should return 422" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Not enough resources")
      end
    end

    context "when receipt is not completed" do
      let!(:receipt) { create(:entity_receipt, entity: entity, name: receipts_static.keys.first, status: :pending) }

      before { do_request }

      it "should return 422" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("This receipt can't be upgraded yet")
      end
    end
  end
end
