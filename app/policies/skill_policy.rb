# frozen_string_literal: true

class SkillPolicy < ApplicationPolicy
  # frozen_string_literal: true
  class Scope < Scope
    def resolve
      user.skills
    end
  end

  def update?
    user_is_owner_of_record?
  end

  def show?
    user_is_owner_of_record?
  end

  def destroy?
    user_is_owner_of_record?
  end
end
