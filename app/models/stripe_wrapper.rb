module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: 'usd',
          card: options[:card],
          description: options[:description]
        )
        Charge.new(response: response)
      rescue Stripe::CardError => e
        Charge.new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end #class Charge

  class Customer
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          plan: "base",
          email: options[:user].email
        )
        Customer.new(response: response)
      rescue Stripe::CardError => e
        Customer.new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end

    def customer_token
      response.id
    end
  end #class Customer
end
