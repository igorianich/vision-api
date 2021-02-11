# frozen_string_literal: true

class PaymentsController < ApplicationController
  def index
    payments = policy_scope(Payment)
    render json: payments
  end

  def show
    payment = Payment.find(params[:id])
    authorize payment
    render json: payment
  end
end
