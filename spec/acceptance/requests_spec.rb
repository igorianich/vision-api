# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Requests' do
  let!(:request) { create(:request) }
  let(:request_id) { request.id }

  header 'Authorization', :auth_token
  let!(:auth_token) do
    "Bearer #{Knock::AuthToken.new(payload: { sub: request.requester_id }).token}"
  end

  get '/requests' do
    example_request 'getting a list of requests' do
      expect(status).to eq(200)
      requests_hash = JSON.parse(response_body, symbolize_names: true)
      expect(requests_hash[0][:id]).to eq(request.id)
      expect(requests_hash[0][:requester_id]).to eq(request.requester_id)
      expect(requests_hash[0][:service_id]).to eq(request.service_id)
      expect(requests_hash[0][:text]).to eq(request.text)
      expect(requests_hash[0][:file]).to eq(request.file)
    end
  end

  get '/requests/:request_id' do
    let(:request_id) { request.id }
    example_request 'getting a request' do
      expect(status).to eq(200)
      request_hash = JSON.parse(response_body, symbolize_names: true)
      expect(request_hash[:id]).to eq(request.id)
      expect(request_hash[:requester_id]).to eq(request.requester_id)
      expect(request_hash[:service_id]).to eq(request.service_id)
      expect(request_hash[:text]).to eq(request.text)
      expect(request_hash[:file]).to eq(request.file)
    end
  end

  post '/requests' do
    with_options scope: :request do
      parameter :service_id, 'Service of request'
      parameter :text, 'Text of request'
      parameter :file, 'File of request'
    end

    let(:service_id) { request.service_id }
    let(:text) { 'fasfadsfdfadjfddfs' }
    let(:file) { 'jskaduadfdafdasas' }

    example 'creating a new request' do
      expect { do_request }
        .to change { Request.count }.by(1).and change { Payment.count }
        .by(1)
        .and change { request.requester.reload.balance }
        .by(-request.service.price)
      expect(status).to eq(200)
      request = Request.last
      expect(request.payment.reserved?).to be_truthy
      expect(request.status).to eq('pending_answer')
      expect(request.service_id).to eq(service_id)
      expect(request.text).to eq(text)
      expect(request.file).to eq(file)
    end
  end

  patch '/requests/:request_id/decline' do
    header 'Authorization', :auth_token
    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload:
      { sub: request.service.owner_id }).token}"
    end

    let!(:payment) { create(:payment, request: request) }

    example 'declining the request' do
      expect { do_request }
        .to change { payment.payer.reload.balance }.by(request.service.price)
      expect(status).to eq(200)
      expect(request.reload.rejected?).to be_truthy
      expect(request.payment.rejected?).to be_truthy
    end
  end

  patch '/requests/:request_id' do
    let(:request_id) { request.id }

    with_options scope: :request do
      parameter :text, 'Text of request'
      parameter :file, 'File of request'
    end

    let(:text) { 'dasdasdasd' }
    let(:file) { '245543452146' }

    example_request 'updating the request' do
      expect(status).to eq(200)
      expect(request.reload.text).to eq(text)
      expect(request.file).to eq(file)
    end
  end

  delete '/requests/:request_id' do
    example 'deleting the request' do
      expect { do_request }.to change { Request.count }.by(-1)
      expect(status).to eq(204)
    end
  end
end
