# spec/models/entity_spec.rb

require 'rails_helper'

RSpec.describe Entity, type: :model do
  LocationFactory = Struct.new(:x1, :x2, :y1, :y2)

  describe "associations" do
    subject { create(:entity) }

    it { should belong_to(:farm) }
    it { should have_many(:entity_receipts).dependent(:destroy) }
  end

  describe "scopes" do
    describe ".overlaps" do
      let!(:entity) { create(:entity) }
      let!(:another_entity) { create(:entity, location: { x: [2], y: [2] }, farm: entity.farm) }

      subject { Entity.overlaps(entity.farm_id, another_entity.id, entity.location)}

      it "returns overlap entities" do
        expect(subject).to eq([entity])
      end

      context "when there are no overlaps" do
        let(:free_location) { LocationFactory.new(3,3,3,3) }

        subject { Entity.overlaps(entity.farm_id, entity.id, free_location) }

        it "returns an empty array" do
          expect(subject).to eq([])
        end
      end

      context "when overlap entity is the same entity" do
        subject { Entity.overlaps(entity.farm_id, entity.id, entity.location) }

        it "returns an empty array" do
          expect(subject).to eq([])
        end
      end
    end
  end

  describe "validations" do
    let!(:entity) { create(:entity) }

    it "validates location overlap" do
      another_entity = build(:entity, location: entity.location, farm: entity.farm)
      expect(another_entity).to be_invalid
    end
  end

  describe "custom methods" do
    describe ".generate_location" do
      it "generates a location array based on given coordinates" do
        x_coords = [0, 10]
        y_coords = [0, 10]
        location = Entity.generate_location(x_coords, y_coords)
        expect(location).to eq([[0, 0], [10, 10]])
      end
    end
  end

  describe "location=" do
    let(:expected_location) { [0.0, 0.0, 2.0, 2.0] }

    context "when location is a { x: Integer[] y: Integer[] }" do
      subject { create(:entity, location: { x: (0..2).to_a, y: (0..2).to_a }) }
      
      it "sets the location box attribute" do
       expect(subject.location.values).to eq(expected_location)
      end
    end

    context "when location is torque-postgresql box" do
      subject { create(:entity, location: [[0, 0], [2, 2]]) }

      it "sets the location box attribute" do
        expect(subject.location.values).to eq(expected_location)
      end
    end
  end
end
