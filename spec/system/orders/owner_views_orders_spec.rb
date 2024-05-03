require 'rails_helper'

describe 'Owner views orders' do
  it 'from Orders page' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'

    expect(order.valid?).to eq true
    expect(page).to have_content 'Pedidos aguardando aprovação'
    expect(page).to have_content 'Festa de Casamento'
    expect(page).to have_content "#{1.week.from_now.to_date}"
    expect(page).to have_content 'Cliente: Angelo (angelo@email.com)'
    expect(page).to have_link 'moIoiXkBAFMXr4RGhn0J'
  end

  it 'and access order details' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'

    expect(current_path).to eq "/orders/#{order.id}/details"
    expect(page).to have_content 'Pedido de Festa de Casamento'
    expect(page).to have_content 'Código:'
    expect(page).to have_content 'moIoiXkBAFMXr4RGhn0J'
    expect(page).to have_content "Data:"
    expect(page).to have_content "#{1.week.from_now.to_date}"
    expect(page).to have_content "Quantidade de Convidados:"
    expect(page).to have_content "50"
    expect(page).to have_content 'Detalhes:'
    expect(page).to have_content 'Festa de Casamento para 50 pessoas'
    expect(page).to have_content 'Localização do Evento:'
    expect(page).to have_content 'Endereço do Buffet'
    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Aguardando aprovação'
    expect(page).to have_link 'Avaliar Pedido'
  end

  it 'and there are three orders for the same day' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    angelo = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    michelle = User.create!(name: 'Michelle', cpf: CPF.generate, email: 'michelle@email.com', password: 'password')
    ivan = User.create!(name: 'Ivan', cpf: CPF.generate, email: 'ivan@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: angelo, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')
                  allow(SecureRandom).to receive(:alphanumeric).and_return('noIoiXkBCFMXr4RGhn0J')
    Order.create!(user: michelle, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')
                  allow(SecureRandom).to receive(:alphanumeric).and_return('poIoiXkBDFMXr4RGhn0J')
    Order.create!(user: ivan, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'

    expect(current_path).to eq "/orders/#{order.id}/details"
    expect(page).to have_content 'Existem outros pedidos para a mesma data:'
    expect(page).to have_link 'noIoiXkBCFMXr4RGhn0J'
    expect(page).to have_link 'poIoiXkBDFMXr4RGhn0J'
    expect(page).to have_content 'Pedido de Festa de Casamento'
    expect(page).to have_content 'Cliente: Angelo (angelo@email.com)'
    expect(page).not_to have_content 'Buffet Alegria'
    expect(page).to have_content 'Código:'
    expect(page).to have_content 'moIoiXkBAFMXr4RGhn0J'
    expect(page).to have_content "Data:"
    expect(page).to have_content "#{1.week.from_now.to_date}"
    expect(page).to have_content "Quantidade de Convidados:"
    expect(page).to have_content "50"
    expect(page).to have_content 'Detalhes:'
    expect(page).to have_content 'Festa de Casamento para 50 pessoas'
    expect(page).to have_content 'Localização do Evento:'
    expect(page).to have_content 'Endereço do Buffet'
    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Aguardando aprovação'
    expect(page).to have_link 'Avaliar Pedido'
  end

  it 'and access order details, the order has an address' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'elsewhere', address: 'Rua da Saudade, 100', city: 'Recife', state: 'PE',
                  zipcode: '12345123')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'

    expect(current_path).to eq "/orders/#{order.id}/details"
    expect(page).to have_content 'Pedido de Festa de Casamento'
    expect(page).to have_content 'Código:'
    expect(page).to have_content 'moIoiXkBAFMXr4RGhn0J'
    expect(page).to have_content "Data:"
    expect(page).to have_content "#{1.week.from_now.to_date}"
    expect(page).to have_content "Quantidade de Convidados:"
    expect(page).to have_content "50"
    expect(page).to have_content 'Detalhes:'
    expect(page).to have_content 'Festa de Casamento para 50 pessoas'
    expect(page).to have_content 'Localização do Evento:'
    expect(page).to have_content 'Outro local'
    expect(page).to have_content 'Endereço:'
    expect(page).to have_content 'Rua da Saudade, 100, Recife - PE, 12345123'
    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Aguardando aprovação'
    expect(page).to have_link 'Avaliar Pedido'
  end
end