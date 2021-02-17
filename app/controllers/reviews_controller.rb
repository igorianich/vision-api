# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :load_review, only: %i[show update destroy]
  def index
    reviews = policy_scope(Review)
    render json: reviews
  end

  def create
    review = Review.new(review_params)
    authorize review
    if review.save
      render json: review
    else
      render_errors(review.errors)
    end
  end

  def show
    render json: review
  end

  def update
    if review.update(review_params)
      render json: review
    else
      render_errors(review.errors)
    end
  end

  def destroy
    review.destroy
  end

  private

  attr_reader :review

  def load_review
    @review = Review.find(params[:id])
    authorize @review
  end

  def review_params
    params.require(:review).permit(:rate, :file, :text, :response_id)
  end
end
