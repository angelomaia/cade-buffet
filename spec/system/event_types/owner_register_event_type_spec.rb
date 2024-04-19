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
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    
    visit root_path
    login_owner(owner)
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
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    
    visit root_path
    login_owner(owner)
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
end