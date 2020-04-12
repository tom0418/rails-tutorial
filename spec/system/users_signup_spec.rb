require 'rails_helper'

RSpec.describe 'Sign up', type: :system do
  describe '/signup' do
    context '有効な入力情報の時' do
      before do
        visit signup_path
        fill_in 'Name', with: 'Test User'
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'password'
      end

      example 'サインアップできること' do
        expect { click_button 'Create my account' }.to change(User, :count).by(1)
        user = User.last
        expect(current_path).to eq(user_path(user))
        expect(page).to have_content('Welcome to the Sample App!')

        within('.navbar-nav') do
          expect(page).to_not have_content('Log in')
          expect(page).to have_content('Account')
        end
      end
    end

    context '無効な入力情報が1つの時' do
      before do
        visit signup_path
        fill_in 'Name', with: 'Test User'
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Confirmation', with: 'invalid'
      end

      example "'The form contains 1 error.'と表示されること" do
        expect { click_button 'Create my account' }.to change(User, :count).by(0)
        expect(page).to have_selector('div.alert.alert-danger', text: 'The form contains 1 error.')
      end
    end

    context '無効な入力情報が複数(3つ)の時' do
      before do
        visit signup_path
        fill_in 'Name', with: 'Test User'
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: ''
        fill_in 'Confirmation', with: ''
      end

      example "'The form contains 3 errors.'と表示されること" do
        expect { click_button 'Create my account' }.to change(User, :count).by(0)
        expect(page).to have_selector('div.alert.alert-danger', text: 'The form contains 3 errors.')
      end
    end
  end
end
