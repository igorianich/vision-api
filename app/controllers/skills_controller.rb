# frozen_string_literal: true

class SkillsController < ApplicationController
  before_action :load_skill, only: %i[show update destroy true_owner skill_errors]

  def index
    skills = Skill.all
    # items = items.by_city(params[:by_city]) if params[:by_city]
    # items = items.by_owner(params[:by_owner]) if params[:by_owner]
    # items = items.by_category(params[:by_category]) if params[:by_category]
    # items = items.by_options(params[:by_options]) if params[:by_options]
    # items = items.min_price(params[:min_price]) if params[:min_price]
    # items = items.max_price(params[:max_price]) if params[:max_price]
    # item = item.page(params[:page]) if params[:page]
    render json: skills
  end

  def create
      # render json: current_user
    @skill = Skill.new(owner: current_user, **skill_params)
    if skill.save
      render json: skill
    else
      render_errors(skill_errors)
    end
  end

  def update
    if true_owner && skill.update(skill_params)
      render json: skill
    else
      skill_errors.add(:owner, 'is not valid')
      render_errors(skill_errors)
    end
  end

  def destroy
    if true_owner
      skill.destroy
    else
      skill_errors.add(:owner, 'is not valid')
      render_errors(skill_errors)
    end
  end

  private

  attr_reader :skill

  def skill_errors
    skill.errors
  end

  def true_owner
    skill.owner == current_user
  end

  def load_skill
    (@skill = Skill.find_by(id: params[:id])) || head(:not_found)
  end

  def skill_params
    params.require(:skill).permit(:name, :description)
  end
end
