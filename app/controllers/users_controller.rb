# frozen_string_literal: true

class UsersController < ApplicationController
  has_scope :by_skill_name

  def index
    render json: apply_scopes(User)
      .where(role: :seller)
      .select(:id, :first_name, :last_name, :age, :description)
  end

  def show
    render json: User.where(role: :seller)
                     .select(:id, :first_name, :last_name, :age, :description)
                     .find(params[:id])
    # render json: user
  end

  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: {
        jwt: "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}",
        payload: user.as_json
      }
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :age, :email, :password,
      :role, :description
    )
  end
end
