require 'rails_helper'

module Haka
  describe "AuthController", :type => :feature do
    context "sign in process" do
      before :each do
        haka_user_student_number = 8734
        @voter = FactoryGirl.create :voter, student_number: haka_user_student_number
      end

      it "signs me in" do
        visit '/haka/auth/new'

        within("form") do
          fill_in 'Username', :with => "teppo"
          fill_in 'Password', :with => "testaaja"
        end

        click_button 'Login'

        expect(page).to have_content 'Sinulla ei ole äänioikeutta yhteenkään vaaliin.' # TODO
      end
    end
  end
end
