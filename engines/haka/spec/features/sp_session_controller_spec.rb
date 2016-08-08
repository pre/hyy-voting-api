describe "SpSessionController", :type => :feature do
  context "sign in process" do
    before :each do
      # User.make(:email => 'user@example.com', :password => 'password')
    end

    it "signs me in" do
      visit '/haka/sp_session/new'
      within("form") do
        fill_in 'Email', :with => 'teppo@example.com'
        fill_in 'Password', :with => '31337'
      end
      click_button 'Sign in'
      expect(page).to have_content 'GREAT SUCCESS!'
    end
  end
end
