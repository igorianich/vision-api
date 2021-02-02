
class UsersController < ApplicationController
  def update
    # render json: current_user
    if current_user.update(user_params)
      render json: current_user
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :age, :email, :password, :description
    )
  end
end
