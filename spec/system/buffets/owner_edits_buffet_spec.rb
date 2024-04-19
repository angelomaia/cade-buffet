require 'rails_helper'

describe 'Owner edits buffet' do
  it 'and needs to be authenticated' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    
    visit root_path
    visit "/buffets/#{buffet.id}/edit"

    expect(current_path).to eq "/owners/sign_in"
  end

  it 'and is not the actual owner' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    other_owner = Owner.create!(email: 'other_owner@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: other_owner)
    buffet_two = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    visit "/buffets/#{buffet.id}/edit"

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode editar este Buffet.'
  end

  it 'successfully' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Editar Buffet'
    fill_in 'E-mail', with: 'alegria@sa.com'
    click_on 'Registrar'

    expect(current_path).to eq "/buffets/#{buffet.id}"
    expect(page).to have_content 'Buffet alterado com sucesso.'
    expect(page).to have_content 'Buffet Alegria'
    expect(page).to have_content 'alegria@sa.com'
    expect(page).not_to have_content 'alegria@email.com'
  end

  it 'and leaves a blank field' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Editar Buffet'
    fill_in 'E-mail', with: ''
    click_on 'Registrar'

    expect(page).to have_content 'Não foi possível atualizar o Buffet'
    expect(page).to have_content 'E-mail não pode ficar em branco'
  end
end