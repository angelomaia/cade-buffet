require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#uniqueness' do
    it 'cannot have duplicate cpfs' do
      User.create!(name: 'Angelo', cpf: '12345678910', email: 'angelo@email.com', password: 'password')
      user = User.create(name: 'Michelle', cpf: '12345678910', email: 'michelle@email.com', password: 'password')

      expect(user.valid?).not_to eq true
    end
  end
end