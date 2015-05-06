require 'rails_helper'

feature 'User management' do
  scenario "adds a new admin" do
    admin = create(:admin)

    visit root_path
    fill_in 'Username', with: admin.username
    fill_in 'Password', with: admin.password
    click_button 'Log in'

    visit root_path
    expect{
      click_link 'Settings'
      click_link 'New user'
      fill_in 'Username', with: 'newadmin'
      fill_in 'Email', with: 'newadmin@example.com'
      find('.user_password').fill_in 'Password', with: '12345678'
      find('.user_password_confirmation').fill_in 'Password confirmation', with: '12345678'
      check 'Admin'
      click_button 'Create'
    }.to change(User, :count).by(1)
    expect(current_path).to eq users_path
    within 'h1' do
      expect(page).to have_content 'Listing users'
    end

    expect(page).to have_content 'newadmin'
  end
end