require 'rails_helper'

RSpec.describe Responses::Create do
  subject { described_class.new.call(params) }
  let(:request) { create(:request) }
  let!(:payment) do
    create(
      :payment, request: request, seller: request.service.owner,
                payer: request.requester
    )
  end
  let(:text) { 'ghjghj' }
  let(:file) { 'ghjghj' }
  let(:params) { { request: request, file: file, text: text } }

  it 'creates response' do
    expect { subject }.to change { Response.count }
      .by(1).and change { payment.seller.balance }.by(payment.net)
    expect(subject.success?).to be_truthy
    expect(request.completed?).to be_truthy
    expect(request.payment.paid?).to be_truthy
    expect(request.response).to_not be_nil
    expect(request.response.text).to eq(text)
    expect(request.response.file).to eq(file)
  end
end
