require 'rails_helper'

describe 'Owner evaluates pending order' do
  it 'accessing evaluation page from order page' do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    angelo = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')

    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: angelo, buffet: buffet, event_type: event, date: 1.day.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')
    Chat.create!(order: order)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Pedido'

    expect(page).to have_content 'Valor do Pedido'
    expect(page).to have_field 'Desconto'
    expect(page).to have_field 'Taxa Extra'
    expect(page).to have_field 'Descrição do Valor Final'
    expect(page).to have_content 'Valor Final'
    expect(page).to have_content 'Método de Pagamento'
    expect(page).to have_field 'Data de Validade'
    expect(page).to have_button 'Aprovar Pedido'
  end

  it 'and approves order without discount or fee', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    angelo = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')

    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: angelo, buffet: buffet, event_type: event, date: 1.month.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')
    Chat.create!(order: order)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Pedido'
    find('#payment_debit').click
    fill_in 'Data de Validade', with: 1.week.from_now.to_date
    click_on 'Aprovar Pedido'

    expect(page).to have_content 'Pedido aprovado com sucesso.'
    expect(current_path).to eq details_order_path(order)
    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Aprovado pelo Buffet'
    expect(page).to have_content 'Método de Pagamento:'
    expect(page).to have_content 'Cartão de Débito'
    expect(page).to have_content "Data de Validade:"
    expect(page).to have_content "#{1.week.from_now.to_date}"
    expect(page).to have_content 'Valor do Pedido:'
    expect(page).to have_content '3000'
    expect(page).not_to have_content 'Valor Final:'
  end

  it 'and approves with discount', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    angelo = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')

    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: angelo, buffet: buffet, event_type: event, date: 1.month.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')
    Chat.create!(order: order)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Pedido'
    find('#payment_debit').click
    fill_in 'Desconto', with: 500
    fill_in 'Descrição do Valor Final', with: 'Descontinho'
    fill_in 'Data de Validade', with: 1.week.from_now.to_date
    click_on 'Aprovar Pedido'

    expect(page).to have_content 'Pedido aprovado com sucesso.'
    expect(current_path).to eq details_order_path(order)
    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Aprovado pelo Buffet'
    expect(page).to have_content 'Método de Pagamento:'
    expect(page).to have_content 'Cartão de Débito'
    expect(page).to have_content "Data de Validade:"
    expect(page).to have_content "#{1.week.from_now.to_date}"
    expect(page).to have_content 'Valor do Pedido:'
    expect(page).to have_content '3000'
    expect(page).to have_content 'Valor Final:'
    expect(page).to have_content '2500'
  end

  it 'and approves with fee', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    angelo = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')

    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: angelo, buffet: buffet, event_type: event, date: 1.month.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')
    Chat.create!(order: order)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Pedido'
    find('#payment_debit').click
    fill_in 'Taxa Extra', with: 500
    fill_in 'Descrição do Valor Final', with: 'Tá tudo caro!'
    fill_in 'Data de Validade', with: 1.week.from_now.to_date
    click_on 'Aprovar Pedido'

    expect(page).to have_content 'Pedido aprovado com sucesso.'
    expect(current_path).to eq details_order_path(order)
    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Aprovado pelo Buffet'
    expect(page).to have_content 'Método de Pagamento:'
    expect(page).to have_content 'Cartão de Débito'
    expect(page).to have_content "Data de Validade:"
    expect(page).to have_content "#{1.week.from_now.to_date}"
    expect(page).to have_content 'Valor do Pedido:'
    expect(page).to have_content '3000'
    expect(page).to have_content 'Valor Final:'
    expect(page).to have_content '3500'
  end

  it 'approves and then edits proposal', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    angelo = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')

    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: angelo, buffet: buffet, event_type: event, date: 1.month.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')
    Chat.create!(order: order)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Pedido'
    find('#payment_debit').click
    fill_in 'Taxa Extra', with: 500
    fill_in 'Descrição do Valor Final', with: 'Tá tudo muito caro!'
    fill_in 'Data de Validade', with: 1.week.from_now.to_date
    click_on 'Aprovar Pedido'
    click_on 'Fazer Nova Proposta'
    find('#payment_pix').click
    fill_in 'Taxa Extra', with: 0
    fill_in 'Data de Validade', with: 1.week.from_now.to_date
    click_on 'Aprovar Pedido'

    expect(page).to have_content 'Pedido aprovado com sucesso.'
    expect(current_path).to eq details_order_path(order)
    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Aprovado pelo Buffet'
    expect(page).to have_content 'Método de Pagamento:'
    expect(page).to have_content 'PIX'
    expect(page).to have_content "Data de Validade:"
    expect(page).to have_content "#{1.week.from_now.to_date}"
    expect(page).to have_content 'Valor do Pedido:'
    expect(page).to have_content '3000'
    expect(page).to have_link 'Fazer Nova Proposta'
  end

  it ', approves, tries to edit and goes back', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    angelo = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')

    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '30',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, event_type: event)

    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
    order = Order.create!(user: angelo, buffet: buffet, event_type: event, date: 1.month.from_now.to_date, 
                  guest_quantity: 50, details: 'Festa de Casamento para 50 pessoas',
                  location: 'buffet_address')
    Chat.create!(order: order)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Pedido'
    find('#payment_debit').click
    fill_in 'Taxa Extra', with: 500
    fill_in 'Descrição do Valor Final', with: 'Tá tudo caro!'
    fill_in 'Data de Validade', with: 1.week.from_now.to_date
    click_on 'Aprovar Pedido'
    click_on 'Fazer Nova Proposta'
    click_on 'Voltar'

    expect(current_path).to eq details_order_path(order)
    expect(page).to have_content 'Status:'
    expect(page).to have_content 'Aprovado pelo Buffet'
    expect(page).to have_content 'Método de Pagamento:'
    expect(page).to have_content 'Cartão de Débito'
    expect(page).to have_content "Data de Validade:"
    expect(page).to have_content "#{1.week.from_now.to_date}"
    expect(page).to have_content 'Valor do Pedido:'
    expect(page).to have_content '3000'
    expect(page).to have_content 'Valor Final:'
    expect(page).to have_content '3500'
  end
end