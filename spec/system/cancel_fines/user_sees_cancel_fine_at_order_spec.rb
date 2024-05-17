require 'rails_helper'

describe 'User creates new order' do
  it 'and sees the cancel fines for the event type' do
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
    CancelFine.create!(days: 30, percentage: 50, event_type: event)
    CancelFine.create!(days: 7, percentage: 100, event_type: event)

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
    expect(page).to have_content 'Multas por Cancelamento:'
    expect(page).to have_content 'Dias antes da Data do Evento: 30' 
    expect(page).to have_content 'Porcentagem da Multa: 50%'
    expect(page).to have_content 'Dias antes da Data do Evento: 7' 
    expect(page).to have_content 'Porcentagem da Multa: 100%'
  end

  it 'it gets approved, and then confirmed, and the user tries to cancel it' do
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
    CancelFine.create!(days: 30, percentage: 50, event_type: event)
    CancelFine.create!(days: 7, percentage: 100, event_type: event)
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 2.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order)
    OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, total: 2000,
                      payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
    order.approved!
    order.confirmed!

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Cancelar Pedido'

    expect(page).to have_content 'Alerta!'
    expect(page).to have_content 'O Cancelamento do Pedido acarretará na cobrança da seguinte multa:'
    expect(page).to have_content 'R$ 1000' 
    expect(page).to have_button 'Confirmar Cancelamento'
  end

  it 'it gets approved, confirmed, and the User cancels it with fine' do
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
    CancelFine.create!(days: 30, percentage: 50, event_type: event)
    CancelFine.create!(days: 7, percentage: 100, event_type: event)
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 2.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order)
    OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, total: 2000,
                      payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
    order.approved!
    order.confirmed!

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Cancelar Pedido'
    click_on 'Confirmar Cancelamento'

    expect(page).to have_content 'Pedido cancelado com sucesso. Multa aplicada.'
    expect(FineCharge.last.value).to eq 1000
    expect(page).to have_content 'Status: Cancelado'
    expect(page).to have_content 'Multa Pendente de R$ 1000'
  end
end