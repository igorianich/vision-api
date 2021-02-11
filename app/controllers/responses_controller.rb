# frozen_string_literal: true

class ResponsesController < ApplicationController
  def index
    responses = policy_scope(Response)
    render json: responses
  end

  def show
    answer = Response.find(params[:id])
    authorize answer
    render json: answer
  end

  def create
    request = Request.find(response_params[:request_id])
    answer = Response.new(
      requester: request.requester, respondent: current_user, **response_params
    ) && payment = request.payment
    if answer.save
      request.completed! && payment.pay
      render json: { answer: answer, request: request, payment: payment }
    else
      render_errors(answer.errors)
    end
  end

  private

  def response_params
    params.require(:response).permit(:text, :file, :request_id)
  end
end
