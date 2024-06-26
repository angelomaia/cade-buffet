require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#uniqueness' do
    it 'cannot have duplicate cpfs' do
      cpf = CPF.generate
      User.create!(name: 'Angelo', cpf: cpf, email: 'angelo@email.com', password: 'password')
      user = User.create(name: 'Michelle', cpf: cpf, email: 'michelle@email.com', password: 'password')

      expect(user.valid?).not_to eq true
    end
  end

  describe '#presence' do
    it 'cannot leave name empty' do
      user = User.create(name: '', cpf: CPF.generate, email: 'michelle@email.com', password: 'password')

      expect(user.valid?).not_to eq true
    end

    it 'cannot leave cpf empty' do
      user = User.create(name: 'Michelle', cpf: '', email: 'michelle@email.com', password: 'password')

      expect(user.valid?).not_to eq true
    end

    it 'cannot leave email empty' do
      user = User.create(name: 'Michelle', cpf: CPF.generate, email: '', password: 'password')

      expect(user.valid?).not_to eq true
    end

    it 'cannot leave password empty' do
      user = User.create(name: 'Michelle', cpf: CPF.generate, email: 'michelle@email.com', password: '')

      expect(user.valid?).not_to eq true
    end
  end

  describe '#format' do
    it 'cannot use non-numbers in cpf' do
      user = User.create(name: '', cpf: CPF.generate, email: 'michelle@email.com', password: 'password')

      expect(user.valid?).not_to eq true
    end

    it 'cannot use non-standard email format' do
      user = User.create(name: 'Michelle', cpf: CPF.generate, email: 'michelle.com', password: 'password')

      expect(user.valid?).not_to eq true
    end
  end

  describe '#length' do
    it 'false when cpf is more than 11 digits' do
      user = User.create(name: 'Michelle', cpf: '123123123123', email: 'michelle.com', password: 'password')

      expect(user.valid?).not_to eq true
    end

    it 'false when cpf is less than 11 digits' do
      user = User.create(name: 'Michelle', cpf: '1231231231', email: 'michelle.com', password: 'password')

      expect(user.valid?).not_to eq true
    end
  end
end