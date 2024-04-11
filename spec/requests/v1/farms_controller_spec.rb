require 'rails_helper'

RSpec.describe "FarmsController", type: :request do
  let(:user) { create(:user) }

  describe 'GET /api/v1/farms' do
    let!(:receipt) { create(:entity_receipt, entity: user.farm.entities.first) }

    before { do_request }

    def do_request = get("/api/v1/farm")

    context 'when the user is authenticated' do
      sign_in(:user)

      let(:response_body) { JSON.parse(response.body, symbolize_names: true) }

      it 'returns a successful response' do
        expect(response).to have_http_status(200)
      end

      it 'returns the farm details' do
        expect(response_body).to include(:entities, :items)
        
        expect(response_body[:entities]).to be_an(Array)
        expect(response_body[:entities][0]).to be_a(Hash)
        expect(response_body[:entities][0]).to include(:id, :name, :position, :receipts)

        
        expect(response_body[:entities][0][:position]).to be_a(Hash)
        expect(response_body[:entities][0][:position]).to include(:x, :y)

        expect(response_body[:entities][0][:position][:x]).to be_an(Array)
        expect(response_body[:entities][0][:position][:x][0]).to be_an(Integer)
        expect(response_body[:entities][0][:position][:y]).to be_an(Array)
        expect(response_body[:entities][0][:position][:y][0]).to be_an(Integer)

        expect(response_body[:entities][0][:receipts]).to be_an(Array)
        expect(response_body[:entities][0][:receipts][0]).to be_a(Hash)
        expect(response_body[:entities][0][:receipts][0]).to include(:id, :name, :state, :updated_at, :created_at)

        expect(response_body[:items][0]).to include(:name, :amount)
      end
    end

    context 'when the user is not authenticated' do
      it { expect(response).to have_http_status(401) }
    end
  end
end