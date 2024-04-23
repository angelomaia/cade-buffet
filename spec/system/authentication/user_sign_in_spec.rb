require 'rails_helper'

describe 'User tries to authenticate' do
  it 'and is redirected to choice page' do

    visit root_path
    click_on 'Entrar'

    expect(current_path).to eq(home_choice_path)
    expect(page).to have_link 'Dono de Buffet'
    expect(page).to have_link 'Cliente'
  end

  it 'and it works' do
    user = User.create!(name: 'Angelo', cpf: '12345678910', email: 'angelo@email.com', password: 'password')

    visit root_path
    click_on 'Entrar'
    click_on 'Cliente'
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    within('main form') do
      click_on 'Entrar'
    end

    expect(page).not_to have_link 'Entrar'
    expect(page).to have_button 'Sair'
    within('nav') do
      expect(page).to have_content 'angelo@email.com'
      expect(page).to have_field 'Buscar Buffet'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'logs in and out' do
    user = User.create!(name: 'Angelo', cpf: '12345678910', email: 'angelo@email.com', password: 'password')

    visit root_path
    visit root_path
    click_on 'Entrar'
    click_on 'Cliente'
    fill_in 'E-mail', with: user.email
    fill_in 'Senha', with: user.password
    within('main form') do
      click_on 'Entrar'
    end
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'angelo@email.com'
  end
end