require 'rails_helper'

RSpec.describe 'User pages', type: :system do
  describe 'Profile page' do
    context 'Profile Pageにアクセスした時' do
      let!(:user) { create(:user) }
      before { visit user_path(user) }
      it 'ユーザー名が表示されること' do
        expect(page).to have_content(user.name)
      end

      it 'ページタイトルにユーザー名が表示されること' do
        expect(page).to have_title(user.name)
      end
    end
  end

  describe 'User Edit Page' do
    let!(:user) { create(:user) }
    context 'サインイン済みかつ正しいユーザーの時' do
      before do
        visit signin_path
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'password'
        click_button 'Sign in'
        visit edit_user_path(user)
      end

      context 'User Edit Pageに遷移した時' do
        it "'Update your profile'と表示されること" do
          expect(page).to have_content('Update your profile')
        end

        it "ページタイトルに'Edit User'と表示されること" do
          expect(page).to have_title('Edit User')
        end
      end

      context '有効な入力情報の時' do
        before do
          fill_in 'Name', with: 'Edit User'
          fill_in 'Email', with: 'edit_test@example.com'
          fill_in 'Password', with: 'edit_password'
          fill_in 'Confirmation', with: 'edit_password'
          click_button 'Save changes'
          user.reload
        end

        it '更新したユーザーのProfile Pageにリダイレクトすること' do
          edit_user = User.find_by(email: 'edit_test@example.com')
          expect(current_path).to eq(user_path(edit_user))
        end

        it "'Profile updated'と表示されること" do
          expect(page).to have_content('Profile updated')
        end

        it '更新後のユーザー名が表示されること' do
          expect(page).to have_content(user.name)
        end

        it 'ページタイトルに更新後のユーザー名が表示されること' do
          expect(page).to have_title(user.name)
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

  describe 'Users Page' do
    let!(:user) { create(:user, admin: 1) }
    let!(:another) { create(:user, email: 'another@example.com', admin: 0) }
    before { visit signin_path }

    context 'サインイン済みの時' do
      context 'admin権限のユーザーでサインイン済みの時' do
        before do
          fill_in 'Email', with: 'test@example.com'
          fill_in 'Password', with: 'password'
          click_button 'Sign in'
          visit users_path
        end

        it "'All users'と表示されること" do
          expect(page).to have_content('All users')
        end

        it "ページタイトルに'All users'と表示されること" do
          expect(page).to have_title('All users')
        end

        it '[delete]リンクが表示されること' do
          expect(page).to have_link('delete')
        end
      end

      context '一般ユーザーでサインイン済みの時' do
        before do
          fill_in 'Email', with: 'another@example.com'
          fill_in 'Password', with: 'password'
          click_button 'Sign in'
          visit users_path
        end

        it '[delete]リンクが表示されないこと' do
          expect(page).not_to have_link('delete')
        end
      end
    end
  end
end
