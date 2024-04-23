require 'rails_helper'

describe 'User visits homepage' do
  it 'and sees the app name' do
    visit root_path

    expect(page).to have_content('Cadê Buffet')
    expect(page).to have_link('Cadê Buffet', href: root_path)
  end

  it 'and sees a buffet list' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    owner_two = Owner.create!(email: 'two@email.com', password: 'password')
    owner_three = Owner.create!(email: 'three@email.com', password: 'password')
    Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidaade SA', cnpj: '454654654', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Salvador', state: 'BA', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    Buffet.create!(name: 'Euforia', corporate_name: 'Euforia SA', cnpj: '321321321', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'São Paulo', state: 'SP', 
                  email: 'euforia@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    visit root_path

    expect(page).to have_content('Cadê Buffet')
    expect(page).to have_link('Cadê Buffet', href: root_path)
    expect(page).to have_content 'Buffets'
    expect(page).to have_content 'Alegria'
    expect(page).to have_content 'Recife - PE'
    expect(page).to have_content 'Felicidade'
    expect(page).to have_content 'Salvador - BA'
    expect(page).to have_content 'Euforia'
    expect(page).to have_content 'São Paulo - SP'
  end

  it 'and clicks in a buffet to see details' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    owner_two = Owner.create!(email: 'two@email.com', password: 'password')
    owner_three = Owner.create!(email: 'three@email.com', password: 'password')
    Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidaade SA', cnpj: '454654654', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Salvador', state: 'BA', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    Buffet.create!(name: 'Euforia', corporate_name: 'Euforia SA', cnpj: '321321321', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'São Paulo', state: 'SP', 
                  email: 'euforia@email.com', phone: '8156456456', zipcode: '1231245',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    visit root_path
    click_on 'Felicidade'

    expect(page).to have_link('Cadê Buffet', href: root_path)
    expect(page).to have_content 'Buffet: Felicidade'
    expect(page).not_to have_content 'Felicidade SA'
    expect(page).to have_content 'Salvador - BA'
    expect(page).to have_content 'CNPJ: 454654654'
    expect(page).to have_content 'Localização: Rua da Felicidade, 100, Alegre, Salvador - BA'
    expect(page).to have_content 'E-mail: felicidade@email.com'
    expect(page).to have_content 'Telefone: 8156456456'
    expect(page).to have_content 'Métodos de Pagamento: PIX, Cartão de Débito, Dinheiro'
    expect(page).not_to have_content 'Felicidade SA'


  end
end