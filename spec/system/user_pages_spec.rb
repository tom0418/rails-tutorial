require 'rails_helper'

RSpec.describe 'User pages', type: :system do
  let!(:user) { create(:user) }

  describe 'Profile page' do
    context 'Profile Pageにアクセスした時' do
      before { visit user_path(user) }
      it 'ユーザー名が表示されること' do
        expect(page).to have_content(user.name)
      end

      it 'ページタイトルがユーザー名であること' do
        expect(page).to have_title(user.name)
      end
    end
  end

  describe 'User Edit Page' do
    before { visit edit_user_path(user) }

    context '有効な入力情報の時' do
      before do
        fill_in 'Name', with: 'Edit User'
        fill_in 'Email', with: 'edit_test@example.com'
        fill_in 'Password', with: 'edit_password'
        fill_in 'Confirmation', with: 'edit_password'
        click_button 'Save changes'
      end

      it '更新したユーザーのProfile Pageにリダイレクトすること' do
        edit_user = User.find_by(email: 'edit_test@example.com')
        expect(current_path).to eq(user_path(edit_user))
      end

      it "'Profile updated'と表示されること" do
        expect(page).to have_content('Profile updated')
      end
    end

    context '無効な入力情報が複数(4つ)の時' do
      before do
        fill_in 'Name', with: ''
        fill_in 'Email', with: ''
        fill_in 'Password', with: 'edit_password'
        fill_in 'Confirmation', with: 'password'
        click_button 'Save changes'
      end

      it "'The form contains 4 errors.'と表示されること" do
        expect(page).to have_selector('div.alert.alert-danger', text: 'The form contains 4 errors.')
      end
    end
  end
end
