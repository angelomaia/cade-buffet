require 'rails_helper'

describe 'User access approved order' do
  it 'and sees the chat box' do
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

    expect(page).to have_content "Converse com o Buffet #{buffet.name}"
    expect(page).to have_field 'Mensagem'
    expect(page).to have_button 'Enviar'
  end

  it 'and send a message to the Buffet' do
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
    fill_in 'Mensagem', with: 'Olá Buffet! Como vai?'
    click_on 'Enviar'
    time_sent = UserMessage.last.created_at.strftime("%d %b %Y %H:%M")

    expect(page).to have_content "Converse com o Buffet #{buffet.name}"
    expect(page).to have_field 'Mensagem'
    expect(page).to have_button 'Enviar'
    expect(page).to have_content 'Olá Buffet! Como vai?'
    expect(page).to have_content "Enviado em: #{time_sent}"
  end
end