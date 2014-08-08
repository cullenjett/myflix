require "rails_helper"

describe UserSignup do
  describe "#sign_up" do
    after { ActionMailer::Base.deliveries.clear }

    context "valid user info and credit card" do
      let(:customer) { double(:customer, successful?: true) }

      before { expect(StripeWrapper::Customer).to receive(:create).and_return(customer) }

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some stripe token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow in the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', name: 'Joe Blow')).sign_up("some stripe token", invitation.token)
        joe = User.where(email: 'joe@example.com').first
        expect(joe.follows?(alice)).to be true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', name: 'Joe Blow')).sign_up("some stripe token", invitation.token)
        joe = User.where(email: 'joe@example.com').first
        expect(alice.follows?(joe)).to be true
      end

      it "expires the invitation on acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', name: 'Joe Blow')).sign_up("some stripe token", invitation.token)
        joe = User.where(email: 'joe@example.com').first
        expect(Invitation.first.token).to be nil
      end
    end

    context "valid personal info and invalid credit card" do
      it "does not create a new user" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined")
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('some stripe token', nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid personal info" do
      after { ActionMailer::Base.deliveries.clear }

      it "does not create a user" do
        UserSignup.new(User.new(email: 'no_password@example.com')).sign_up('some stripe token', nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the credit card" do
        expect(StripeWrapper::Customer).not_to receive(:create)
        UserSignup.new(User.new(email: 'no_password@example.com')).sign_up('some stripe token', nil)
      end

      it "does not send email" do
        UserSignup.new(User.new(email: 'no_password@example.com')).sign_up('some stripe token', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "sending emails" do
      let(:customer) { double(:customer, successful?: true) }

      before { expect(StripeWrapper::Customer).to receive(:create).and_return(customer) }

      after { ActionMailer::Base.deliveries.clear }

      it "sends email to new users with vaild inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com')).sign_up("some stripe token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sends email containing the user's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', name: 'Joe')).sign_up("some stripe token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe")
      end
    end
  end #sign_up
end
