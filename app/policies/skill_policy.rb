# frozen_string_literal: true

class SkillPolicy < ApplicationPolicy
  # frozen_string_literal: true
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    @user.seller?
  end

  def update?
    user_is_owner_of_record?
  end

  def show?
    true
  end

  def destroy?
    user_is_owner_of_record?
  end
end
