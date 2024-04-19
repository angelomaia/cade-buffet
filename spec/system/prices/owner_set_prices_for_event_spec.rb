require 'rails_helper'

describe 'Owner tries to set prices for event' do
  it 'and needs to be authenticated' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    price = Price.create!(base: 2500, extra_person: 200, extra_hour: 500,
                          weekend_base: 3500, weekend_extra_person: 300, weekend_extra_hour: 750,
                          event_type: event)
    
    visit root_path
    visit new_price_path

    expect(current_path).to eq "/owners/sign_in"
  end
end