require 'rails_helper'

describe 'Ratings appear in buffet page' do
  it 'when there is only one rating' do
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

    travel 1.month do
      Rating.create!(order: Order.last, buffet: buffet, user: user, event_type: event,
                    grade: 5, text: 'Ótima festa de casamento')
    end
    visit buffet_path(buffet)

    expect(current_path).to eq buffet_path(buffet)
    expect(page).to have_content 'Buffet: Alegria'
    expect(page).to have_content 'Avaliações do Buffet'
    expect(page).to have_content "Festa de Casamento em #{Order.last.date}"
    expect(page).to have_content 'Nota: 5'
    expect(page).to have_content 'Comentário: Ótima festa de casamento'
  end

  it ', but only the three most recent' do
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
      allow(SecureRandom).to receive(:alphanumeric).and_return('AoIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 1.week.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!

      allow(SecureRandom).to receive(:alphanumeric).and_return('BoIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 2.weeks.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!

      allow(SecureRandom).to receive(:alphanumeric).and_return('CoIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 3.weeks.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!

      allow(SecureRandom).to receive(:alphanumeric).and_return('DoIoiXkBAFMXr4RGhn0J')
      order = Order.create!(user: user, buffet: buffet, event_type: event, date: 4.weeks.from_now.to_date, 
                    guest_quantity: 30, details: 'Festa de Casamento pra 50 pessoas',
                    location: 'buffet_address', status: 'pending')
      Chat.create!(order: order)
      OrderPrice.create!(order: order, buffet: buffet, event_type: event, base: 2000, 
                        payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
      order.approved!
      order.confirmed!
    end 

    travel 2.months do
      Rating.create!(order: Order.find(1), buffet: buffet, user: user, event_type: event,
                    grade: 5, text: 'Ótima festa de casamento')
    end
    travel 3.months do
      Rating.create!(order: Order.find(2), buffet: buffet, user: user, event_type: event,
                    grade: 2, text: 'Festa de casamento ruim')
    end
    travel 4.months do
      Rating.create!(order: Order.find(3), buffet: buffet, user: user, event_type: event,
                    grade: 3, text: 'Festa de casamento mais ou menos')
    end
    travel 5.months do
      Rating.create!(order: Order.find(4), buffet: buffet, user: user, event_type: event,
                    grade: 4, text: 'Boa festa de casamento')
    end
    visit buffet_path(buffet)

    expect(current_path).to eq buffet_path(buffet)
    expect(page).to have_content 'Buffet: Alegria'
    expect(page).to have_content 'Avaliações do Buffet'
    expect(page).not_to have_content "Festa de Casamento em #{Order.find(1).date}"
    expect(page).not_to have_content 'Nota: 5'
    expect(page).not_to have_content 'Comentário: Ótima festa de casamento'
    expect(page).to have_content "Festa de Casamento em #{Order.find(2).date}"
    expect(page).to have_content 'Nota: 2'
    expect(page).to have_content 'Comentário: Festa de casamento ruim'
    expect(page).to have_content "Festa de Casamento em #{Order.find(3).date}"
    expect(page).to have_content 'Nota: 3'
    expect(page).to have_content 'Comentário: Festa de casamento mais ou menos'
    expect(page).to have_content "Festa de Casamento em #{Order.find(4).date}"
    expect(page).to have_content 'Nota: 4'
    expect(page).to have_content 'Comentário: Boa festa de casamento'
    expect(page).to have_link 'Ver Todas'
  end
end