# frozen_string_literal: true

class ResponsesController < ApplicationController
  def index
    responses = policy_scope(Response)
    render json: responses
  end

  def show
    answer = authorize Response.find(params[:id])
    render json: answer
  end

  def create
    result = Responses::Create.new.call(response_params)
    if result.success?
      render json: { response: result.success }
    else
      render_errors(result.failure)
    end
  end

  private

  def response_params
    params.require(:response).permit(:text, :file, :request_id)
  end
end
