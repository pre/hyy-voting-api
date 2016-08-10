require 'rails_helper'

module Haka
  describe "AuthController", :type => :feature do
    context "sign in process" do
      before :each do
        @voter = FactoryGirl.create :voter
      end

      it "signs me in" do
        visit '/haka/auth/new'

        within("form") do
          fill_in 'Email', :with => "#{@voter.student_number}@example.com"
          fill_in 'Password', :with => "#{@voter.student_number}" #dolan
        end

        click_button 'Sign in'

        expect(page).to have_content 'Sinulla ei ole äänioikeutta yhteenkään vaaliin.' # TODO
      end
    end
  end
end
