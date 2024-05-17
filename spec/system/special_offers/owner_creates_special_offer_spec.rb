require 'rails_helper'

describe 'Owner tries to set Special Offer' do
  it 'from event type page' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'

    expect(page).to have_link 'Criar Promoção'
  end

  it 'and sees the form' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'
    click_on 'Criar Promoção'

    expect(page).to have_content 'Nova Promoção'
    expect(page).to have_field 'Data de Início'
    expect(page).to have_field 'Data de Encerramento'
    expect(page).to have_field 'Porcentagem de Desconto'
    expect(page).to have_button 'Registrar'
  end

  it 'successfully' do
    owner = Owner.create!(email: 'angelo@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
                  address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
                  email: 'alegria@email.com', phone: '8156456456', zipcode: '50000123',   
                  pix: true, debit: true, credit: false, cash: true, owner: owner)
    event = EventType.create!(name: 'Festa de Casamento', duration: '240', min_people: '10',
                              max_people: '100', description: 'Festa grande', menu: 'Macarrão com salsicha',
                              buffet: buffet)
    Price.create(base: 2000, extra_person: 50, extra_hour: 300, weekend_base: 3000, 
                weekend_extra_person: 75, weekend_extra_hour: 450, event_type: event) 
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Festa de Casamento'
    click_on 'Criar Promoção'
    fill_in 'Data de Início', with: 1.week.from_now.to_date
    fill_in 'Data de Encerramento', with: 3.weeks.from_now.to_date
    fill_in 'Porcentagem de Desconto', with: '20'
    click_on 'Registrar'

    expect(page).to have_content 'Promoção criada com sucesso!'
    expect(page).to have_content "Promoção: Desconto de #{SpecialOffer.last.percentage}% dos dias #{1.week.from_now.to_date} a #{3.weeks.from_now.to_date}"
  end
end