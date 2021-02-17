# frozen_string_literal: true

class ServicesController < ApplicationController
  before_action :load_service, only: %i[show update destroy services_errors]

  has_scope :by_owner
  has_scope :by_name
  has_scope :min_price
  has_scope :max_price

  def index
    services = policy_scope(Service)
    render json: apply_scopes(services)
    # filtering_params.each do |filter, value|
    #   services = services.public_send(filter, value)
    # end
    # render json: services
  end

  def show
    render json: service
  end

  def create
    service = current_user.services.new(service_params)
    authorize service
    if service.save
      render json: service
    else
      render_errors(service.errors)
    end
  end

  def update
    if service.update(service_params)
      render json: service
    else
      render_errors(service.errors)
    end
  end

  def destroy
    service.destroy
  end

  private

  attr_reader :service

  def load_service
    @service = Service.find(params[:id])
    authorize service
  end

  def service_params
    params.require(:service).permit(:name, :description, :price)
  end

  # def filtering_params
  #   params.permit(:by_name, :by_owner, :min_price, :max_price)
  # end
end
