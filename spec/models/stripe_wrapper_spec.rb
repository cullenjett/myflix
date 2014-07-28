require "rails_helper"

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "creates a successful charge", :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
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

        expect(stripe_response.amount).to eq(100)
        expect(stripe_response.currency).to eq('usd')
      end
    end
  end
end