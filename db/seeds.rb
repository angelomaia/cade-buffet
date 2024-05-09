owner = Owner.create!(email: 'owner@email.com', password: 'password')
owner_two = Owner.create!(email: 'owner_two@email.com', password: 'password')
owner_three = Owner.create!(email: 'owner_three@email.com', password: 'password')
owner_four = Owner.create!(email: 'owner_four@email.com', password: 'password')
owner_five = Owner.create!(email: 'owner_five@email.com', password: 'password')

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

Buffet.create!(name: 'Viva!', corporate_name: 'Viva Eventos e Recepções Ltda', cnpj: '20293048576', 
               address: 'Rua Nova Esperança, 90', neighborhood: 'Vila Nova', city: 'Porto Alegre', state: 'RS', 
               email: 'contato@viva.com.br', phone: '5198765432', zipcode: '52000123', 
               pix: true, debit: true, credit: false, cash: true, owner: owner_four)

noite_feliz = Buffet.create!(name: 'Noite Feliz', corporate_name: 'Noite Feliz Eventos Ltda', cnpj: '56789123456', 
               address: 'Travessa Lunar, 15', neighborhood: 'Luar', city: 'Manaus', state: 'AM', 
               email: 'contato@noitefeliz.com.br', phone: '9298765432', zipcode: '52000123', 
               pix: true, debit: true, credit: true, cash: false, owner: owner_five)

casamento_festim = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '20',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  buffet: festim)
Price.create!(base: 5000, extra_person: 200, extra_hour: 1500, event_type: casamento_festim)

infantil_festim = EventType.create!(name: 'Festa Infantil', duration: '240', min_people: '10',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  location: 'anywhere', buffet: festim)
EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  buffet: celebra)
EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  buffet: bons_momentos)
EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  buffet: noite_feliz)
EventType.create!(name: 'Festa Infantil', duration: '240', min_people: '10',
                  max_people: '100', description: 'Festa completa', menu: 'Sushi, mesa de frios, strogonoff',
                  buffet: noite_feliz)

casamento_festim.cover_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'wedding.jpg')), filename: 'wedding.jpg')
infantil_festim.cover_photo.attach(io: File.open(Rails.root.join('spec', 'support', 'kids_party.jpg')), filename: 'kids_party.jpg')
