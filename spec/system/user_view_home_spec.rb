require 'rails_helper'

describe 'User visits homepage' do
  it 'and sees the app name' do
    visit root_path

    expect(page).to have_content('Cadê Buffet?')
    expect(page).to have_link('Cadê Buffet', href: root_path)
  end
end