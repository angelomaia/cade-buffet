require 'rails_helper'

describe 'User signs up' do
  it 'and it works' do

    visit root_path
    click_on 'Entrar'
    click_on 'Cliente'
    click_on 'Criar conta'
    fill_in 'Nome', with: 'Angelo'
    fill_in 'CPF', with: '12345678910'
    fill_in 'E-mail', with: 'angelo@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'Conta criada com sucesso.'
  end
end