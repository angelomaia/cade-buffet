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
    Owner.create(email: 'angelo@email.com', password: 'password')

    visit root_path
    click_on 'Entrar'
    click_on 'Dono de Buffet'
    fill_in 'E-mail', with: 'angelo@email.com'
    fill_in 'Senha', with: 'password'
    within('form') do
      click_on 'Entrar'
    end

    #expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).not_to have_link 'Entrar'
    expect(page).to have_button 'Sair'
    within('nav') do
      expect(page).to have_content 'angelo@email.com'
    end
  end

  it 'logs in and out' do
    # Arrange
    Owner.create!(email: 'angelo@email.com', password: 'password')

    # Act
    visit root_path
    click_on 'Entrar'
    click_on 'Dono de Buffet'
    fill_in 'E-mail', with: 'angelo@email.com'
    fill_in 'Senha', with: 'password'
    within('form') do
      click_on 'Entrar'
    end
    click_on 'Sair'

    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'angelo@email.com'
  end
end