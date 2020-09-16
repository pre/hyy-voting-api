require 'rails_helper'

## Selenium test is disabled as Chromedriver is too much of a hassle to keep working
## between elections every 2 year.

# module Haka
#   describe "AuthController", :type => :feature do
#     context "sign in process" do
#       before :each do
#         haka_user_student_number = 8734
#         election = FactoryGirl.create :election, :edari_election
#         @voter = FactoryGirl.create :voter, :with_voting_right,
#                                     election: election,
#                                     student_number: haka_user_student_number

#         allow(RuntimeConfig).to receive(:vote_signin_active?).and_return true
#       end

#       it "signs teppo testaaja in" do
#         visit '/haka/auth/new'

#         within("form") do
#           fill_in 'Username', :with => "teppo"
#           fill_in 'Password', :with => "testaaja"
#         end

#         click_button 'Login'

#         #TODO: Conditionally click Accept when Haka asks a confirmation
#         # click_button 'Accept'

#         expect(page).to have_content 'Vaalin nimi'
#       end
#     end
#   end
# end
