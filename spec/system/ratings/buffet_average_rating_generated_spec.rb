require 'rails_helper'

describe 'A Buffet has an average rating' do
  it 'after one rating' do
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
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order)
    OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
    order.approved!
    order.confirmed!
    order.date = 1.month.ago.to_date
    Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 5, text: 'Ótima festa')

    visit root_path
    click_on 'Alegria'

    expect(page).to have_content 'Nota do Buffet (0 - 5): 5'
  end

  it 'after two ratings' do
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
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order)
    OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
    order.approved!
    order.confirmed!
    order.date = 1.month.ago.to_date
    Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 5, text: 'Ótima festa')
    order_two = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order_two)
    OrderPrice.create!(order: order_two, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
    order_two.approved!
    order_two.confirmed!
    order_two.date = 1.month.ago.to_date
    Rating.create(user: user, order: order_two, buffet: buffet, event_type: event, grade: 2, text: 'Ótima festa')

    visit root_path
    click_on 'Alegria'

    expect(page).to have_content 'Nota do Buffet (0 - 5): 3.5'
  end

  it 'after three ratings' do
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
    order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order)
    OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
    order.approved!
    order.confirmed!
    order.date = 1.month.ago.to_date
    Rating.create(user: user, order: order, buffet: buffet, event_type: event, grade: 5, text: 'Ótima festa')
    order_two = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order_two)
    OrderPrice.create!(order: order_two, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
    order_two.approved!
    order_two.confirmed!
    order_two.date = 1.month.ago.to_date
    Rating.create(user: user, order: order_two, buffet: buffet, event_type: event, grade: 2, text: 'Ótima festa')
    order_three = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                  guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                  location: 'buffet_address', status: 'pending')
    Chat.create!(order: order_three)
    OrderPrice.create!(order: order_three, buffet: buffet, event_type: event, base: 2000, 
                      payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
    order_three.approved!
    order_three.confirmed!
    order_three.date = 1.month.ago.to_date
    Rating.create(user: user, order: order_three, buffet: buffet, event_type: event, grade: 2, text: 'Ótima festa')

    visit root_path
    click_on 'Alegria'

    expect(page).to have_content 'Nota do Buffet (0 - 5): 3'
  end
end