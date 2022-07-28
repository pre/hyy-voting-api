require 'rails_helper'

module Haka
  RSpec.describe Person, type: :model do
    context "sign in from Haka with valid user" do
      before do
        @student_number = "08734"
        @raw_student_number = "urn:schac:personalUniqueCode:fi:yliopisto.fi:08734"

        @voter = FactoryBot.build(:voter)
        allow(Voter).to receive(:find_by_student_number!).with(@student_number).and_return(@voter)

        @person = Person.new @raw_student_number
      end

      it "initialises a valid object with raw student id" do
        expect(@person.voter).to eq(@voter)
        expect(@person).to be_valid
      end

    end

    context "sign in from Haka with invalid user" do
      it "doesn't pass validations when user does not have right to vote" do
        number = "08734210"
        not_found = "urn:schac:personalUniqueCode:fi:yliopisto.fi:#{number}"

        person = Person.new not_found

        expect(person).not_to be_valid
        expect(person.errors[:voter].first).to eq "no voting right for student number '#{number}'"
      end

      it "doesn't pass validations when user does not have a student number attribute" do
        person = Person.new nil

        expect(person).not_to be_valid
        expect(person.errors[:student_number].first).to eq "invalid value for unparsed student number: ''"
        expect(person.errors[:voter].first).to eq "no voting right for student number ''"
      end

      it "doesn't pass validations when user has an invalid student number attribute" do
        person = Person.new "somethingwentwrong"

        expect(person).not_to be_valid
      end
    end

  end
end
