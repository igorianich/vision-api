# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Services' do
  let!(:service) { create(:service) }
  let(:service_id) { service.id }

  header 'Authorization', :auth_token
  let!(:auth_token) do
    "Bearer #{Knock::AuthToken.new(payload: { sub: service.owner.id }).token}"
  end

  get '/services' do
    example_request 'getting a list of services' do
      expect(status).to eq(200)
      services_hash = JSON.parse(response_body, symbolize_names: true)
      expect(services_hash[0][:id]).to eq(service.id)
      expect(services_hash[0][:name]).to eq(service.name)
      expect(services_hash[0][:owner_id]).to eq(service.owner.id)
      expect(services_hash[0][:description]).to eq(service.description)
      expect(services_hash[0][:price]).to eq(service.price)
    end
  end

  get '/services/:service_id' do
    let(:service_id) { service.id }
    example_request 'getting a service' do
      expect(status).to eq(200)
      service_hash = JSON.parse(response_body, symbolize_names: true)
      expect(service_hash[:id]).to eq(service.id)
      expect(service_hash[:name]).to eq(service.name)
      expect(service_hash[:owner_id]).to eq(service.owner.id)
      expect(service_hash[:description]).to eq(service.description)
      expect(service_hash[:price]).to eq(service.price)
    end
  end

  post '/services' do
    with_options scope: :service do
      parameter :name, 'Name of service'
      parameter :description, 'Description of service'
      parameter :price, 'Price of service'
    end

    let(:name) { 'Fakfadse' }
    let(:description) { 'fasfadsfdfadjfddfs' }
    let(:price) { 20 }

    example 'creating a new service' do
      expect { do_request }.to change { Service.count }.by(1)
      expect(status).to eq(200)
      service = Service.last
      expect(service.name).to eq(name)
      expect(service.description).to eq(description)
      expect(service.price).to eq(price)
    end
  end

  patch '/services/:service_id' do
    let(:service_id) { service.id }

    with_options scope: :service do
      parameter :name, 'Name of service'
      parameter :description, 'Description of service'
      parameter :price, 'Price of service'
    end

    let(:name) { 'dsafdfa' }
    let(:description) { 'cvzdfsaf' }
    let(:price) { 220 }

    example_request 'updating the service' do
      expect(status).to eq(200)
      expect(service.reload.name).to eq(name)
      expect(service.description).to eq(description)
      expect(service.price).to eq(price)
    end
  end

  delete '/services/:service_id' do
    example 'deleting the service' do
      expect { do_request }.to change { Service.count }.by(-1)
      expect(status).to eq(204)
    end
  end
end
