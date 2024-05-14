require 'rails_helper'

describe 'Owner deactivates Buffet' do
  it 'from Buffet page' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Desativar Buffet'

    expect(page).to have_content 'Buffet desativado com sucesso'
    expect(page).to have_content 'Status: Desativado'
    expect(current_path).to eq buffet_path(buffet.id)
  end

  it 'and Buffet is excluded from search' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    owner_two = Owner.create!(email: 'two@email.com', password: 'password')
    owner_three = Owner.create!(email: 'three@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidaade SA', cnpj: '454654654', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Salvador', state: 'BA', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_two)
    Buffet.create!(name: 'Euforia', corporate_name: 'Euforia SA', cnpj: '321321321', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'São Paulo', state: 'SP', 
                  email: 'euforia@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner_three)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Desativar Buffet'
    visit root_path
    click_on 'Sair'
    within('header nav') do
      fill_in 'Buscar Buffet', with: 'Alegria'
      click_on 'Buscar'
    end

    expect(page).to have_content 'Nenhum resultado encontrado'
    expect(page).not_to have_link 'Alegria'
    expect(page).not_to have_link 'Felicidade'
    expect(page).not_to have_link 'Euforia'
  end

  it 'and then activate it' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Desativar Buffet'
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Ativar Buffet'

    expect(page).to have_content 'Buffet ativado com sucesso'
    expect(page).to have_content 'Status: Ativo'
    expect(current_path).to eq buffet_path(buffet.id)
  end
end