require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe 'valid?' do
    context 'presence' do
      it 'false when name is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: '', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)

        expect(buffet.valid?).to eq false
      end
    end
    
    context 'uniqueness' do
      it 'false when cnpj is not unique' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
        owner_two = Owner.create!(email: 'user@email.com', password: 'password')
        buffet_two = Buffet.create(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '65165161', 
                  address: 'Rua da Alegria, 100', neighborhood: 'Feliz', city: 'Recife', state: 'PE', 
                  email: 'felicidade@email.com', phone: '8158797987', zipcode: '1231246', owner: owner_two)

        expect(buffet_two.valid?).to eq false
      end

      it 'false when email is not unique' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
        owner_two = Owner.create!(email: 'user@email.com', password: 'password')
        buffet_two = Buffet.create(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '9879879', 
                  address: 'Rua da Alegria, 100', neighborhood: 'Feliz', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8158797987', zipcode: '1231246', owner: owner_two)

        expect(buffet_two.valid?).to eq false
      end
    end
  end
end
