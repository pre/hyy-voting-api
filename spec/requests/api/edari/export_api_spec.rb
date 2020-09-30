require 'rails_helper'
require "cancan/matchers"

describe Vaalit::Export::ExportApi do

  describe "authorization" do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "when current user is a voter" do
      let(:user) { FactoryBot.build(:voter) }

      it { should_not be_able_to(:access, :export) }
    end

    context "when current user is a guest" do
      let(:user) { FactoryBot.build(:guest_user) }

      it { should_not be_able_to(:access, :export) }
    end

    context "when current user is nil" do
      let(:user) { nil }

      it { should_not be_able_to(:access, :export) }
    end

    context "when current user is a service user" do
      let(:user) { FactoryBot.build(:service_user) }

      context "when elections and voting are still ongoing" do
        before do
          allow(RuntimeConfig).to receive(:voting_active?).and_return(true)
          allow(RuntimeConfig).to receive(:elections_active?).and_return(true)
        end

        it { should_not be_able_to(:access, :export) }
      end

      context "when elections are ongoing but daily voting time has ended" do
        before do
          allow(RuntimeConfig).to receive(:elections_active?).and_return(true)
          allow(RuntimeConfig).to receive(:voting_active?).and_return(false)
        end

        it { should_not be_able_to(:access, :export) }
      end

      context "elections have ended" do
        before do
          allow(RuntimeConfig).to receive(:elections_active?).and_return(false)
          allow(RuntimeConfig).to receive(:voting_active?).and_return(false)
        end

        it { should be_able_to(:access, :export) }
      end
    end
  end
end
