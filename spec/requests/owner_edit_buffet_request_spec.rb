# require 'rails_helper'

# describe 'Owner edits buffet' do
#   it 'and is not the owner' do
#     owner = Owner.create!(email: 'angelo@email.com', password: 'password')
#     other_owner = Owner.create!(email: 'other_owner@email.com', password: 'password')
#     buffet = Buffet.create!(name: 'Alegria', corporate_name: 'Alegria SA', cnpj: '65165161', 
#                   address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
#                   email: 'alegria@email.com', phone: '8156456456', zipcode: '1231245', owner: other_owner)
#     buffet_two = Buffet.create!(name: 'Felicidade', corporate_name: 'Felicidade SA', cnpj: '1231534', 
#                   address: 'Rua da Felicidade, 100', neighborhood: 'Alegre', city: 'Recife', state: 'PE', 
#                   email: 'felicidade@email.com', phone: '8156456456', zipcode: '1231245', owner: owner)
    

#     login_owner(owner)
#     patch(buffet_path(buffet.id), params: { buffet: {name: 'Outro nome' }})

#     expect(response).to redirect_to(root_path)
#   end
# end