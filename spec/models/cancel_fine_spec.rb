require 'rails_helper'

RSpec.describe CancelFine, type: :model do
  describe 'valid?' do
    context 'numericality' do
      it 'valid when days and percentages are numbers' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
        fine = CancelFine.create(days: 30, percentage: 50, event_type: event)

        fine.valid?

        expect(fine.valid?).to eq true
      end

      it 'invalid when days are not number' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
        fine = CancelFine.create(days: 'trinta', percentage: 50, event_type: event)

        fine.valid?

        expect(fine.errors.include? :days).to be true
      end

      it 'invalid when percentage is not number' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
        fine = CancelFine.create(days: 30, percentage: 'cinquenta por cento', event_type: event)

        fine.valid?

        expect(fine.errors.include? :percentage).to be true
      end

      it 'invalid when days are < 0' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
        fine = CancelFine.create(days: -1, percentage: 50, event_type: event)

        fine.valid?

        expect(fine.errors.include? :days).to be true
      end

      it 'invalid when percentage is < 0' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                    weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
        allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
        fine = CancelFine.create(days: 30, percentage: -10, event_type: event)

        fine.valid?

        expect(fine.errors.include? :percentage).to be true
      end
    end
  end
end