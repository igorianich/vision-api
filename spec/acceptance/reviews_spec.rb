# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Reviews' do
  let!(:review) { create(:review) }
  let(:review_id) { review.id }

  header 'Authorization', :auth_token
  let!(:auth_token) do
    "Bearer #{Knock::AuthToken.new(payload: { sub: review.reviewer.id }).token}"
  end

  get '/reviews' do
    example_request 'getting a list of reviews' do
      expect(status).to eq(200)
      reviews_hash = JSON.parse(response_body, symbolize_names: true)
      expect(reviews_hash[0][:id]).to eq(review.id)
      expect(reviews_hash[0][:text]).to eq(review.text)
      expect(reviews_hash[0][:file]).to eq(review.file)
      expect(reviews_hash[0][:rate]).to eq(review.rate)
    end
  end

  get '/reviews/:review_id' do
    let(:review_id) { review.id }
    example_request 'getting a review' do
      expect(status).to eq(200)
      review_hash = JSON.parse(response_body, symbolize_names: true)
      expect(review_hash[:id]).to eq(review.id)
      expect(review_hash[:rate]).to eq(review.rate)
      expect(review_hash[:text]).to eq(review.text)
      expect(review_hash[:file]).to eq(review.file)
    end
  end

  post '/reviews' do
    header 'Authorization', :auth_token
    let!(:auth_token) do
      "Bearer #{Knock::AuthToken.new(payload:
       { sub: response.request.requester_id }).token}"
    end

    with_options scope: :review do
      parameter :response_id, 'Response of review'
      parameter :text, 'Text of review'
      parameter :file, 'File of review'
      parameter :rate, 'Rate of review'
    end
    let!(:response) { create(:response) }
    let(:response_id) { response.id }
    let(:text) { 'fasfadsfdfadjfddfs' }
    let(:file) { 'jskaduadfdafdasas' }
    let(:rate) { 4 }

    example 'creating a new review' do
      expect { do_request }.to change { Review.count }.by(1)
      expect(status).to eq(200)
      review = Review.last
      expect(review.rate).to eq(rate)
      expect(review.text).to eq(text)
      expect(review.file).to eq(file)
    end
  end

  patch '/reviews/:review_id' do
    let(:review_id) { review.id }

    with_options scope: :review do
      parameter :text, 'Text of review'
      parameter :file, 'File of review'
    end

    let(:text) { 'dasdasdasd' }
    let(:file) { '245543452146' }

    example_request 'updating the review' do
      expect(review.reload.text).to eq(text)
      expect(status).to eq(200)
      expect(review.file).to eq(file)
    end
  end

  delete '/reviews/:review_id' do
    example 'deleting the review' do
      expect { do_request }.to change { Review.count }.by(-1)
      expect(status).to eq(204)
    end
  end
end
