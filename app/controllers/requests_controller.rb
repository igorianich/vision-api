# frozen_string_literal: true

class RequestsController < ApplicationController
  before_action :load_request, only: %i[
    show update destroy true_requester request_errors decline true_owner
  ]

  def index
    # user_requests    # items = items.by_owner(params[:by_owner]) if params[:by_owner]
    # items = items.by_category(params[:by_category]) if params[:by_category]
    # items = items.by_options(params[:by_options]) if params[:by_options]
    # items = items.min_price(params[:min_price]) if params[:min_price]
    # items = items.max_price(params[:max_price]) if params[:max_price]
    # item = item.page(params[:page]) if params[:page]
    render json: user_requests
  end

  def show
    render json: requesto
  end

  def create
    # render json: current_user
    @requesto = Request.new(requester: current_user, status: 0, **request_params)
    if requesto.save
      payment = Payment.create(payment_params)
      render json: [requesto, payment]
    else
      render_errors(request_errors)
    end
  end

  def decline
    if true_owner && requesto.rejected! && requesto.pending_answer?
      render json: requesto
    else
      if requesto.service.owner != current_user
        request_errors.add(:requester, "can't decline request")
      elsif requesto.status != 'pending_answer'
        request_errors.add(:status, "can't be change")
      end
      render_errors(request_errors)
    end
  end

  def update
    if true_requester == true && requesto.update(request_params)
      render json: requesto
    else
      # requesto_errors.add(:owner, 'is not valid')
      render_errors(request_errors)
    end
  end

  def destroy
    if true_requester == true
      requesto.destroy
    else
      # requesto_errors.add(:owner, 'is not valid')
      render_errors(request_errors)
    end
  end

  private

  attr_reader :requesto

  def request_errors
    requesto.errors
  end

  def true_requester
    requesto.requester == current_user || request_errors.add(:requester, 'is not valid')
  end

  def true_owner
    requesto.service.owner == current_user || request_errors.add(:requester, "can't be owner")
  end

  def load_request
    @requesto = user_requests.find_by(id: params[:id]) || head(:not_found)
  end

  def user_requests
    case current_user.role
    when 'seller'
      current_user.own_requests
    when 'buyer'
      current_user.requests
    else
      Request.all
    end
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
