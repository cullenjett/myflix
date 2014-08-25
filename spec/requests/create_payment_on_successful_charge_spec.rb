require 'rails_helper'

describe 'Create payment on successful charge' do
  let(:event_data) do
    {
      "id" => "evt_14VQel4Qh7wz3HEYL1EkWXoz",
      "created" => 1408985363,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_14VQek4Qh7wz3HEYFfTdbrTg",
          "object" => "charge",
          "created" => 1408985362,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14VQeg4Qh7wz3HEYkNiveG1V",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2014,
            "fingerprint" => "sO2ZTBxeuCANiBGv",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "customer" => "cus_4ek9WG5viPn0DB"
          },
          "captured" => true,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14VQek4Qh7wz3HEYFfTdbrTg/refunds",
            "data" => [

            ]
          },
          "balance_transaction" => "txn_14VQek4Qh7wz3HEYlK4yVlPl",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_4ek9WG5viPn0DB",
          "invoice" => "in_14VQek4Qh7wz3HEYIavY0rYP",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {
          },
          "statement_description" => "MyFlix",
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4ek9Z4SLK8HyYL"
    }
  end

  it "creates a payment with the webhook from stripe for charge.succeeded",  :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_4ek9WG5viPn0DB")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount", :vcr do
    alice = Fabricate(:user, customer_token: "cus_4ek9WG5viPn0DB")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with reference id", :vcr do
    alice = Fabricate(:user, customer_token: "cus_4ek9WG5viPn0DB")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq('ch_14VQek4Qh7wz3HEYFfTdbrTg')
  end
end
