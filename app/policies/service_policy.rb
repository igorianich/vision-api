class ServicePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user_is_owner_of_record?
    # if user_is_owner_of_record?
    #   true
    # else
    #   raise Pundit::NotAuthorizedError, reason: 'user_is_owner_of_record'
    # end
  end


  def destroy?
    user_is_owner_of_record?
  end

  def show?
    true
  end
end
