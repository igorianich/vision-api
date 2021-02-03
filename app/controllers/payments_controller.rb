# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :load_payment, only: %i[show update destroy user_payments true_requester payment_errors]

  def index
    render json: user_payments
  end

  def show
    render json: payment
  end

  def update
    if payment.payer == current_user && status != 'rejected'
      if payment.pay
        render json: payment
      else
        render_errors(payment_errors)
      end
    else
      payment_errors.add(:payer, 'is not valid')
      render_errors(payment_errors)
    end

  end


  private

  attr_reader :payment

  def payment_errors
    payment.errors
  end


  #
  # def true_requester
  #   requesto.requester == current_user || request_errors.add(:requester, 'is not valid')
  # end

  def load_payment
    @payment = user_payments.find_by(id: params[:id]) || head(:not_found)
  end

  def not_found
    head(:not_found)
  end

  def user_payments
    case current_user.role
    when 'seller'
      current_user.incoming_payments || not_found
    when 'buyer'
      current_user.outgoing_payments || not_found
    when 'admin'
      Payment.all
    end
  end

end
