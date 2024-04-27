require 'rails_helper'

describe 'Buffet owner tries to authenticate' do
  it 'and is redirected to choice page' do

    visit root_path
    click_on 'Entrar'

    expect(current_path).to eq(home_choice_path)
    expect(page).to have_link 'Dono de Buffet'
    expect(page).to have_content 'Cliente'
  end

  it 'and it works' do
    owner = Owner.create(email: 'angelo@email.com', password: 'password')

    visit root_path
    click_on 'Entrar'
    click_on 'Dono de Buffet'
    fill_in 'E-mail', with: owner.email
    fill_in 'Senha', with: owner.password
    within('main form') do
      click_on 'Entrar'
    end

    expect(page).not_to have_link 'Entrar'
    expect(page).to have_button 'Sair'
    within('nav') do
      expect(page).to have_content 'angelo@email.com'
    end
  end

  it 'logs in and out' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')

    visit root_path
    click_on 'Entrar'
    click_on 'Dono de Buffet'
    fill_in 'E-mail', with: owner.email
    fill_in 'Senha', with: owner.password
    within('main form') do
      click_on 'Entrar'
    end
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'angelo@email.com'
  end

  it 'logs and is redirected to buffet page' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)

    visit root_path
    click_on 'Entrar'
    click_on 'Dono de Buffet'
    fill_in 'E-mail', with: owner.email
    fill_in 'Senha', with: owner.password
    within('main form') do
      click_on 'Entrar'
    end

    expect(current_path).to eq "/buffets/#{buffet.id}"
    expect(page).to have_content 'Buffet: Alegria'
    expect(page).to have_content 'alegria@email.com'
    expect(page).to have_content 'Recife - PE'
    expect(page).to have_content 'CNPJ: 65165161'
    expect(page).to have_content 'Editar Buffet'
  end
end