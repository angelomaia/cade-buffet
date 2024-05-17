require 'rails_helper'

describe 'Buffets API' do
  context 'GET /api/v1/buffets' do
    it 'list all buffets ordered by name' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      other_owner = Owner.create!(email: 'other_owner@email.com', password: 'password')
      Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: other_owner)

      get '/api/v1/buffets'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to include 'Alegria'
      expect(json_response[1]['name']).to include 'Felicidade'
      expect(json_response[0].keys).to include("average_rating")
    end

    it 'list all buffets ordered by name, except deactivated ones' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      other_owner = Owner.create!(email: 'other_owner@email.com', password: 'password')
      third_owner = Owner.create!(email: 'third@email.com', password: 'password')
      Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',  
                    pix: true, debit: true, credit: false, cash: true, owner: other_owner)
      Buffet.create!(name: 'Euforia', corporate_name: 'Euforia SA', cnpj: '65123161', 
                    address: 'Rua da Euforia, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'euforia@email.com', phone: '8156456456', zipcode: '50000123',  
                    pix: true, debit: true, credit: false, cash: true, owner: third_owner)
      buffet.deactivated!

      get '/api/v1/buffets'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).not_to include 'Alegria'
      expect(json_response[0]['name']).to include 'Euforia'
      expect(json_response[1]['name']).to include 'Felicidade'
    end

    it 'return empty if there is no buffets' do

      get '/api/v1/buffets'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'list buffets filtered by name search query' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      other_owner = Owner.create!(email: 'other_owner@email.com', password: 'password')
      third_owner = Owner.create!(email: 'third_owner@email.com', password: 'password')
      Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: other_owner)
      Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      Buffet.create!(name: 'Alegrias Mil', corporate_name: 'Alegrias Mil SA', cnpj: '65135141', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegrias_mil@email.com', phone: '8156452456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: third_owner)

      get '/api/v1/buffets', params: {query: 'Alegria'}

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to include 'Alegria'
      expect(json_response[1]['name']).to include 'Alegrias Mil'
    end

    it 'and raise internal error' do
      allow(Buffet).to receive(:all).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/buffets'

      expect(response).to have_http_status(500)
    end
  end

  context 'get /api/v1/buffets/1' do
    it 'success' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)

      get "/api/v1/buffets/#{buffet.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response["name"]).to eq 'Felicidade'
      expect(json_response["city"]).to eq 'Recife'
      expect(json_response["state"]).to eq 'PE'
      expect(json_response["email"]).to eq 'felicidade@email.com'
      expect(json_response.keys).to include("average_rating")
      expect(json_response.keys).not_to include("corporate_name")
      expect(json_response.keys).not_to include("cnpj")
      expect(json_response.keys).not_to include("created_at")
      expect(json_response.keys).not_to include("updated_at")
    end

    it 'fail if buffet not found' do

      get "/api/v1/buffets/999999999"

      expect(response.status).to eq 404
    end
  end
end