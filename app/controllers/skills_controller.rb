# frozen_string_literal: true

class SkillsController < ApplicationController
  before_action :load_skill, only: %i[show update destroy]
  def index
    skills = policy_scope(Skill)
    render json: skills
  end

  def create
    skill = current_user.skills.new(skill_params)
    if skill.save
      render json: skill
    else
      render_errors(skill.errors)
    end
  end

  def show
    render json: skill
  end

  def update
    if skill.update(skill_params)
      render json: skill
    else
      render_errors(skill.errors)
    end
  end

  def destroy
    skill.destroy
  end

  private

  attr_reader :skill

  def load_skill
    @skill = Skill.find(params[:id])
    authorize @skill
  end

  def skill_params
    params.require(:skill).permit(:name, :description)
  end
end
