require 'rails_helper'

describe 'Owner register new buffet' do
  it 'and must be authenticated' do

    visit new_buffet_path

    expect(current_path).not_to eq new_buffet_path
  end

  it 'and sees the form' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')

    visit root_path
    login_owner(owner)

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Cadastrar Buffet'
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'Razão Social'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Bairro'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Telefone'
    expect(page).to have_field 'CEP'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'PIX'
    expect(page).to have_field 'Cartão de Débito'
    expect(page).to have_field 'Cartão de Crédito'
    expect(page).to have_field 'Dinheiro'
    expect(page).to have_button 'Registrar'
  end

  it 'and it works' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')

    visit root_path
    login_owner(owner)
    fill_in 'Nome Fantasia', with: 'Alegria'
    fill_in 'Razão Social', with: 'Alegria SA'
    fill_in 'CNPJ', with: '1934812038173'
    fill_in 'Endereço', with: 'Rua da Alegria, 1000'
    fill_in 'Bairro', with: 'Alegrete'
    fill_in 'Cidade', with: 'Recife'
    fill_in 'Estado', with: 'PE'
    fill_in 'E-mail', with: 'alegria@sa.com'
    fill_in 'Telefone', with: '81949329238'
    fill_in 'CEP', with: '18732-100'
    check 'PIX'
    check 'Dinheiro'
    click_on 'Registrar'

    expect(current_path).to eq "/buffets/#{Buffet.last.id}"
    expect(page).to have_content 'Buffet cadastrado com sucesso'
  end

  it 'and leave blank fields' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')

    visit root_path
    login_owner(owner)
    fill_in 'Nome Fantasia', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Endereço', with: ''
    fill_in 'Bairro', with: ''
    fill_in 'Cidade', with: ''
    fill_in 'Estado', with: ''
    fill_in 'E-mail', with: ''
    fill_in 'Telefone', with: ''
    fill_in 'CEP', with: ''
    click_on 'Registrar'

    expect(page).to have_content 'Buffet não cadastrado.'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
  end


  it 'and sees the buffet info' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')

    visit root_path
    login_owner(owner)
    fill_in 'Nome Fantasia', with: 'Alegria'
    fill_in 'Razão Social', with: 'Alegria SA'
    fill_in 'CNPJ', with: '1934812038173'
    fill_in 'Endereço', with: 'Rua da Alegria, 1000'
    fill_in 'Bairro', with: 'Alegrete'
    fill_in 'Cidade', with: 'Recife'
    fill_in 'Estado', with: 'PE'
    fill_in 'E-mail', with: 'alegria@sa.com'
    fill_in 'Telefone', with: '81949329238'
    fill_in 'CEP', with: '18732-100'
    check 'PIX'
    check 'Dinheiro'
    click_on 'Registrar'

    expect(page).to have_content 'Buffet cadastrado com sucesso'
    expect(page).to have_content 'Buffet Alegria'
    expect(page).to have_content 'alegria@sa.com'
    expect(page).to have_content 'Recife - PE'
    expect(page).to have_content 'Alegria SA | 1934812038173'

  end
end