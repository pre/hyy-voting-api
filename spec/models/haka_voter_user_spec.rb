require 'rails_helper'

module Haka
  RSpec.describe VoterUser, type: :model do
    context "sign in from Haka" do
      before do
        @student_number = "8734"
        @raw_student_number = "urn:schac:personalUniqueCode:fi:yliopisto.fi:x8734"

        @voter = FactoryGirl.build(:voter)
        allow(Voter).to receive(:find_by_student_number!).and_return(@voter)

        @voter_user = VoterUser.new @raw_student_number
      end

      it "initialises a valid object with raw student id" do
        expect(@voter_user.voter).to eq(@voter)
      end

      it "gets student number from SAML attributes" do
        expect(@voter_user.student_number).to eq @student_number
      end

    end
  end
end
