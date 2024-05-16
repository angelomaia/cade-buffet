owner = Owner.create!(email: 'owner@email.com', password: 'password')
owner_two = Owner.create!(email: 'owner_two@email.com', password: 'password')
owner_three = Owner.create!(email: 'owner_three@email.com', password: 'password')

user = User.create!(name: 'User', cpf: CPF.generate, email: 'user@email.com', password: 'password')

festim = Buffet.create!(name: 'Festim', corporate_name: 'Festim Eventos Ltda', cnpj: '12345678901', 
               address: 'Rua das Camélias, 58', neighborhood: 'Jardim', city: 'São Paulo', state: 'SP', 
               email: 'contato@festim.com.br', phone: '1198765432', zipcode: '52000123', 
               pix: true, debit: true, credit: true, cash: false, owner: owner)

celebra = Buffet.create!(name: 'Celebra', corporate_name: 'Celebrações e Festas S.A.', cnpj: '98765432109', 
               address: 'Avenida dos Diamantes, 300', neighborhood: 'Industrial', city: 'Belo Horizonte', state: 'MG', 
               email: 'celebra@celebra.com.br', phone: '3197654321', zipcode: '52000123', 
               pix: false, debit: true, credit: true, cash: true, owner: owner_two)

bons_momentos = Buffet.create!(name: 'Bons Momentos', corporate_name: 'Bons Momentos Buffet Ltda', cnpj: '56473829100', 
               address: 'Praça da Estação, 45', neighborhood: 'Centro', city: 'Recife', state: 'PE', 
               email: 'atendimento@bonsmomentos.com.br', phone: '4198526374', zipcode: '52000123', 
               pix: true, debit: false, credit: true, cash: true, owner: owner_three)

casamento_festim = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '20',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  buffet: festim)
Price.create!(base: 5000, extra_person: 200, extra_hour: 1500, event_type: casamento_festim)

infantil_festim = EventType.create!(name: 'Festa Infantil', duration: '240', min_people: '10',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  location: 'anywhere', buffet: festim)
Price.create!(base: 3000, extra_person: 100, extra_hour: 1000, event_type: infantil_festim)

EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  buffet: celebra)
EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  buffet: bons_momentos)

casamento_festim.cover_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'wedding.jpg')), filename: 'wedding.jpg')
infantil_festim.cover_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'kids_party.jpg')), filename: 'kids_party.jpg')

casamento_festim.gallery_photos.attach(io: File.open(Rails.root.join('spec', 'support', 'wedding_3.jpg')), filename: 'wedding_3.jpg')
casamento_festim.gallery_photos.attach(io: File.open(Rails.root.join('spec', 'support', 'wedding_4.jpg')), filename: 'wedding_4.jpg')
casamento_festim.gallery_photos.attach(io: File.open(Rails.root.join('spec', 'support', 'wedding_5.jpg')), filename: 'wedding_5.jpg')

order = Order.create!(user: user, buffet: festim, event_type: casamento_festim, date: 1.week.from_now.to_date, 
              guest_quantity: 50, details: 'Festa de Casamento pra 50 pessoas',
              location: 'buffet_address', status: 'pending')
Chat.create!(order: order)
OrderPrice.create!(order: order, buffet: festim, event_type: casamento_festim, base: 11000, 
                  payment: 'debit', expiration_date: 1.year.from_now.to_date, discount: 0, fee: 0)
order.approved!
order.confirmed!
order.date = 1.month.ago.to_date
rating = Rating.create!(user: user, order: order, buffet: festim, event_type: casamento_festim, grade: 5, text: 'Ótima festa de casamento!')

rating.photos.attach(io: File.open(Rails.root.join('spec', 'support', 'wedding_1.jpg')), filename: 'wedding_1.jpg')
rating.photos.attach(io: File.open(Rails.root.join('spec', 'support', 'wedding_2.jpg')), filename: 'wedding_2.jpg')