require 'rails_helper'

describe 'Create payment on successful charge' do
  let(:event_data) do
    {
      "id" => "evt_14CrCP4OlWR9sB6HLFDsNf8i",
      "created" => 1404559161,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_14CrCP4OlWR9sB6HJC30Xr9d",
          "object" => "charge",
          "created" => 1404559161,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "cad",
          "refunded" => false,
          "card" => {
            "id" => "card_14CrCO4OlWR9sB6Hyc6fuAbE",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 10,
            "exp_year" => 2016,
            "fingerprint" => "LdQx4SlIvRodhqeR",
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
            "customer" => "cus_4LYJBGmYtTyEIn"
          },
          "captured" => true,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14CrCP4OlWR9sB6HJC30Xr9d/refunds",
            "data" => []
          },
          "balance_transaction" => "txn_14CrCP4OlWR9sB6Hs7uuPNcD",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_4LYJBGmYtTyEIn",
          "invoice" => "in_14CrCP4OlWR9sB6HOSqx396u",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_4LYJj814spNuWR"
    }
  end

  it "creates a payment with the webhook from stripe for charge.succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_4ZrMlQOnMeD5UZ")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end
end
