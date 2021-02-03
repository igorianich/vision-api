# frozen_string_literal: true

class ResponsesController < ApplicationController
  before_action :load_response, only: %i[
    show
  ]
  def index
    render json: user_responses
    # p 'sfdsfdsf'
  end

  def show
    render json: answer
  end

  def create
    requester = Request.find(response_params[:request_id]).requester
    @answer = Response.new(
      requester: requester, respondent: current_user, **response_params
    )
    if answer.save
      request = answer.request
      request.completed!
      render json: [answer, request]
    else
      render_errors(response_errors)
    end
  end

  private

  attr_reader :answer

  def response_errors
    answer.errors
  end

  def load_response
    @answer = user_responses.find_by(id: params[:id]) || head(:not_found)
  end

  def user_responses
    case current_user.role
    when 'buyer'
      current_user.incoming_responses
    when 'seller'
      current_user.outgoing_responses
    else
      Response.all
    end
  end

  # def response_service
  #   response.service
  # end
  #
  def response_params
    params.require(:response).permit(:text, :file, :request_id)
  end
end
