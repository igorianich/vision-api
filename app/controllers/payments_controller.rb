# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :load_payment, only: %i[show pay]

  def index
    payments = policy_scope(Payment)
    render json: payments
  end

  def show
    render json: payment
  end

  def pay
    if payment.pay
      render json: payment
    else
      render_errors(payment_errors)
    end
  end

  private

  attr_reader :payment

  def payment_errors
    payment.errors
  end

  def load_payment
    @payment = Payment.find(params[:id])
    authorize @payment
  end
end
