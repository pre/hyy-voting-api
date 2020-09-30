RSpec.describe Voter, type: :model do
  describe "#deliver" do
    context "when valid" do
      let(:email) { 'user@example.com' }
      let!(:voter) { FactoryBot.create :voter, email: email }
      let(:jwt_token) { 'sekrit_jwt_token' }
      let(:session_token) { instance_double(SessionToken) }
      let(:url) { "#{Vaalit::Public::SITE_ADDRESS}/#/sign-in?token=#{jwt_token}" }
      let(:action_mailer_delivery) { instance_double(ActionMailer::MessageDelivery) }

      before do
        allow(SessionLinkMailer)
          .to receive(:signup_link)
          .with(email, url)
          .and_return action_mailer_delivery

        allow(SessionToken)
          .to receive(:new)
          .with(voter)
          .and_return session_token

        allow(session_token)
          .to receive(:ephemeral_jwt)
          .with(Vaalit::Config::EMAIL_LINK_JWT_EXPIRY_MINUTES)
          .and_return jwt_token

        allow(action_mailer_delivery)
          .to receive(:deliver_later)
          .and_return "okay"
      end

      it "sends a signup link" do
        expect(SessionLink.new(email: email).deliver)
          .to eq "okay"
      end
    end

    context "when voter does not exist" do
      let(:email) { 'doesnotexist@example.com' }
      let(:subject) { SessionLink.new(email: email)}

      it 'fails validation' do
        expect(subject.deliver).to be false
        expect(subject.errors.messages).to eq(
          {
            email: ["Given email doesn't have any elections"],
            email_error_key: [".not_eligible_in_any_election"]
          }
        )
      end
    end

    context "when email is missing" do
      let(:subject) { SessionLink.new(email: nil)}

      it 'fails validation' do
        expect(subject.deliver).to be false
        expect(subject.errors.messages).to eq(
          {
            email: ["Given email doesn't have any elections", "can't be blank"],
            email_error_key: [".not_eligible_in_any_election"]
          }
        )
      end
    end
  end
end
