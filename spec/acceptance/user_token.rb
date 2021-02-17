# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'User_token' do
  let!(:user) { create(:user, email: email, password: password) }

  let(:email) { 'rtyuio@gmail.com' }
  let(:password) { '123456' }

  post '/sign_in' do
    with_options scope: :auth do
      parameter :email, 'Email of user'
      parameter :password, 'Password of user'
    end

    example_request 'authorization of user' do
      expect(status).to eq(200)
      user_hash = JSON.parse(response_body, symbolize_names: true)
      expect(user_hash[:payload][:id]).to eq(user.id)
      expect(user_hash[:payload][:first_name]).to eq(user.first_name)
      expect(user_hash[:payload][:last_name]).to eq(user.last_name)
      expect(user_hash[:payload][:age]).to eq(user.age)
      expect(user_hash[:payload][:email]).to eq(user.email)
      expect(user_hash[:payload][:description]).to eq(user.description)
      expect(user_hash[:payload][:role]).to eq(user.role)
    end
  end
end
