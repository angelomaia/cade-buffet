require 'rails_helper'

describe 'Owner edits event type' do
  it 'and needs to be authenticated' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    visit root_path
    visit "/event_types/#{event.id}/edit"

    expect(current_path).to eq "/owners/sign_in"
  end

  it 'and needs to be the buffet owner' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    owner_two = Owner.create!(email: 'owner@email.com', password: 'password')
    Buffet.create!(name: 'Alegria', corporate_name: 'Alegrias SA', cnpj: '651653161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegrias@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_two)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    visit root_path
    login_as owner_two, scope: :owner
    visit "/event_types/#{event.id}/edit"

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode editar este Tipo de Evento.'
  end

  it 'and gets access to the editing form' do
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

    expect(current_path).to eq "/event_types/#{event.id}/edit"
    expect(page).to have_content 'Editar Tipo de Evento'
    expect(page).to have_field 'Nome do Evento'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Quantidade mínima de Pessoas'
    expect(page).to have_field 'Quantidade máxima de Pessoas'
    expect(page).to have_field 'Duração (minutos)'
    expect(page).to have_field 'Cardápio'
    expect(page).to have_field 'Bebidas alcoólicas'
    expect(page).to have_field 'Decoração'
    expect(page).to have_field 'Estacionamento/valet'
    expect(page).to have_content 'Exclusivamente no Endereço do Buffet'
    expect(page).to have_content 'Em qualquer local solicitado'
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
    fill_in 'Nome do Evento', with: 'Alegrilandia'
    fill_in 'Quantidade mínima de Pessoas', with: '20'
    fill_in 'Duração (minutos)', with: '180'
    fill_in 'Cardápio', with:  'Macarrão com sassissinha'
    click_on 'Registrar'

    expect(page).to have_content 'Tipo de Evento alterado com sucesso.'
    expect(current_path).to eq "/event_types/#{event.id}"
    expect(page).to have_content 'Alegrilandia'
    expect(page).to have_content 'Duração (minutos): 180'
    expect(page).to have_content 'Quantidade mínima de Pessoas: 20'
    expect(page).to have_content 'Quantidade máxima de Pessoas: 100'
    expect(page).to have_content 'Cardápio: Macarrão com sassissinha'
    expect(page).to have_content 'Localização do Evento: Exclusivamente no Endereço do Buffet'
  end

  it 'and leaves blank fields' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'
    click_on 'Editar Tipo de Evento'
    fill_in 'Nome do Evento', with: ''
    fill_in 'Quantidade mínima de Pessoas', with: ''
    fill_in 'Duração (minutos)', with: ''
    fill_in 'Cardápio', with:  ''
    click_on 'Registrar'

    expect(page).to have_content 'Não foi possível atualizar o Tipo de Evento'
    expect(page).to have_content 'Nome do Evento não pode ficar em branco'
    expect(page).to have_content 'Quantidade mínima de Pessoas não pode ficar em branco'
    expect(page).to have_content 'Duração (minutos) não pode ficar em branco'
    expect(page).to have_content 'Cardápio não pode ficar em branco'
  end
end