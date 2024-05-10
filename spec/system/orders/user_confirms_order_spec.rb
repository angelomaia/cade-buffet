require 'rails_helper'

describe 'User access approved order' do
  it 'from My Orders page' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order)
    OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.day.from_now.to_date, discount: 0, fee: 0)
    order.approved!

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'

    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Aprovado pelo Buffet'
    expect(page).to have_content 'Proposta do Buffet:'
    expect(page).to have_content 'Método de Pagamento:'
    expect(page).to have_content 'Cartão de Débito'
    expect(page).to have_content "Data de Validade:"
    expect(page).to have_content "#{1.day.from_now.to_date}"
    expect(page).to have_content 'Valor do Pedido:'
    expect(page).to have_content '2000'
    expect(page).to have_button 'Confirmar Pedido'
  end

  it 'and confirms it' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order)
    OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.day.from_now.to_date, discount: 0, fee: 0)
    order.approved!

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Confirmar Pedido'

    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Confirmado'
    expect(page).to have_content 'Proposta do Buffet:'
    expect(page).to have_content 'Método de Pagamento:'
    expect(page).to have_content 'Cartão de Débito'
    expect(page).to have_content "Data de Validade:"
    expect(page).to have_content "#{1.day.from_now.to_date}"
    expect(page).to have_content 'Valor do Pedido:'
    expect(page).to have_content '2000'
    expect(page).not_to have_link 'Confirmar Pedido'
  end

  it 'and cancels it', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order)
    OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.day.from_now.to_date, discount: 0, fee: 0)
    order.approved!

    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    accept_confirm do
      click_on 'Cancelar Pedido'
    end

    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Cancelado'
    expect(page).not_to have_content 'Proposta do Buffet:'
    expect(page).not_to have_content 'Método de Pagamento:'
    expect(page).not_to have_content 'Cartão de Débito'
    expect(page).not_to have_content "Data de Validade:"
    expect(page).not_to have_content "#{1.day.from_now.to_date}"
    expect(page).not_to have_content 'Valor do Pedido:'
    expect(page).not_to have_content '2000'
    expect(page).not_to have_link 'Confirmar Pedido'
  end

  it 'and it is past due expiration date, and therefore is cancelled ' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order)
    OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.day.from_now.to_date, discount: 0, fee: 0)
    order.approved!

    travel 2.day
    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'

    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Cancelado'
    expect(page).not_to have_link 'Confirmar Pedido'
  end
end