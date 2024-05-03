require 'rails_helper'

RSpec.describe OrderPrice, type: :model do
  context 'presence' do
    it 'invalid when expiration date is empty' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: '')

      order_price.valid?

      expect(order_price.errors.include? :expiration_date).to be true
    end

    it 'invalid when base price is empty' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: '', 
                        payment: 'pix', expiration_date: 1.week.from_now.to_date)
  
      order_price.valid?
  
      expect(order_price.errors.include? :base).to be true
    end

    it 'invalid when payment is empty' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: '', expiration_date: 1.week.from_now.to_date)
  
      order_price.valid?
  
      expect(order_price.errors.include? :payment).to be true
    end
  end
  context 'numericality' do
    it 'invalid when discount is not a number' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: 1.week.from_now.to_date, discount: 'haha')
  
      order_price.valid?
  
      expect(order_price.errors.include? :discount).to be true
    end

    it 'invalid when discount is not a number' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: 1.week.from_now.to_date, discount: 'haha', fee: 0)
  
      order_price.valid?
  
      expect(order_price.errors.include? :discount).to be true
    end

    it 'invalid when fee is not a number' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: 1.week.from_now.to_date, discount: 0, fee: 'haha')
  
      order_price.valid?
  
      expect(order_price.errors.include? :fee).to be true
    end

    it 'invalid when discount is < 0' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: 1.week.from_now.to_date, discount: -500, fee: 0)
  
      order_price.valid?
  
      expect(order_price.errors.include? :discount).to be true
    end

    it 'invalid when fee is < 0' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: 1.week.from_now.to_date, discount: 0, fee: -500)
  
      order_price.valid?
  
      expect(order_price.errors.include? :fee).to be true
    end

    it 'invalid when discount is higher than the base price' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: 1.week.from_now.to_date, discount: 2500, fee: 0)
  
      order_price.valid?
  
      expect(order_price.errors.include? :discount).to be true
    end

    it 'invalid when discount and fee are > 0' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: 1.week.from_now.to_date, discount: 500, fee: 500)
  
      order_price.valid?
  
      expect(order_price.errors.include? :base).to be true
    end
  end

  context 'date' do
    it 'invalid when expiration date is in the past' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: 1.week.ago.to_date, discount: 500, fee: 500)
  
      order_price.valid?
  
      expect(order_price.errors.include? :expiration_date).to be true
    end

    it 'invalid when expiration date is not a date' do
      owner = Owner.create!(email: 'alegria@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                    address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                    email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                    pix: true, debit: true, credit: false, cash: true, owner: owner)
      user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
      event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                                max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                location: 'anywhere', buffet: buffet)
      Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                  weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      order_price = OrderPrice.create(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'pix', expiration_date: 'banana', discount: 500, fee: 500)
  
      order_price.valid?
  
      expect(order_price.errors.include? :expiration_date).to be true
    end
  end
end
