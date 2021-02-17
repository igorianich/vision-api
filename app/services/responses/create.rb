require 'dry/monads'

module Responses
  class Create
    include Dry::Monads[:result, :do]

    def call(response_params)
      response = Response.new(response_params)

      if response.save
        response.request.completed!
        response.request.payment.pay

        Success(response)
      else
        Failure(response.errors)
      end
    end
  end
end
