class PaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user.role
      when 'buyer'
        user.outgoing_payments
      when 'seller'
        user.incoming_payments
      when 'admin'
        scope.all
      end
    end
  end

  def show?
    @user == @record.payer? || @user == @record.request.service.owner
  end
end
