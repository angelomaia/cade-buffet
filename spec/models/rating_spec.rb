require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'valid?' do
    context 'presence' do
      it 'valid when all mandatory fields are filled in' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 5, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be true
      end

      it 'invalid when there is no grade' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: '', text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be false
      end

      it 'invalid when there is no grade' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 5, text: '')

        rating.valid?      

        expect(rating.valid?).to be false
      end
    end

    context 'numericality' do
      it 'invalid when grade is not a number' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 'Uhul', text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be false
      end

      it 'invalid when grade is less than 0' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: -1, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be false
      end

      it 'invalid when grade is more than 5' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 6, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be false
      end

      it 'valid when grade is 0' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 0, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be true
      end

      it 'valid when grade is 1' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 1, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be true
      end

      it 'valid when grade is 2' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 2, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be true
      end

      it 'valid when grade is 3' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 3, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be true
      end

      it 'valid when grade is 4' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 4, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be true
      end

      it 'valid when grade is 5' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 5, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be true
      end
    end

    context 'order date' do
      it 'invalid when order date is in the future' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 5, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be false
        expect(rating.errors.full_messages).to include 'Avaliação só pode ser feita para eventos que já aconteceram.'
      end
    end

    context 'duplicity' do
      it 'invalid when there is already a rating for the order' do
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
        order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                      guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                      location: 'buffet_address', status: 'pending')
        Chat.create!(order: order)
        OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                          payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
        order.approved!
        order.confirmed!
        order.date = 1.month.ago.to_date

        Rating.create!(user: user, order: order, buffet: buffet, event_type: event, grade: 5, text: 'Ótima festa')
        order.rated!

        rating = Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 5, text: 'Ótima festa')

        rating.valid?      

        expect(rating.valid?).to be false
      end
    end
  end
end
