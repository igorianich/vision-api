# frozen_string_literal: true

require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Skills' do
  let!(:skill) { create(:skill) }

  header 'Authorization', :auth_token
  let!(:auth_token) do
    "Bearer #{Knock::AuthToken.new(payload: { sub: skill.owner_id }).token}"
  end

  get '/skills' do
    example_request 'getting a list of skills' do
      expect(status).to eq(200)
      skills_hash = JSON.parse(response_body, symbolize_names: true)
      expect(skills_hash[0][:id]).to eq(skill.id)
      expect(skills_hash[0][:name]).to eq(skill.name)
      expect(skills_hash[0][:owner_id]).to eq(skill.owner_id)
      expect(skills_hash[0][:description]).to eq(skill.description)
    end
  end

  get '/skills/:skill_id' do
    let(:skill_id) { skill.id }
    example_request 'getting a skill' do
      expect(status).to eq(200)
      skill_hash = JSON.parse(response_body, symbolize_names: true)
      expect(skill_hash[:id]).to eq(skill.id)
      expect(skill_hash[:name]).to eq(skill.name)
      expect(skill_hash[:owner_id]).to eq(skill.owner_id)
      expect(skill_hash[:description]).to eq(skill.description)
    end
  end

  post '/skills' do
    with_options scope: :skill do
      parameter :name, 'Name of skill'
      parameter :description, 'Description of skill'
    end

    let(:name) { 'Fakfadse' }
    let(:description) { 'fasfadsfdfadjfddfs' }

    example 'creating a new skill' do
      expect { do_request }.to change { Skill.count }.by(1)
      expect(status).to eq(200)
      skill = Skill.last
      expect(skill.name).to eq(name)
      expect(skill.description).to eq(description)
    end
  end

  patch '/skills/:skill_id' do
    let(:skill_id) { skill.id }

    with_options scope: :skill do
      parameter :name, 'Name of skill'
      parameter :description, 'Description of skill'
    end

    let(:name) { 'dsafdfa' }
    let(:description) { 'cvzdfsaf' }

    example_request 'updating the skill' do
      expect(status).to eq(200)
      expect(skill.reload.name).to eq(name)
      expect(skill.description).to eq(description)
    end
  end

  delete '/skills/:skill_id' do
    let(:skill_id) { skill.id }

    example 'deleting the skill' do
      expect { do_request }.to change { Skill.count }.by(-1)
      expect(status).to eq(204)
    end
  end
end
