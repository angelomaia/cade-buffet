require 'rails_helper'

describe 'Owner tries to set a cancel fine for event' do
  it 'and sees the button' do
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

    expect(page).to have_link 'Definir Multa por Cancelamento'
  end

  it 'and sees the form' do
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
    click_on 'Definir Multa por Cancelamento'

    expect(page).to have_field 'Dias antes da Data do Evento'
    expect(page).to have_field 'Porcentagem da Multa'
  end

  it 'and succeeds' do
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
    click_on 'Definir Multa por Cancelamento'
    fill_in 'Dias antes da Data do Evento', with: 30
    fill_in 'Porcentagem da Multa', with: 50
    click_on 'Registrar'

    expect(current_path).to eq event_type_path(EventType.last)
    expect(page).to have_content 'Multa por Cancelamento registrada com sucesso.'
    expect(page).to have_content 'Multas por Cancelamento:'
    expect(page).to have_content 'Dias antes da Data do Evento: 30' 
    expect(page).to have_content 'Porcentagem da Multa: 50%'
  end

  it ', succeeds and creates a second cancel fine rule' do
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
    click_on 'Definir Multa por Cancelamento'
    fill_in 'Dias antes da Data do Evento', with: 30
    fill_in 'Porcentagem da Multa', with: 50
    click_on 'Registrar'
    click_on 'Definir Multa por Cancelamento'
    fill_in 'Dias antes da Data do Evento', with: 7
    fill_in 'Porcentagem da Multa', with: 100
    click_on 'Registrar'

    expect(current_path).to eq event_type_path(EventType.last)
    expect(page).to have_content 'Multa por Cancelamento registrada com sucesso.'
    expect(page).to have_content 'Multas por Cancelamento:'
    expect(page).to have_content 'Dias antes da Data do Evento: 30' 
    expect(page).to have_content 'Porcentagem da Multa: 50%'
    expect(page).to have_content 'Dias antes da Data do Evento: 7' 
    expect(page).to have_content 'Porcentagem da Multa: 100%'
  end
end