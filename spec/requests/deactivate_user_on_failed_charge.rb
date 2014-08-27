require 'rails_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
    {
      "id" => "evt_14WA3v4Qh7wz3HEYwbcGfWXa",
      "created" => 1409159903,
      "livemode" => false,
      "type" => "charge.failed",
      "data" =>
      {
        "object" =>
        {
          "id" => "ch_14WA3v4Qh7wz3HEYz78bfmw8",
          "object" => "charge",
          "created" => 1409159903,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_14WA3C4Qh7wz3HEYZohVZv32",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 8,
            "exp_year" => 2017,
            "fingerprint" => "9Gy4w8yPVctXWgz3",
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
            "customer" => "cus_4em1tp1Kljez3a"
          },
          "captured" => false,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_14WA3v4Qh7wz3HEYz78bfmw8/refunds",
            "data" => []
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_4em1tp1Kljez3a",
          "invoice" => nil,
          "description" => "testing a failing cc",
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => "MyFlix test",
          "receipt_email" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 3,
      "request" => "iar_4fV4Z3MbAyHpwW"
    }
  end

  it "deactivates the user with the web hook data from stripe for a charge.failed", :vcr do
    alice = Fabricate(:user, customer_token: 'cus_4em1tp1Kljez3a')
    post '/stripe_events', event_data
    expect(alice.reload).not_to be_active
  end
end
