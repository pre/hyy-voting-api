require 'rails_helper'

RSpec.describe User, type: :model do

  context "create" do

    it "initializes a valid object" do
      voter = FactoryGirl.build :voter

      user = User.new voter

      expect(user.voter).to eq voter
    end

  end
end
