Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    require 'pry'; binding.pry
    user = User.where(customert_token: event.data.object.customer)
    Payment.create!(user: user)
  end
end
