require 'rails_helper'

describe 'User tries to create a new order' do
  it 'and needs to be authenticated' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)

    visit root_path
    click_on 'Alegria'

    expect(page).not_to have_link 'Novo Pedido'
  end

  it 'is not authenticated and tries to force the url' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)

    visit new_order_path

    expect(current_path).to eq new_user_session_path
  end

  it 'and the Buffet has no events' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    visit root_path
    click_on 'Alegria'

    expect(page).not_to have_link 'Novo Pedido'
  end

  it 'from Buffet page' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)

    login_as user, scope: :user
    visit root_path
    click_on 'Alegria'
    click_on 'Novo Pedido'

    expect(current_path).to eq new_order_path
    expect(page).to have_content 'Novo Pedido'
    expect(page).to have_field 'Tipo de Evento'
    expect(page).to have_field 'Data'
    expect(page).to have_field 'Quantidade de Convidados'
    expect(page).to have_field 'Detalhes'
    expect(page).to have_content 'Localização do Evento'
    expect(page).to have_content 'Endereço do Buffet'
    expect(page).to have_content 'Outro local'
  end

  it 'and do not see address fields by selecting buffet address', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)

    login_as user, scope: :user
    visit root_path
    click_on 'Alegria'
    click_on 'Novo Pedido'
    select 'Festa de Casamento', from: 'Tipo de Evento'
    find('#location_buffet_address').click

    expect(page).not_to have_field 'Cidade'
    expect(page).not_to have_field 'Estado'
  end

  it 'and sees address fields by selecting other location', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)

    login_as user, scope: :user
    visit root_path
    click_on 'Alegria'
    click_on 'Novo Pedido'
    select 'Festa de Casamento', from: 'Tipo de Evento'
    find('#location_elsewhere').click

    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'
  end

  it 'and is successful', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)

    login_as user, scope: :user
    visit root_path
    click_on 'Alegria'
    click_on 'Novo Pedido'
    select 'Festa de Casamento', from: 'Tipo de Evento'
    fill_in 'Data', with: 1.week.from_now
    fill_in 'Quantidade de Convidados', with: '60'
    fill_in 'Detalhes', with: 'Festa de casamento para 60 pessoas'
    find('#location_buffet_address').click
    click_on 'Criar pedido'

    expect(page).to have_content 'Pedido criado com sucesso'
    expect(current_path).to eq "/orders/#{Order.last.id}"
  end
end