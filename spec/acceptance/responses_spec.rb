# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Responses' do
  let(:response) { create(:response) }
  let(:response_id) { response.id }

  header 'Authorization', :auth_token
  let!(:auth_token) do
    "Bearer #{Knock::AuthToken.new(payload: { sub:
      response.request.service.owner.id }).token}"
  end

  get '/responses' do
    example_request 'getting a list of responses' do
      responses_hash = JSON.parse(response_body, symbolize_names: true)
      expect(status).to eq(200)
      expect(responses_hash[0][:id]).to eq(response.id)
      expect(responses_hash[0][:request_id]).to eq(response.request_id)
      expect(responses_hash[0][:text]).to eq(response.text)
      expect(responses_hash[0][:file]).to eq(response.file)
    end
  end

  get '/responses/:response_id' do
    let(:response_id) { response.id }
    example_request 'getting a response' do
      expect(status).to eq(200)
      response_hash = JSON.parse(response_body, symbolize_names: true)
      expect(response_hash[:id]).to eq(response.id)
      expect(response_hash[:request_id]).to eq(response.request_id)
      expect(response_hash[:text]).to eq(response.text)
      expect(response_hash[:file]).to eq(response.file)
    end
  end

  post '/responses' do
    with_options scope: :response do
      parameter :request_id, 'Request of response'
      parameter :text, 'Text of response'
      parameter :file, 'File of response'
    end
    let(:request) { create(:request) }
    let(:request_id) { request.id }
    let!(:payment) { create(:payment, request: request) }
    let(:text) { 'fasfadsfdfadjfddfs' }
    let(:file) { 'jskaduadfdafdasas' }

    example 'creating a new response' do
      expect { do_request }
        .to change { Response.count }
        .by(1).and change { request.service.owner.reload.balance }
        .by(request.payment.net)
      expect(status).to eq(200)
      response = Response.last
      expect(response.request.completed?).to be_truthy
      expect(payment.reload.paid?).to be_truthy
      expect(response.text).to eq(text)
      expect(response.file).to eq(file)
    end
  end
end
