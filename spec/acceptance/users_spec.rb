# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Users' do
  let!(:user) { create(:user) }
  let(:first_name) { 'Petro' }
  let(:last_name) { 'Tarasov' }
  let(:age) { 21 }
  let(:role) { 'buyer' }
  let(:email) { 'rtyuio@gmail.com' }
  let(:password) { '123456' }
  let(:description) { 'description' }
  let(:balance) { 0 }

  get '/users' do
    let(:user) { create(:user, role: :seller) }

    example_request 'getting a list of users' do
      users_hash = JSON.parse(response_body, symbolize_names: true)
      expect(users_hash[0][:id]).to eq(user.id)
      expect(users_hash[0][:first_name]).to eq(user.first_name)
      expect(users_hash[0][:last_name]).to eq(user.last_name)
      expect(users_hash[0][:age]).to eq(user.age)
      expect(users_hash[0][:description]).to eq(user.description)
      expect(status).to eq(200)
    end
  end

  get '/users/:user_id' do
    let(:user) { create(:user, role: :seller) }
    let(:user_id) { user.id }

    example_request 'getting one user' do
      expect(status).to eq(200)
      user_hash = JSON.parse(response_body, symbolize_names: true)
      expect(user_hash[:id]).to eq(user.id)
      expect(user_hash[:first_name]).to eq(user.first_name)
      expect(user_hash[:last_name]).to eq(user.last_name)
      expect(user_hash[:age]).to eq(user.age)
      expect(user_hash[:description]).to eq(user.description)
    end
  end

  post '/sign_up' do
    with_options scope: :user do
      parameter :first_name, 'First name of user'
      parameter :last_name, 'Last name of user'
      parameter :age, 'Age of user'
      parameter :email, 'Email of user'
      parameter :password, 'Password of user'
      parameter :description, 'Description of user'
      parameter :role, 'Role of user'
    end

    example 'creating a new user' do
      expect { do_request }.to change { User.count }.by(1)
      expect(status).to eq(200)
      user = User.last
      expect(user.first_name).to eq(first_name)
      expect(user.last_name).to eq(last_name)
      expect(user.age).to eq(age)
      expect(user.email).to eq(email)
      expect(user.description).to eq(description)
      expect(user.role).to eq(role)
    end
  end

  patch '/update_me' do
    header 'Authorization', :auth_token
    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload: { sub: user.id }).token}"
    end

    let(:user_id) { user.id }

    with_options scope: :user do
      parameter :first_name, 'First name of user'
      parameter :last_name, 'Last name of user'
      parameter :age, 'Age of user'
      parameter :email, 'Email of user'
      parameter :password, 'Password of user'
      parameter :description, 'Description of user'
    end

    example_request 'updating the user' do
      expect(status).to eq(200)
      expect(user.reload.first_name).to eq(first_name)
      expect(user.last_name).to eq(last_name)
      expect(user.age).to eq(age)
      expect(user.email).to eq(email)
      expect(user.description).to eq(description)
      expect(user.role).to eq(role)
    end
  end
end
