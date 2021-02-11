class ResponsePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user.role
      when 'buyer'
        user.incoming_responses
      when 'seller'
        user.outgoing_responses
      when 'admin'
        scope.all
      end
    end
  end

  def show?
    @user == @record.requester || user_is_respondent_of_record?
  end

  def create?
    user_is_respondent_of_record?
  end
  #
  # def destroy?
  #   user_is_respondent_of_record?
  # end

  # def user_is_requester_of_record?
  #   @user == @record.requester
  # end

  def user_is_respondent_of_record?
    @user == @record.respondent
  end
end
