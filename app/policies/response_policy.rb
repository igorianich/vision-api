class ResponsePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @user == @record.requester && @record.request.payment.paid? ||
      user_is_respondent_of_record?
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
