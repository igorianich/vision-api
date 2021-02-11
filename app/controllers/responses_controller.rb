# frozen_string_literal: true

class ResponsesController < ApplicationController
  before_action :load_response, only: %i[show]

  def index
    responses = policy_scope(Response)
    render json: responses
  end

  def show
    render json: answer
  end

  def create
    request = Request.find(response_params[:request_id])
    answer = Response.new(
      requester: request.requester, respondent: current_user, **response_params
    )
    if answer.save
      request.completed! && request.payment.pay
      render json: { answer: answer, request: request }
    else
      render_errors(answer.errors)
    end
  end

  private

  attr_reader :answer

  def load_response
    @answer = Response.find(params[:id])
    authorize answer
  end

  def response_params
    params.require(:response).permit(:text, :file, :request_id)
  end
end
