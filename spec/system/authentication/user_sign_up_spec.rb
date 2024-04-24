require 'rails_helper'

describe 'User signs up' do
  it 'and sees registration form' do

    visit root_path
    click_on 'Entrar'
    click_on 'Cliente'
    click_on 'Criar conta'

    expect(current_path).to eq new_user_registration_path
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'CPF'
  end

  it 'and it works' do

    visit root_path
    click_on 'Entrar'
    click_on 'Cliente'
    click_on 'Criar conta'
    fill_in 'Nome', with: 'Angelo'
    fill_in 'CPF', with: '13465814653'
    fill_in 'E-mail', with: 'angelo@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'Conta criada com sucesso.'
  end
end