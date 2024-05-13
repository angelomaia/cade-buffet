require 'rails_helper'

describe 'Guest visits a buffet page' do
  it 'and sees Buffet details' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    visit root_path
    click_on 'Alegria'

    expect(page).to have_content 'Buffet: Alegria'
    expect(page).to have_content 'Rua da Felicidade, 100, Alegre, Recife - PE'
    expect(page).to have_content 'alegria@email.com'
    expect(page).to have_content 'Métodos de Pagamento: PIX, Cartão de Débito, Dinheiro'
  end

  it 'and clicks on event type' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                            address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                            email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                            pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    visit root_path
    click_on 'Alegria'
    click_on 'Festa de Casamento'

    expect(page).to have_content 'Festa de Casamento'
    expect(page).to have_content 'Descrição: Festa grande'
    expect(page).to have_content 'Duração (minutos): 240'
    expect(page).to have_content 'Cardápio: Macarrão com salsicha'
    expect(current_path).to eq "/event_types/#{event.id}"
  end

  it ', clicks on event type and goes back to buffet page' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    visit root_path
    click_on 'Alegria'
    click_on 'Festa de Casamento'
    click_on 'Voltar'

    expect(current_path).not_to eq "/event_types/#{event.id}"
    expect(page).to have_content 'Buffet: Alegria'
    expect(page).to have_content 'Rua da Felicidade, 100, Alegre, Recife - PE'
    expect(page).to have_content 'alegria@email.com'
    expect(page).to have_content 'Métodos de Pagamento: PIX, Cartão de Débito, Dinheiro'
    expect(current_path).to eq "/buffets/#{buffet.id}"
  end

  it ', sees event cover photo at buffet page' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    event.cover_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'wedding.jpg')), filename: 'wedding.jpg')

    visit root_path
    click_on 'Alegria'

    expect(page).to have_content 'Buffet: Alegria'
    expect(page).to have_content 'alegria@email.com'
    expect(page).to have_css 'img[src*="wedding.jpg"]'
    expect(current_path).to eq "/buffets/#{buffet.id}"
  end

  it ', sees Novo Pedido link and clicks on it' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 

    visit root_path
    click_on 'Alegria'
    click_on 'Novo Pedido'

    expect(current_path).to eq new_user_session_path
  end
end