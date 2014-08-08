require "rails_helper"

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 7,
        :exp_year => 2016,
        :cvc => "314"
      },
    ).id
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 7,
        :exp_year => 2016,
        :cvc => "314"
      },
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      it "creates a successful charge", :vcr do
        stripe_response = StripeWrapper::Charge.create(
          amount: 100,
          card: valid_token,
          description: "A valid charge."
        )
        expect(stripe_response).to be_successful
      end

      it "creates a declined charge", :vcr do
        stripe_response = StripeWrapper::Charge.create(
          amount: 100,
          card: declined_card_token,
          description: "An invalid charge."
        )
        expect(stripe_response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        stripe_response = StripeWrapper::Charge.create(
          amount: 100,
          card: declined_card_token,
          description: "An invalid charge."
        )
        expect(stripe_response.error_message).to eq("Your card was declined.")
      end
    end #.create
  end #StripeWrapper::Charge

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with a valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: valid_token
        )
        expect(response).to be_successful
      end

      it "does not create a customer with a declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: declined_card_token
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for a declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          card: declined_card_token
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end #StripeWrapper::Customer
end #StripeWrapper
