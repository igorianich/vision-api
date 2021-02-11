# frozen_string_literal: true

class RequestPolicy < ApplicationPolicy
  # frozen_string_literal: true
  class Scope < Scope
    def resolve
      case user.role
      when 'buyer'
        user.requests
      when 'seller'
        user.own_requests
      when 'admin'
        scope.all
      end
    end
  end

  def show?
    user_is_requester_of_record? || user_is_owner_of_service?
  end

  def update?
    user_is_requester_of_record?
  end

  def destroy?
    user_is_requester_of_record?
  end

  def decline?
    user_is_owner_of_service?
  end

  def user_is_requester_of_record?
    @user == @record.requester
  end

  def user_is_owner_of_service?
    @user == @record.service.owner
  end
end
