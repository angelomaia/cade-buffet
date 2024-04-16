require 'rails_helper'

describe 'Buffet owner signs up' do
  it 'and it works' do

    visit root_path
    click_on 'Entrar'
    click_on 'Dono de Buffet'
    click_on 'Criar conta'
    fill_in 'E-mail', with: 'angelo@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'Conta criada com sucesso.'
  end

  it 'and needs to register the buffet' do

    visit root_path
    click_on 'Entrar'
    click_on 'Dono de Buffet'
    click_on 'Criar conta'
    fill_in 'E-mail', with: 'angelo@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'Conta criada com sucesso.'
    expect(page).to have_content 'Cadastrar Buffet'
    expect(current_path).to eq new_buffet_path
  end
end