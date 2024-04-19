require 'rails_helper'

RSpec.describe Price, type: :model do
  describe 'valid?' do
    context 'numericality' do
      it 'all ok' do
        owner = Owner.create!(email: 'testando@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA Inc.', cnpj: '21312412', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@teste.com', phone: '8156456456', zipcode: '1231245', owner: owner)
        event = EventType.create!(name: 'Festa', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)
        price = Price.create(base: 1000, extra_person: 100, extra_hour: 200, weekend_base: 2000, 
                            weekend_extra_person: 200, weekend_extra_hour: 300, event_type: event)

        expect(price.valid?).to eq true
      end
      
      it 'base is not numerical' do
        owner = Owner.create!(email: 'testando@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA Inc.', cnpj: '21312412', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@teste.com', phone: '8156456456', zipcode: '1231245', owner: owner)
        event = EventType.create!(name: 'Festa', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)
        price = Price.create(base: 'hahaha', extra_person: 100, extra_hour: 200, weekend_base: 2000, 
                            weekend_extra_person: 200, weekend_extra_hour: 300, event_type: event)

        expect(price.valid?).to eq false
      end

      it 'extra_person is not numerical' do
        owner = Owner.create!(email: 'testando@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA Inc.', cnpj: '21312412', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@teste.com', phone: '8156456456', zipcode: '1231245', owner: owner)
        event = EventType.create!(name: 'Festa', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)
        price = Price.create(base: 100, extra_person: 'haha', extra_hour: 200, weekend_base: 2000, 
                            weekend_extra_person: 200, weekend_extra_hour: 300, event_type: event)

        expect(price.valid?).to eq false
      end
      it 'extra_hour is not numerical' do
        owner = Owner.create!(email: 'testando@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA Inc.', cnpj: '21312412', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@teste.com', phone: '8156456456', zipcode: '1231245', owner: owner)
        event = EventType.create!(name: 'Festa', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)
        price = Price.create(base: 100, extra_person: 100, extra_hour: 'haha', weekend_base: 2000, 
                            weekend_extra_person: 200, weekend_extra_hour: 300, event_type: event)

        expect(price.valid?).to eq false
      end
      it 'weekend_base is not numerical' do
        owner = Owner.create!(email: 'testando@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA Inc.', cnpj: '21312412', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@teste.com', phone: '8156456456', zipcode: '1231245', owner: owner)
        event = EventType.create!(name: 'Festa', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)
        price = Price.create(base: 100, extra_person: 100, extra_hour: 200, weekend_base: 'hahaha', 
                            weekend_extra_person: 200, weekend_extra_hour: 300, event_type: event)

        expect(price.valid?).to eq false
      end
      it 'weekend_extra_person is not numerical' do
        owner = Owner.create!(email: 'testando@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA Inc.', cnpj: '21312412', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@teste.com', phone: '8156456456', zipcode: '1231245', owner: owner)
        event = EventType.create!(name: 'Festa', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)
        price = Price.create(base: 100, extra_person: 100, extra_hour: 200, weekend_base: 2000, 
                            weekend_extra_person: 'haha', weekend_extra_hour: 300, event_type: event)

        expect(price.valid?).to eq false
      end
      it 'weekend_extra_hour is not numerical' do
        owner = Owner.create!(email: 'testando@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA Inc.', cnpj: '21312412', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@teste.com', phone: '8156456456', zipcode: '1231245', owner: owner)
        event = EventType.create!(name: 'Festa', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)
        price = Price.create(base: 100, extra_person: 100, extra_hour: 200, weekend_base: 2000, 
                            weekend_extra_person: 200, weekend_extra_hour: 'hhahaha', event_type: event)

        expect(price.valid?).to eq false
      end
    end
  end
end
