require 'rails_helper'
require "cancan/matchers"

describe Vaalit::Export::ExportApi do

  describe "authorization" do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "when current user is a voter" do
      let(:user) { FactoryGirl.build(:voter) }

      it { should_not be_able_to(:access, :export) }
    end

    context "when current user is a guest" do
      let(:user) { FactoryGirl.build(:guest_user) }

      it { should_not be_able_to(:access, :export) }
    end

    context "when current user is nil" do
      let(:user) { nil }

      it { should_not be_able_to(:access, :export) }
    end

    context "when current user is a service user" do
      let(:user) { FactoryGirl.build(:service_user) }

      context "when voting is still ongoing" do
        before do
          allow(RuntimeConfig).to receive(:voting_active?).and_return(true)
        end

        context "exporting votes" do
          it { should_not be_able_to(:access, :export) }
        end
      end

      context "when voting has ended" do
        before do
          allow(RuntimeConfig).to receive(:voting_active?).and_return(false)
        end

        context "exporting votes" do
          it { should be_able_to(:access, :export) }
        end
      end
    end
  end
end
