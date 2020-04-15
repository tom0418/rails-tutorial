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

      it 'サインアップできること' do
        # Userテーブルにレコードが1件追加されること
        expect { click_button 'Create my account' }.to change(User, :count).by(1)

        # サインアップしたユーザーのProfile Pageにリダイレクトすること
        user = User.last
        expect(current_path).to eq(user_path(user))

        # 'Welcome to the Sample App!'と表示されること
        expect(page).to have_content('Welcome to the Sample App!')

        # ナビゲーション
        within('.navbar-nav') do
          # [Log in]リンクが非表示になること
          expect(page).not_to have_content('Log in')

          # [Account]リンクが表示されること
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

      it 'サインアップできないこと' do
        # Userテーブルにレコードが追加されないこと
        expect { click_button 'Create my account' }.to change(User, :count).by(0)

        # 'The form contains 1 error.'と表示されること
        expect(page).to have_selector('div.alert.alert-danger', text: 'The form contains 1 error.')
      end
    end

    context '無効な入力情報が複数(4つ)の時' do
      before do
        visit signup_path
        fill_in 'Name', with: ''
        fill_in 'Email', with: ''
        fill_in 'Password', with: ''
        fill_in 'Confirmation', with: ''
      end

      it 'サインアップできないこと' do
        # Userテーブルにレコードが追加されないこと
        expect { click_button 'Create my account' }.to change(User, :count).by(0)

        # 'The form contains 4 errors.'と表示されること
        expect(page).to have_selector('div.alert.alert-danger', text: 'The form contains 4 errors.')
      end
    end
  end
end
