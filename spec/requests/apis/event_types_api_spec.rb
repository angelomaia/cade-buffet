require 'rails_helper'

describe 'Event Types API' do
  context 'get /api/v1/buffets/1/event_types' do
    it 'success' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      Price.create!(base: 5000, extra_person: 200, extra_hour: 1500, event_type: event)
      EventType.create!(name: 'Festa Infantil', duration: '240', min_people: '10',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)                 

      get "/api/v1/buffets/#{buffet.id}/event_types"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to include 'Festa de Casamento'
      expect(json_response[0].keys).to include 'price'
      expect(json_response[1]['name']).to include 'Festa Infantil'
    end

    it 'event deactivated' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      Price.create!(base: 5000, extra_person: 200, extra_hour: 1500, event_type: event)
      EventType.create!(name: 'Festa Infantil', duration: '240', min_people: '10',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
        event_not_to_be_shown = EventType.create!(name: 'Festa da Bagunça', duration: '240', min_people: '10',
                          max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                          buffet: buffet)
        event_not_to_be_shown.deactivated! 

      get "/api/v1/buffets/#{buffet.id}/event_types"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to include 'Festa de Casamento'
      expect(json_response[0].keys).to include 'price'
      expect(json_response[1]['name']).to include 'Festa Infantil'
      expect(json_response).not_to include 'Festa da Bagunça'
    end

    it 'and raise internal error' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      EventType.create!(name: 'Festa Infantil', duration: '240', min_people: '10',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      allow(Buffet).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      get "/api/v1/buffets/#{buffet.id}/event_types"

      expect(response).to have_http_status(500)
    end
  end

  context 'get /api/v1/availability_check' do
    it 'success, returns price' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

      get '/api/v1/availability_check', params: {event_type_id: event.id, date: 1.week.from_now.to_date, guests: 50}

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['price']).to eq 3000
    end

    it 'success, returns base price when guest quantity < min_people ' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

      get '/api/v1/availability_check', params: {event_type_id: event.id, date: 1.week.from_now.to_date, guests: 5}

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['price']).to eq 2000
    end

    it 'success, returns weekend price' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 

      get '/api/v1/availability_check', params: {event_type_id: event.id, date: Date.today.next_occurring(:saturday).to_date, guests: 50}

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['price']).to eq 4500
    end

    it 'fail, too many guests' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

      get '/api/v1/availability_check', params: {event_type_id: event.id, date: 1.week.from_now.to_date, guests: 500}

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['warnings']).to include 'Quantidade de convidados acima do limite.'
    end

    it 'fail, date is in the past' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

      get '/api/v1/availability_check', params: {event_type_id: event.id, date: 1.week.ago.to_date, guests: 50}

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['warnings']).to include 'A data do evento deve ser no futuro.'
    end

    it 'fail, order approved for the date' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.day.from_now.to_date, discount: 0, fee: 0)
      order.approved!

      get '/api/v1/availability_check', params: {event_type_id: event.id, date: 1.week.from_now.to_date, guests: 50}

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['warnings']).to include 'O Buffet já possui um evento marcado para esta data.'
    end

    it 'fail, order confirmed for the date' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.day.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!

      get '/api/v1/availability_check', params: {event_type_id: event.id, date: 1.week.from_now.to_date, guests: 50}

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['warnings']).to include 'O Buffet já possui um evento marcado para esta data.'
    end

    it 'and raise internal error' do
      owner = Owner.create!(email: 'angelo@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                        max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                        buffet: buffet)
      allow(EventType).to receive(:find).and_raise(ActiveRecord::QueryCanceled)

      get '/api/v1/availability_check', params: {event_type_id: event.id, date: 1.week.from_now.to_date, guests: 50}

      expect(response).to have_http_status(500)
    end
  end
end