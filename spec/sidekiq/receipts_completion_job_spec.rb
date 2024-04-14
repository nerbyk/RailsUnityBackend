require 'rails_helper'

RSpec.describe ReceiptsCompletionJob, type: :job do
  describe "#perform" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    before do
      [user1, user2].each do |u|
        EntityReceipt.insert_all(u.farm.entities.ids.map do |entity_id|
          { entity_id: entity_id, name: "101", status: 0, updated_at: Time.current - ReceiptsCompletionJob::COMPLETION_TIMEOUT }
        end)
      end
    end

    subject { ReceiptsCompletionJob.new.perform }

    it "completes the pending receipts" do
      expect { subject }.to change { EntityReceipt.pending.count }.to(0)
    end
  end
end
