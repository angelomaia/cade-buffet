require 'rails_helper'

describe 'Owner views buffet' do
  it 'sucessfully' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    visit "/buffets/#{buffet.id}"

    expect(current_path).to eq "/buffets/#{buffet.id}"
    expect(page).to have_content 'Buffet Alegria'
    expect(page).to have_content 'alegria@email.com'
    expect(page).to have_content 'Recife - PE'
    expect(page).to have_content 'Alegria SA | 65165161'
    expect(page).to have_content 'Editar Buffet'
  end

  it "from another owner" do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    owner_two = Owner.create!(email: 'angelo2@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    buffet_two = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'felicidade@email.com', phone: '8156456456', zipcode: '1231245', owner: owner_two)
    
    login_as owner_two, scope: :owner
    visit root_path
    visit "/buffets/#{buffet.id}"

    expect(current_path).to eq "/buffets/#{buffet.id}"
    expect(page).to have_content 'Buffet Alegria'
    expect(page).to have_content 'alegria@email.com'
    expect(page).to have_content 'Recife - PE'
    expect(page).to have_content 'Alegria SA | 65165161'
    expect(page).not_to have_content 'Editar Buffet'
  end

  it 'and opens editing page' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    
    login_as owner, scope: :owner
    visit root_path
    visit "/buffets/#{buffet.id}"
    click_on 'Editar Buffet'

    expect(page).to have_content 'Alterar Buffet'
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'E-mail'
    expect(page).to have_button 'Registrar'
  end
end