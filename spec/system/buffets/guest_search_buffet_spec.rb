require 'rails_helper'

describe 'Guest searches for a buffet' do
  it 'from the menu' do

    visit root_path

    within('header nav') do
      expect(page).to have_field 'Buscar Buffet'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'and finds a buffet by name' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    owner_two = Owner.create!(email: 'two@email.com', password: 'password')
    owner_three = Owner.create!(email: 'three@email.com', password: 'password')
    Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidaade SA', cnpj: '454654654', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Salvador', state: 'BA', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_two)
    Buffet.create!(name: 'Euforia', corporate_name: 'Euforia SA', cnpj: '321321321', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'São Paulo', state: 'SP', 
                  email: 'euforia@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_three)

    visit root_path
    within('header nav') do
      fill_in 'Buscar Buffet', with: 'Alegria'
      click_on 'Buscar'
    end

    expect(page).to have_content '1 Buffet encontrado'
    expect(page).to have_link 'Alegria'
    expect(page).not_to have_link 'Felicidade'
    expect(page).not_to have_link 'Euforia'
  end

  it 'and finds two buffets by name and city' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    owner_two = Owner.create!(email: 'two@email.com', password: 'password')
    owner_three = Owner.create!(email: 'three@email.com', password: 'password')
    Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidaade SA', cnpj: '454654654', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Alegria', state: 'BA', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_two)
    Buffet.create!(name: 'Euforia', corporate_name: 'Euforia SA', cnpj: '321321321', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'São Paulo', state: 'SP', 
                  email: 'euforia@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_three)

    visit root_path
    within('header nav') do
      fill_in 'Buscar Buffet', with: 'Alegria'
      click_on 'Buscar'
    end

    expect(page).to have_content '2 Buffets encontrados'
    expect(page).to have_link 'Alegria'
    expect(page).to have_link 'Felicidade'
    expect(page).not_to have_link 'Euforia'
  end

  it 'and finds two buffets by event types' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    owner_two = Owner.create!(email: 'two@email.com', password: 'password')
    owner_three = Owner.create!(email: 'three@email.com', password: 'password')
    buffet_one = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    buffet_two = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidaade SA', cnpj: '454654654', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Salvador', state: 'BA', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_two)
    buffet_three = Buffet.create!(name: 'Euforia', corporate_name: 'Euforia SA', cnpj: '321321321', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'São Paulo', state: 'SP', 
                  email: 'euforia@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_three)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet_one)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet_two)
    EventType.create!(name: 'Festa de Criança', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet_three)
    
    visit root_path
    within('header nav') do
      fill_in 'Buscar Buffet', with: 'Casamento'
      click_on 'Buscar'
    end

    expect(page).to have_content '2 Buffets encontrados'
    expect(page).to have_link 'Alegria'
    expect(page).to have_link 'Felicidade'
    expect(page).not_to have_link 'Euforia'
  end

  it 'and finds three buffets in alphabetical order' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    owner_two = Owner.create!(email: 'two@email.com', password: 'password')
    owner_three = Owner.create!(email: 'three@email.com', password: 'password')
    buffet_one = Buffet.create!(name: 'Felicidade', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    buffet_two = Buffet.create!(name: 'Euforia', corporate_name: 'Felicidaade SA', cnpj: '454654654', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Salvador', state: 'BA', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_two)
    buffet_three = Buffet.create!(name: 'Alegria', corporate_name: 'Euforia SA', cnpj: '321321321', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'São Paulo', state: 'SP', 
                  email: 'euforia@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_three)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet_one)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet_two)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet_three)
    
    visit root_path
    within('header nav') do
      fill_in 'Buscar Buffet', with: 'Casamento'
      click_on 'Buscar'
    end

    expect(page).to have_content '3 Buffets encontrados'
    within('#buffets > div:nth-child(1)') do
      expect(page).to have_link 'Alegria'
    end
    within('#buffets > div:nth-child(2)') do
      expect(page).to have_link 'Euforia'
    end
    within('#buffets > div:nth-child(3)') do
      expect(page).to have_link 'Felicidade'
    end
  end
end