require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe '#uniqueness' do
    it 'do not sign up more than one owner per email' do
      Owner.create!(email: 'example@email.com', password: '123456')
      o = Owner.create(email: 'example@email.com', password: '456789')

      expect(o.valid?).not_to eq true
    end
  end
end
