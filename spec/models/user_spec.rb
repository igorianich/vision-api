require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validate' do
    subject { user.validate }

    let(:first_name) { 'Petro' }
    let(:last_name) { 'Tarasov' }
    let(:age) { 21 }
    let(:role) { :buyer }
    let(:email) { 'rtyuio@gmail.com' }
    let(:password) { '123456' }
    let(:description) { 'description' }
    let(:balance) { 500 }
    let(:user) do
      build(
        :user,
        first_name: first_name, last_name: last_name, description: description,
        age: age, role: role, email: email, password: password, balance: balance
      )
    end

    shared_examples :invalid_user do |error_key, error_text = nil|
      it 'is not valid' do
        expect(subject).to be false
        expect(user.errors.keys).to include(error_key)
        expect(user.errors[error_key][0]).to eq(error_text) if error_text
      end
    end

    context 'when user is valid' do
      it 'is valid' do
        expect(subject).to be true
      end
    end

    context 'when user does not have first name' do
      let(:first_name) { nil }

      it_behaves_like :invalid_user, :first_name
    end

    context 'when users first name is too short ' do
      let(:first_name) { 'd' }

      it_behaves_like :invalid_user,
                      :first_name, 'is too short (minimum is 2 characters)'
    end

    context 'when user does not have first name' do
      let(:last_name) { nil }

      it_behaves_like :invalid_user, :last_name
    end

    context 'when users last name is too short' do
      let(:last_name) { 'd' }

      it_behaves_like :invalid_user,
                      :last_name, 'is too short (minimum is 2 characters)'
    end

    context 'when user does not have age' do
      let(:age) { nil }

      it_behaves_like :invalid_user, :age
    end

    context 'when users age less than 18' do
      let(:age) { 17 }

      it_behaves_like :invalid_user, :age, 'must be greater than 17'
    end

    context 'when user does not have description' do
      let(:description) { nil }

      it_behaves_like :invalid_user, :description
    end

    context 'when users description less than 10' do
      let(:description) { 'd' }

      it_behaves_like :invalid_user,
                      :description, 'is too short (minimum is 10 characters)'
    end

    context 'when user does not have email' do
      let(:email) { nil }

      it_behaves_like :invalid_user, :email
    end

    context 'when user has ivalid email' do
      let(:email) { 'd' }

      it_behaves_like :invalid_user, :email, 'is invalid'
    end

    context 'when user does not have password' do
      let(:password) { nil }

      it_behaves_like :invalid_user, :password
    end

    context 'when user has ivalid email' do
      let(:password) { 'd' }

      it_behaves_like :invalid_user,
                      :password, 'is too short (minimum is 6 characters)'
    end
  end

  describe '#add_balance' do
    subject { user.add_balance(arg) }

    let(:user) { create(:user, balance: 0) }
    let(:arg) { 50 }

    it 'add arg to balance' do
      expect(subject).to be true
      expect(user.balance).to eq(arg)
    end
  end

  describe '#subtract_balance' do
    subject { user.subtract_balance(arg) }

    let(:user) { create(:user, balance: 50) }
    let(:arg) { 50 }

    it 'add arg to balance' do
      expect(subject).to be true
      expect(user.balance).to eq(0)
    end
  end
end
