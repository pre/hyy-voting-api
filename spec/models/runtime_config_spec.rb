require 'rails_helper'

RSpec.describe RuntimeConfig, type: :model do

  context "voting has not started yet" do
    before do
      stub_const("Vaalit::Config::VOTE_SIGNIN_STARTS_AT", 1.hour.from_now)
      stub_const("Vaalit::Config::VOTE_SIGNIN_ENDS_AT", 2.hours.from_now)
    end

    it "vote signin is not active" do
      expect(RuntimeConfig.vote_signin_active?).to be false
    end

    it "voting is not active" do
      expect(RuntimeConfig.voting_active?).to be false
    end

    it "elections are not active" do
      expect(RuntimeConfig.elections_active?).to be false
    end
  end

  context "voting day is over but continues the next day" do
    before do
      stub_const("Vaalit::Config::VOTE_SIGNIN_STARTS_AT", 3.days.ago)
      stub_const("Vaalit::Config::VOTE_SIGNIN_ENDS_AT", 1.day.from_now)
      stub_const("Vaalit::Config::Vaalit::Config::VOTING_GRACE_PERIOD_MINUTES", 5.minutes)
    end

    context "grace period is active" do
      before do
        # Use Timecop gem if test starts to fail for running too long.
        stub_const("Vaalit::Config::VOTE_SIGNIN_DAILY_CLOSING_TIME",
                   Time.now.strftime('%H:%M'))
      end

      it "vote signin is not active" do
        expect(RuntimeConfig.vote_signin_active?).to be false
      end

      it "voting is active" do
        expect(RuntimeConfig.voting_active?).to be true
      end

      it "elections are active" do
        expect(RuntimeConfig.elections_active?).to be true
      end
    end

    context "grace period is over" do
      before do
        stub_const("Vaalit::Config::VOTE_SIGNIN_DAILY_CLOSING_TIME",
                   301.seconds.ago.strftime('%H:%M'))
      end

      it "vote signin is not active" do
        expect(RuntimeConfig.vote_signin_active?).to be false
      end

      it "voting is not active" do
        expect(RuntimeConfig.voting_active?).to be false
      end

      it "elections are active" do
        expect(RuntimeConfig.elections_active?).to be true
      end
    end

  end

  context "voting has ended" do
    before do
      stub_const("Vaalit::Config::VOTE_SIGNIN_STARTS_AT", 3.days.ago)
      stub_const("Vaalit::Config::Vaalit::Config::VOTING_GRACE_PERIOD_MINUTES", 5.minutes)
    end

    context "grace period is active" do
      before do
        stub_const("Vaalit::Config::VOTE_SIGNIN_ENDS_AT", 299.seconds.ago)
      end

      it "vote signin is not active" do
        expect(RuntimeConfig.vote_signin_active?).to be false
      end

      it "voting is active" do
        expect(RuntimeConfig.voting_active?).to be true
      end

      it "elections are active" do
        expect(RuntimeConfig.elections_active?).to be true
      end
    end

    context "grace period is over" do
      before do
        stub_const("Vaalit::Config::VOTE_SIGNIN_ENDS_AT", 300.seconds.ago)
      end

      it "vote signin is not active" do
        expect(RuntimeConfig.vote_signin_active?).to be false
      end

      it "voting is not active" do
        expect(RuntimeConfig.voting_active?).to be false
      end

      it "elections are not active" do
        expect(RuntimeConfig.elections_active?).to be false
      end
    end
  end
end
