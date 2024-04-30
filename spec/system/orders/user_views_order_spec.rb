require 'rails_helper'

describe 'User views order' do
  it 'after creation', js: true do
    owner = Owner.create!(email: 'alegria@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    user = User.create!(name: 'Angelo', cpf: CPF.generate, email: 'angelo@email.com', password: 'password')
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              location: 'anywhere', buffet: buffet)

    allow(SecureRandom).to receive(:alphanumeric).and_return('moIoiXkBAFMXr4RGhn0J')

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
    expect(page).to have_content 'Pedido de Festa de Casamento'
    expect(page).to have_content 'Buffet Alegria'
    expect(page).to have_content 'Código: moIoiXkBAFMXr4RGhn0J'
    expect(page).to have_content "Data: #{1.week.from_now.to_date}"
    expect(page).to have_content "Quantidade de Convidados: 60"
    expect(page).to have_content 'Detalhes: Festa de casamento para 60 pessoas'
    expect(page).to have_content 'Localização do Evento: Endereço do Buffet'
    expect(page).to have_content 'Status: Aguardando aprovação do Buffet'
  end
end