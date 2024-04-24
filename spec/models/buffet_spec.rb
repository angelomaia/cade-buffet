require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe 'valid?' do
    context 'presence' do
      it 'false when name is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: '', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when corporate name is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: '', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when cnpj is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when address is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: '', neighborhood: 'Alegre', city: 'Recife', state: 'PE',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when neighborhood is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: '', city: 'Recife', state: 'PE',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when city is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: '', state: 'PE',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when state is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: '',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when email is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE',  
                  email: '', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when phone is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE',  
                  email: 'alegria@email.com', phone: '', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when zipcode is empty' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when pix is nil' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: nil, debit: true, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when debit is nil' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE',  
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: nil, credit: false, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when credit is nil' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: nil, cash: false, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it 'false when cash is nil' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: nil, owner: owner)

        expect(buffet.valid?).to eq false
      end
    end
    
    context 'uniqueness' do
      it 'false when cnpj is not unique' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
        owner_two = Owner.create!(email: 'user@email.com', password: 'password')
        buffet_two = Buffet.create(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '65165161', 
                  address: 'Rua da Alegria, 100', neighborhood: 'Feliz', city: 'Recife', state: 'PE', 
                  email: 'felicidade@email.com', phone: '8158797987', zipcode: '1231246', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner_two)

        expect(buffet_two.valid?).to eq false
      end

      it 'false when email is not unique' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
        owner_two = Owner.create!(email: 'user@email.com', password: 'password')
        buffet_two = Buffet.create(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '9879879', 
                  address: 'Rua da Alegria, 100', neighborhood: 'Feliz', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8158797987', zipcode: '1231246', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner_two)

        expect(buffet_two.valid?).to eq false
      end

      it 'false when email is not unique for insensitive case' do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
        owner_two = Owner.create!(email: 'user@email.com', password: 'password')
        buffet_two = Buffet.create(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '9879879', 
                  address: 'Rua da Alegria, 100', neighborhood: 'Feliz', city: 'Recife', state: 'PE', 
                  email: 'ALEGRIA@email.com', phone: '8158797987', zipcode: '1231246', 
                  pix: true, debit: true, credit: false, cash: false, owner: owner_two)

        expect(buffet_two.valid?).to eq false
      end
    end

    context 'format' do
      it "false when email is not in email format (without '.com')" do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: nil, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it "false when email is not in email format (without '@')" do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria.email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: nil, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it "false when email is not in email format (without @ prefix" do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: '@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: nil, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it "false when cnpj is not numbers-only" do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '6a5165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: '@email.com', phone: '8156456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: nil, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it "false when phone is not numbers-only" do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: '@email.com', phone: '81A56456456', zipcode: '1231213', 
                  pix: true, debit: true, credit: false, cash: nil, owner: owner)

        expect(buffet.valid?).to eq false
      end

      it "false when zipcode is not numbers-only" do
        owner = Owner.create!(email: 'angelo@email.com', password: 'password')
        buffet = Buffet.create(name: 'Angelo', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: '@email.com', phone: '8156456456', zipcode: '1231A213', 
                  pix: true, debit: true, credit: false, cash: nil, owner: owner)

        expect(buffet.valid?).to eq false
      end
    end
  end
end
