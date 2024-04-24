require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#uniqueness' do
    it 'cannot have duplicate cpfs' do
      User.create!(name: 'Angelo', cpf: '12345678910', email: 'angelo@email.com', password: 'password')
      user = User.create(name: 'Michelle', cpf: '12345678910', email: 'michelle@email.com', password: 'password')

      expect(user.valid?).not_to eq true
    end
  end

  describe '#presence' do
    it 'cannot leave name empty' do
      user = User.create(name: '', cpf: '12345678910', email: 'michelle@email.com', password: 'password')

      expect(user.valid?).not_to eq true
    end

    it 'cannot leave cpf empty' do
      user = User.create(name: 'Michelle', cpf: '', email: 'michelle@email.com', password: 'password')

      expect(user.valid?).not_to eq true
    end

    it 'cannot leave email empty' do
      user = User.create(name: 'Michelle', cpf: '12345678910', email: '', password: 'password')

      expect(user.valid?).not_to eq true
    end

    it 'cannot leave password empty' do
      user = User.create(name: 'Michelle', cpf: '12345678910', email: 'michelle@email.com', password: '')

      expect(user.valid?).not_to eq true
    end
  end

  describe '#format' do
    it 'cannot use non-numbers in cpf' do
      user = User.create(name: '', cpf: '1234Abcdd56910', email: 'michelle@email.com', password: 'password')

      expect(user.valid?).not_to eq true
    end

    it 'cannot use non-standard email format' do
      user = User.create(name: 'Michelle', cpf: '', email: 'michelle.com', password: 'password')

      expect(user.valid?).not_to eq true
    end
  end
end