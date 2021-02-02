# frozen_string_literal: true

class ServicesController < ApplicationController
  before_action :load_service, only: %i[show update destroy true_owner services_errors]

  def index
    services = Service.all
    # items = items.by_city(params[:by_city]) if params[:by_city]
    # items = items.by_owner(params[:by_owner]) if params[:by_owner]
    # items = items.by_category(params[:by_category]) if params[:by_category]
    # items = items.by_options(params[:by_options]) if params[:by_options]
    # items = items.min_price(params[:min_price]) if params[:min_price]
    # items = items.max_price(params[:max_price]) if params[:max_price]
    # item = item.page(params[:page]) if params[:page]
    render json: services
  end

  def show
    render json: service
  end

  def create
    # render json: current_user
    @service = Service.new(owner: current_user, **service_params)
    if service.save
      render json: service
    else
      render_errors(service_errors)
    end
  end

  def update
    if true_owner == true && service.update(service_params)
      render json: service
    else
      # service_errors.add(:owner, 'is not valid')
      render_errors(service_errors)
    end
  end

  def destroy
    if true_owner == true
      service.destroy
    else
      # service_errors.add(:owner, 'is not valid')
      render_errors(service_errors)
    end
  end

  private

  attr_reader :service

  def service_errors
    service.errors
  end

  def true_owner
    service.owner == current_user || service_errors.add(:owner, 'is not valid')
  end

  def load_service
    (@service = Service.find_by(id: params[:id])) || head(:not_found)
  end

  def service_params
    params.require(:service).permit(:name, :description, :price)
  end
end
