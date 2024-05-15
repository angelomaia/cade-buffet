require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'valid?' do
    context 'presence' do
      it 'valid when all fields are filled in' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        order = Order.create(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, guest_quantity: '50',
                            details: 'Festa de casamento grande', location: 'buffet_address')

        order.valid?

        expect(order.valid?).to be true
      end

      it 'invalid when date is empty' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        order = Order.create(user: user, buffet: buffet, event_type: event, date: '', guest_quantity: '50',
                            details: 'Festa de casamento grande', location: 'buffet_address')

        order.valid?

        expect(order.errors.include? :date).to be true
      end

      it 'invalid when guest quantity is empty' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        order = Order.create(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, guest_quantity: '',
                            details: 'Festa de casamento grande', location: 'buffet_address')

        order.valid?

        expect(order.errors.include? :guest_quantity).to be true
      end
    end

    context 'numericality' do
      it 'invalid when guest quantity is not number' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        order = Order.create(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, guest_quantity: 'abc',
                            details: 'Festa de casamento grande', location: 'buffet_address')

        order.valid?

        expect(order.errors.include? :guest_quantity).to be true
      end

      it 'invalid when guest quantity is negative' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        order = Order.create(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, guest_quantity: -5,
                            details: 'Festa de casamento grande', location: 'buffet_address')

        order.valid?

        expect(order.errors.include? :guest_quantity).to be true
      end

      it 'invalid when guest quantity is higher than max_people' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        order = Order.create(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, guest_quantity: '200',
                            details: 'Festa de casamento grande', location: 'buffet_address')

        order.valid?

        expect(order.errors.include? :guest_quantity).to be true
      end
    end

    context 'date' do
      it 'invalid when date is in the past' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        order = Order.create(user: user, buffet: buffet, event_type: event, date: 1.week.ago.to_date, guest_quantity: '50',
                            details: 'Festa de casamento grande', location: 'buffet_address')

        order.valid?

        expect(order.errors.include? :date).to be true
      end
      it 'invalid when date is not a date' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        order = Order.create(user: user, buffet: buffet, event_type: event, date: 'banana', guest_quantity: '50',
                            details: 'Festa de casamento grande', location: 'buffet_address')

        order.valid?

        expect(order.errors.include? :date).to be true
      end
    end
  end
end