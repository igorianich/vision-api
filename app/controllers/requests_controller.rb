# frozen_string_literal: true

class RequestsController < ApplicationController
  before_action :load_request, only: %i[show update destroy decline]

  def index
    requests = policy_scope(Request)
    render json: requests
  end

  def show
    render json: requesto
  end

  def create
    authorize @requesto = current_user.requests.new(request_params)
    if requesto.save
      payment = Payment.create(payment_params)
      payment.reserve
      render json: { request: requesto, payment: payment }
    else
      render_errors(request_errors)
    end
  end

  def decline
    if requesto.update(status: :rejected) && requesto.payment.reject
      render json: requesto
    else
      render_errors(request_errors)
    end
  end

  def update
    if requesto.update(request_params.permit(:text, :file,))
      render json: requesto
    else
      render_errors(request_errors)
    end
  end

  def destroy
    requesto.destroy
  end

  private

  attr_reader :requesto

  def request_errors
    requesto.errors
  end

  def load_request
    @requesto = Request.find(params[:id])
    authorize requesto
  end

  def request_service
    requesto.service
  end

  def request_params
    params.require(:request).permit(:text, :file, :service_id)
  end

  def payment_params
    {
      request: requesto, payer: current_user, seller: request_service.owner,
      service_price: request_service.price, net: request_service.net,
      commission: request_service.commission, status: 0
    }
  end
end
