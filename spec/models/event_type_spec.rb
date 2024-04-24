require 'rails_helper'

RSpec.describe EventType, type: :model do
  describe 'valid?' do
    context 'presence' do
      it 'false when name is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create(name: '', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)

        expect(event.valid?).to eq false
      end

      it 'false when duration is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create(name: 'Festa de Casamento', duration: '', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)

        expect(event.valid?).to eq false
      end

      it 'false when min_people is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create(name: 'Festa de Casamento', duration: '240', min_people: '',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)

        expect(event.valid?).to eq false
      end

      it 'false when max_people is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)

        expect(event.valid?).to eq false
      end

      it 'false when description is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: '', menu: 'Macarrão com salsicha',
                                  buffet: buffet)

        expect(event.valid?).to eq false
      end

      it 'false when menu is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: '',
                                  buffet: buffet)

        expect(event.valid?).to eq false
      end
      
      it 'false when buffet is empty' do
        event = EventType.create(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha')

        expect(event.valid?).to eq false
      end
    end
    context "#format" do
      it 'false when duration is not numbers' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create(name: 'Festa de Casamento', duration: 'Três horas', min_people: '10',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)

        expect(event.valid?).to eq false
      end

      it 'false when min_people is not numbers' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create(name: 'Festa de Casamento', duration: '240', min_people: 'dez',
                                  max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)

        expect(event.valid?).to eq false
      end

      it 'false when max_people is not numbers' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                      address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                      email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                      pix: true, debit: true, credit: false, cash: true, owner: owner)
        event = EventType.create(name: 'Festa de Casamento', duration: '240', min_people: '10',
                                  max_people: 'cem', description: 'Festa grande', menu: 'Macarrão com salsicha',
                                  buffet: buffet)

        expect(event.valid?).to eq false
      end
    end
  end
end
