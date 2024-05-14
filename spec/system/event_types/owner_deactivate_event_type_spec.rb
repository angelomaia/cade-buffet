require 'rails_helper'

describe 'Owner deactivates Event Type' do
  it 'from Buffet page' do
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
    click_on 'Desativar Tipo de Evento'

    expect(page).to have_content 'Tipo de Evento desativado com sucesso'
    expect(page).to have_content 'Status: Desativado'
    expect(current_path).to eq event_type_path(event.id)
  end

  it 'and event is excluded from search' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    owner_two = Owner.create!(email: 'two@email.com', password: 'password')
    owner_three = Owner.create!(email: 'three@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    buffet_two = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidaade SA', cnpj: '454654654', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Salvador', state: 'BA', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_two)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet_two)
    buffet_three = Buffet.create!(name: 'Euforia', corporate_name: 'Euforia SA', cnpj: '321321321', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'São Paulo', state: 'SP', 
                  email: 'euforia@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_three)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet_three)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'
    click_on 'Desativar Tipo de Evento'
    visit root_path
    click_on 'Sair'
    within('header nav') do
      fill_in 'Buscar Buffet', with: 'Casamento'
      click_on 'Buscar'
    end

    expect(page).to have_content '2 Buffets encontrados'
    expect(page).not_to have_link 'Alegria'
    expect(page).to have_link 'Felicidade'
    expect(page).to have_link 'Euforia'
  end

  it 'and then activate it' do
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
    click_on 'Desativar Tipo de Evento'
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'
    click_on 'Ativar Tipo de Evento'

    expect(page).to have_content 'Tipo de Evento ativado com sucesso'
    expect(page).to have_content 'Status: Ativo'
    expect(current_path).to eq event_type_path(event.id)
  end

  it 'and guest cant see it' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    event.deactivated!
    
    visit root_path
    click_on 'Alegria'

    expect(page).to have_content 'Buffet: Alegria'
    expect(page).not_to have_content 'Status: Ativo'
    expect(page).not_to have_content 'Festa de Casamento'
    expect(page).not_to have_link 'Festa de Casamento'
  end

  it 'and guest cant access it' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    event.deactivated!
    
    visit root_path
    visit event_type_path(event.id)

    expect(page).to have_content 'Esse Tipo de Evento está desativado.'
    expect(current_path).not_to eq event_type_path(event.id)
    expect(current_path).to eq root_path
  end
end