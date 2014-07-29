require "rails_helper"

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "creates a successful charge", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 7,
            :exp_year => 2016,
            :cvc => "314"
          },
        ).id

        stripe_response = StripeWrapper::Charge.create(
          amount: 100,
          card: token,
          description: "A valid charge."
        )

        expect(stripe_response).to be_successful
      end

      it "creates a declined charge", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 7,
            :exp_year => 2016,
            :cvc => "314"
          },
        ).id

        stripe_response = StripeWrapper::Charge.create(
          amount: 100,
          card: token,
          description: "An invalid charge."
        )

        expect(stripe_response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 7,
            :exp_year => 2016,
            :cvc => "314"
          },
        ).id

        stripe_response = StripeWrapper::Charge.create(
          amount: 100,
          card: token,
          description: "An invalid charge."
        )

        expect(stripe_response.error_message).to eq("Your card was declined.")
      end
    end #.create
  end #StripeWrapper::Charge
end #StripeWrapper