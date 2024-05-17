require 'rails_helper'

RSpec.describe SpecialOffer, type: :model do
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
        offer = SpecialOffer.create(start: 1.week.from_now.to_date, end: 2.weeks.from_now.to_date, percentage: 10, event_type: event)

        offer.valid?

        expect(offer.valid?).to eq true
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
        offer = SpecialOffer.create(start: 1.week.from_now.to_date, end: 2.weeks.from_now.to_date, percentage: 'dez', event_type: event)

        offer.valid?

        expect(offer.errors.include? :percentage).to be true
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
        offer = SpecialOffer.create(start: 1.week.from_now.to_date, end: 2.weeks.from_now.to_date, percentage: -10, event_type: event)

        offer.valid?

        expect(offer.errors.include? :percentage).to be true
      end

      it 'invalid when percentage is > 100' do
        owner = Owner.create!(email: 'alegria@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  location: 'anywhere', buffet: buffet)
        offer = SpecialOffer.create(start: 1.week.from_now.to_date, end: 2.weeks.from_now.to_date, percentage: 150, event_type: event)

        offer.valid?

        expect(offer.errors.include? :percentage).to be true
      end
    end
  end
end
