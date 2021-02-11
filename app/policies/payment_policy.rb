class PaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user_is_payer_of_record? #|| @user == @record.request.service.owner
  end

  def pay?
    user_is_payer_of_record? && !@record.rejected?
  end

  def user_is_payer_of_record?
    @user == @record.payer
  end
end
