def login_owner(owner)
  click_on 'Entrar'
  click_on 'Dono de Buffet'
  fill_in 'E-mail', with: owner.email
  fill_in 'Senha', with: owner.password
  within('form') do
    click_on 'Entrar'
  end
end