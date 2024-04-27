require 'rails_helper'

describe 'Owner tries to set prices for event' do
  it 'and needs to be authenticated' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    price = Price.create!(base: 2500, extra_person: 200, extra_hour: 500,
                          weekend_base: 3500, weekend_extra_person: 300, weekend_extra_hour: 750,
                          event_type: event)
    
    visit root_path
    visit event_type_prices_event_type_path(event.id)

    expect(current_path).to eq "/owners/sign_in"
  end

  it 'and sees the form' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'
    click_on 'Editar Tipo de Evento'
    click_on 'Definir Preços'

    expect(page).to have_content 'Editar Tipo de Evento e Preços'
    expect(current_path).to eq event_type_prices_event_type_path(event.id)
    expect(page).to have_field 'Preço Base'
    expect(page).to have_field 'Valor extra por pessoa'
    expect(page).to have_field 'Valor extra por hora'
    expect(page).to have_field 'Preço Final de Semana (FDS)'
    expect(page).to have_field 'Valor extra por pessoa (FDS)'
    expect(page).to have_field 'Valor extra por hora (FDS)'
  end

  it 'and is successful' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'
    click_on 'Editar Tipo de Evento'
    click_on 'Definir Preços'
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
  end

  it 'and leaves all fields blank' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'
    click_on 'Editar Tipo de Evento'
    click_on 'Definir Preços'
    fill_in 'Preço Base', with: ''
    fill_in 'Valor extra por pessoa', with: ''
    fill_in 'Valor extra por hora', with: ''
    fill_in 'Preço Final de Semana (FDS)', with: '' 
    fill_in 'Valor extra por pessoa (FDS)', with: ''
    fill_in 'Valor extra por hora (FDS)', with: ''
    click_on 'Registrar'

    expect(page).to have_content 'Não foi possível atualizar o Tipo de Evento'
    expect(page).to have_content 'Preço Base não pode ficar em branco'
    expect(page).to have_content 'Valor extra por pessoa não pode ficar em branco'
    expect(page).to have_content 'Valor extra por hora não pode ficar em branco'
  end
end