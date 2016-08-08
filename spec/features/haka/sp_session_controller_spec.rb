require 'rails_helper'

module Haka
  describe "SpSessionController", :type => :feature do
    context "sign in process" do
      before :each do
        @voter = FactoryGirl.create :voter
      end

      it "signs me in" do
        visit '/haka/sp_session/new'

        within("form") do
          fill_in 'Email', :with => "#{@voter.student_number}@example.com"
          fill_in 'Password', :with => "#{@voter.student_number}" #dolan
        end

        click_button 'Sign in'

        expect(page).to have_content 'GREAT SUCCESS!'
      end
    end
  end
end
