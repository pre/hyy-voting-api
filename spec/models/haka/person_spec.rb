require 'rails_helper'

module Haka
  RSpec.describe Person, type: :model do
    context "sign in from Haka" do
      before do
        @student_number = "8734"
        @raw_student_number = "urn:schac:personalUniqueCode:fi:yliopisto.fi:x8734"

        @voter = FactoryGirl.build(:voter)
        allow(Voter).to receive(:find_by_student_number!).with(@student_number).and_return(@voter)

        @person = Person.new @raw_student_number
      end

      it "initialises a valid object with raw student id" do
        expect(@person.voter).to eq(@voter)
      end

    end
  end
end
