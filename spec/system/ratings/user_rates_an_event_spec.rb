require 'rails_helper'

describe 'User tries to rate an event' do
  it 'by accessing the order page' do
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

    travel 1.week do
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!
    end 

    travel 1.month
    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'

    expect(Order.last.date).to be < Date.today
    expect(page).to have_content 'Festa de Casamento'
    expect(page).to have_content 'Status: Confirmado'
    expect(current_path).to eq order_path(Order.last.id)
    expect(page).to have_link 'Avaliar Buffet'
  end

  it 'and sees rating form' do
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

    travel 1.week do
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!
    end 

    travel 1.month
    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Buffet'

    expect(Order.last.date).to be < Date.today
    expect(current_path).to eq new_order_rating_path(Order.last.id)
    expect(page).to have_content "Avalie o Buffet #{buffet.name}"
    expect(page).to have_content "Festa de Casamento em #{Order.last.date}"
    expect(page).to have_content 'Nota:'
    expect(page).to have_field 'Comentário'
    expect(page).to have_field 'Fotos'
  end

  it 'successfully' do
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

    travel 1.week do
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!
    end 

    travel 1.month
    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Buffet'
    find('#rating_grade_5').click
    fill_in 'Comentário', with: 'Amei a festa'
    click_on 'Enviar Avaliação'

    expect(page).to have_content "Avaliação enviada com sucesso"
    expect(Rating.last.text).to eq 'Amei a festa'
    expect(Rating.last.user).to eq user
    expect(Rating.last.buffet).to eq buffet
    expect(Rating.last.event_type).to eq event
    expect(current_path).to eq buffet_rating_path(buffet_id: Rating.last.buffet.id, id: Rating.last.id)
    expect(page).to have_content 'Avaliação de Angelo'
    expect(page).to have_content "Festa de Casamento em #{Order.last.date}"
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Comentário: Amei a festa'
    expect(page).to have_link 'Voltar para Buffet'
    expect(page).to have_link 'Voltar para Pedido'
  end

  it ', succeeds, and cannot rate order again' do
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

    travel 1.week do
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!
    end 

    travel 1.month
    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Buffet'
    find('#rating_grade_5').click
    fill_in 'Comentário', with: 'Amei a festa'
    click_on 'Enviar Avaliação'
    click_on 'Voltar para Pedido'

    expect(page).not_to have_link 'Avaliar Buffet'
  end

  it ', fills rating form fields, adds photos and sends rating' do
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

    travel 1.week do
      allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!
    end 

    travel 1.month
    login_as user, scope: :user
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'moIoiXkBAFMXr4RGhn0J'
    click_on 'Avaliar Buffet'
    find('#rating_grade_5').click
    fill_in 'Comentário', with: 'Amei a festa'
    attach_file 'Fotos', [Rails.root.join('spec', 'support', 'wedding_1.jpg'), Rails.root.join('spec', 'support', 'wedding_2.jpg')]
    click_on 'Enviar Avaliação'

    expect(page).to have_content "Avaliação enviada com sucesso"
    expect(Rating.last.text).to eq 'Amei a festa'
    expect(Rating.last.user).to eq user
    expect(Rating.last.buffet).to eq buffet
    expect(Rating.last.event_type).to eq event
    expect(current_path).to eq buffet_rating_path(buffet_id: Rating.last.buffet.id, id: Rating.last.id)
    expect(page).to have_content 'Avaliação de Angelo'
    expect(page).to have_content "Festa de Casamento em #{Order.last.date}"
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Comentário: Amei a festa'
    expect(page).to have_css 'img[src*="wedding_1.jpg"]'
    expect(page).to have_css 'img[src*="wedding_2.jpg"]'
    expect(page).to have_link 'Voltar para Buffet'
    expect(page).to have_link 'Voltar para Pedido'
  end
end