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
    login_owner(owner)

    expect(page).not_to have_link 'Entrar'
    expect(page).to have_button 'Sair'
    within('nav') do
      expect(page).to have_content 'angelo@email.com'
    end
  end

  it 'logs in and out' do
    # Arrange
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')

    # Act
    visit root_path
    login_owner(owner)
    click_on 'Sair'

    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'angelo@email.com'
  end
end