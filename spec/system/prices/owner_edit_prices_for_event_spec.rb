require 'rails_helper'

describe 'Owner tries to edit prices for event' do
  it 'and is successful' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    price = Price.create!(base: 1000, extra_person: 100, extra_hour: 300, weekend_base: 2000,
                          weekend_extra_person: 200, weekend_extra_hour: 500, event_type: event)
    
    login_as owner, scope: :owner
    visit "/buffets/#{buffet.id}"
    click_on 'Festa de Casamento'
    click_on 'Editar Tipo de Evento e Preços'
    fill_in 'Preço Base', with: '2000'
    fill_in 'Valor extra por pessoa', with: '100'
    fill_in 'Valor extra por hora', with: '1000'
    fill_in 'Preço Final de Semana (FDS)', with: '3000' 
    fill_in 'Valor extra por pessoa (FDS)', with: '150'
    fill_in 'Valor extra por hora (FDS)', with: '1500'
    click_on 'Registrar'

    expect(page).to have_content 'Festa de Casamento'
    expect(page).to have_content 'Descrição: Festa grande'
    expect(page).to have_content 'Duração (minutos): 240'
    expect(page).to have_content 'Cardápio: Macarrão com salsicha'
    expect(page).to have_content 'Preço Base: R$ 2000.0'
    expect(page).to have_content 'Valor extra por pessoa: R$ 100.0'
    expect(page).to have_content 'Valor extra por hora: R$ 1000.0'
    expect(page).to have_content 'Preço Final de Semana (FDS): R$ 3000.0'
    expect(page).to have_content 'Valor extra por pessoa (FDS): R$ 150.0'
    expect(page).to have_content 'Valor extra por hora (FDS): R$ 1500.0'
    expect(current_path).to eq "/event_types/#{event.id}"
    expect(event.price.id).to eq price.id
  end

  it ', enters edit page and goes back' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    price = Price.create!(base: 2000, extra_person: 100, extra_hour: 300, weekend_base: 3000,
                          weekend_extra_person: 150, weekend_extra_hour: 500, event_type: event)
    
    login_as owner, scope: :owner
    visit "/buffets/#{buffet.id}"
    click_on 'Festa de Casamento'
    click_on 'Editar Tipo de Evento e Preços'
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'

    expect(page).to have_content 'Festa de Casamento'
    expect(page).to have_content 'Descrição: Festa grande'
    expect(page).to have_content 'Duração (minutos): 240'
    expect(page).to have_content 'Cardápio: Macarrão com salsicha'
    expect(page).to have_content 'Preço Base: R$ 2000.0'
    expect(page).to have_content 'Valor extra por pessoa: R$ 100.0'
    expect(page).to have_content 'Valor extra por hora: R$ 300.0'
    expect(page).to have_content 'Preço Final de Semana (FDS): R$ 3000.0'
    expect(page).to have_content 'Valor extra por pessoa (FDS): R$ 150.0'
    expect(page).to have_content 'Valor extra por hora (FDS): R$ 500.0'
    expect(current_path).to eq "/event_types/#{event.id}"
    expect(event.price.id).to eq price.id
  end
end