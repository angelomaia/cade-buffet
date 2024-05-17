require 'rails_helper'

describe 'Owner gets order cancelled by user with cancel fine applied' do
  it ', and sees cancel fine charge in order page' do
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
    order.cancelled!
    FineCharge.create!(order: order, user: user, buffet: buffet, value: 1000)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'

    expect(page).to have_content 'Status: Cancelado'
    expect(page).to have_content 'Multa Pendente de R$ 1000'
    expect(page).to have_button 'Multa Paga'
  end

  it 'and set fine charge as paid in order page' do
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
    order.cancelled!
    FineCharge.create!(order: order, user: user, buffet: buffet, value: 1000)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Multa Paga'

    expect(page).to have_content 'Status: Cancelado'
    expect(page).to have_content 'Multa definida como Paga.'
    expect(page).to have_content 'Multa de R$ 1000.0 Paga'
    expect(page).not_to have_button 'Multa Paga'
  end
end