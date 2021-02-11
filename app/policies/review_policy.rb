class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user_is_requester_of_response?
  end

  def update?
    user_is_requester_of_response?
  end

  def destroy?
    user_is_requester_of_response?
  end

  def show?
    true
  end

  def user_is_requester_of_response?
    @user == @record.response.requester
  end
end
