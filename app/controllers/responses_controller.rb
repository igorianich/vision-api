# frozen_string_literal: true

class ResponsesController < ApplicationController
  before_action :load_response, only: %i[
    show update destroy true_requester request_errors decline true_owner
  ]

  def index
    render json: :sadsasdsadas
    # p 'sfdsfdsf'
  end

  def show
    render json: response
  end

  def create
    render json: current_user
    # @response = Request.new(requester: current_user, status: 0, **request_params)
    # if response.save
    #   payment = Payment.create(payment_params)
    #   render json: [response, payment]
    # else
    #   render_errors(request_errors)
    # end
  end
  #
  # def decline
  #   if true_owner && response.rejected! && response.pending_answer?
  #     render json: response
  #   else
  #     if response.service.owner != current_user
  #       request_errors.add(:requester, "can't decline request")
  #     elsif response.status != 'pending_answer'
  #       request_errors.add(:status, "can't be change")
  #     end
  #     render_errors(request_errors)
  #   end
  # end
  #
  # def update
  #   if true_requester == true && response.update(request_params)
  #     render json: response
  #   else
  #     # response_errors.add(:owner, 'is not valid')
  #     render_errors(request_errors)
  #   end
  # end
  #
  # def destroy
  #   if true_requester == true
  #     response.destroy
  #   else
  #     # response_errors.add(:owner, 'is not valid')
  #     render_errors(request_errors)
  #   end
  # end

  private

  attr_reader :response

  #
  # def request_errors
  #   response.errors
  # end
  #
  # def true_requester
  #   response.requester == current_user || request_errors.add(:requester, 'is not valid')
  # end
  #
  # def true_owner
  #   response.service.owner == current_user || request_errors.add(:requester, "can't be owner")
  # end

  def load_response
    @response = user_responses.find_by(id: params[:id]) || head(:not_found)
  end

  def user_responses
    case current_user.role
    when 'buyer'
      current_user.outgoing_responses
    when 'seller'
      current_user.incoming_responses
    else
      Response.all
    end
  end

  def response_service
    response.service
  end

  def response_params
    params.require(:response).permit(:text, :file)
  end
end
