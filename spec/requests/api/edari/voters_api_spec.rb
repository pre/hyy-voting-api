require 'rails_helper'
require "cancan/matchers"

describe Vaalit::Voters::VotersApi do

  describe "authorization" do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "when current user is a voter" do
      let(:user) { FactoryGirl.build(:voter) }

      it { should_not be_able_to(:access, :voters) }
    end

    context "when current user is a guest" do
      let(:user) { FactoryGirl.build(:guest_user) }

      it { should_not be_able_to(:access, :voters) }
    end

    context "when current user is nil" do
      let(:user) { nil }

      it { should_not be_able_to(:access, :voters) }
    end

    context "when current user is a service user" do
      let(:user) { FactoryGirl.build(:service_user) }

      it { should be_able_to(:access, :voters) }
    end
  end
end
