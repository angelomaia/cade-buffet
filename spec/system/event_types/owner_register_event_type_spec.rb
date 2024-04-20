require 'rails_helper'

describe 'Owner adds event type to buffet' do
  it 'and needs to be authenticated' do

    visit new_event_type_path

    expect(current_path).to eq "/owners/sign_in"
  end

  it 'and sees all fields' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Adicionar Tipo de Evento'

    expect(page).to have_content 'Novo Tipo de Evento'
    expect(page).to have_field 'Nome do Evento'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Quantidade mínima de Pessoas'
    expect(page).to have_field 'Quantidade máxima de Pessoas'
    expect(page).to have_field 'Duração (minutos)'
    expect(page).to have_field 'Cardápio'
    expect(page).to have_field 'Bebidas alcoólicas'
    expect(page).to have_field 'Decoração'
    expect(page).to have_field 'Estacionamento/valet'
    expect(page).to have_content 'Exclusivamente no Endereço do Buffet'
    expect(page).to have_content 'Em qualquer local solicitado'
  end

  it 'is successfull' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Adicionar Tipo de Evento'
    fill_in 'Nome do Evento', with: "Festa de Casamento"
    fill_in  'Descrição', with: "Uma festança"
    fill_in  'Quantidade mínima de Pessoas', with: "20"
    fill_in  'Quantidade máxima de Pessoas', with: "200"
    fill_in  'Duração (minutos)', with: "240"
    fill_in  'Cardápio', with: "Sushi, Strogonoff, Frios"
    check  'Bebidas alcoólicas'
    check  'Estacionamento/valet'
    choose('event_type[location]', option: "anywhere")
    click_on 'Registrar'

    expect(page).to have_content 'Festa de Casamento'
    expect(page).to have_content 'Duração (minutos): 240'
    expect(page).to have_content 'Quantidade mínima de Pessoas: 20'
    expect(page).to have_content 'Quantidade máxima de Pessoas: 200'
    expect(page).to have_content 'Cardápio: Sushi, Strogonoff, Frios'
    expect(page).to have_content 'Extras: Bebidas alcoólicas Estacionamento/valet'
    expect(page).to have_content 'Localização do Evento: Em qualquer local solicitado'
  end

  it 'and leave blank fields' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Adicionar Tipo de Evento'
    fill_in 'Nome do Evento', with: ''
    fill_in  'Descrição', with: ''
    fill_in  'Quantidade mínima de Pessoas', with: ''
    fill_in  'Quantidade máxima de Pessoas', with: ''
    fill_in  'Duração (minutos)', with: ''
    fill_in  'Cardápio', with:  ''
    click_on 'Registrar'

    expect(page).to have_content 'Tipo de Evento não cadastrado.'
    expect(page).to have_content 'Nome do Evento não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Quantidade mínima de Pessoas não pode ficar em branco'
    expect(page).to have_content 'Quantidade máxima de Pessoas não pode ficar em branco'
    expect(page).to have_content 'Duração (minutos) não pode ficar em branco'
    expect(page).to have_content 'Cardápio não pode ficar em branco'
    expect(page).to have_content 'Novo Tipo de Evento'
  end

  it 'and access the event through a list' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Adicionar Tipo de Evento'
    fill_in 'Nome do Evento', with: "Festa de Casamento"
    fill_in  'Descrição', with: "Uma festança"
    fill_in  'Quantidade mínima de Pessoas', with: "20"
    fill_in  'Quantidade máxima de Pessoas', with: "200"
    fill_in  'Duração (minutos)', with: "240"
    fill_in  'Cardápio', with: "Sushi, Strogonoff, Frios"
    check  'Bebidas alcoólicas'
    check  'Estacionamento/valet'
    choose('event_type[location]', option: "anywhere")
    click_on 'Registrar'
    click_on 'Meu Buffet'
    click_on 'Tipos de Evento'
    click_on 'Festa de Casamento'

    expect(page).to have_content 'Festa de Casamento'
    expect(current_path).to eq "/event_types/#{EventType.last.id}"
  end
end