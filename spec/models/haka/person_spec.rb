require 'rails_helper'

module Haka
  RSpec.describe Person, type: :model do
    context "with valid Haka user" do
      let(:voter) { FactoryBot.build(:voter) }
      let(:person) { Person.new(saml_student_number) }

      before do
        allow(Voter)
          .to receive(:find_by_student_number!)
          .with(expected_student_number)
          .and_return(voter)
      end

      context "having a single student number as string" do
        let(:saml_student_number) do
          "urn:schac:personalUniqueCode:fi:yliopisto.fi:x08734"
        end

        let(:expected_student_number) { "x08734" }

        it "initialises a valid object with raw student id" do
          expect(person.voter).to eq(voter)
          expect(person).to be_valid
        end
      end

      context "having one unacceptable and one acceptable student number" do
        let(:saml_student_number) do
          [
            "urn:schac:personalUniqueCode:fi:unacceptable.fi:9876543",
            "urn:schac:personalUniqueCode:fi:yliopisto.fi:01234567"
          ]
        end
        let(:expected_student_number) { "01234567" }

        it "initialises a valid object with raw student id" do
          expect(person.voter).to eq(voter)
          expect(person).to be_valid
        end
      end
    end

    context "having two unacceptable student numbers" do
      let(:saml_student_number) do
        [
          "urn:schac:personalUniqueCode:fi:unacceptable.fi:9876543",
          "urn:schac:personalUniqueCode:fi:something-else.fi:01234567"
        ]
      end
      let(:person) { Person.new(saml_student_number) }

      it "returns an invalid Voter" do
        expect(person).not_to be_valid
        expect(person.errors[:student_number].first).to eq "SAML student number could not be found"
      end
    end

    context "having one unacceptable student number as array" do
      let(:saml_student_number) do
        [
          "urn:schac:personalUniqueCode:fi:unacceptable.fi:9876543"
        ]
      end
      let(:person) { Person.new(saml_student_number) }

      it "returns an invalid Voter" do
        expect(person).not_to be_valid
        expect(person.errors[:student_number].first).to eq "SAML student number could not be found"
      end
    end

    context "having one unacceptable student number as string" do
      let(:saml_student_number) { "urn:schac:personalUniqueCode:fi:unacceptable.fi:9876543" }
      let(:person) { Person.new(saml_student_number) }

      it "returns an invalid Voter" do
        expect(person).not_to be_valid
        expect(person.errors[:student_number].first).to eq "SAML student number could not be found"
      end
    end

    context "with invalid Haka user" do
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
        expect(person.errors[:student_number].first).to eq "SAML student number value missing"
        expect(person.errors[:voter].first).to eq "no voting right for student number ''"
      end

      it "doesn't pass validations when user has an invalid student number attribute" do
        person = Person.new "somethingwentwrong"

        expect(person).not_to be_valid
      end
    end
  end
end
