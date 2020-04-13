require 'rails_helper'

RSpec.describe 'AuthenticationPages', type: :system do
  let!(:user) { create(:user) }
  before { visit signin_path }

  describe '/signin' do
    context '初期表示' do
      it "'Sign in'と表示されること" do
        expect(page).to have_content('Sign in')
      end

      it "ページタイトルに'Sign in'と表示されること" do
        expect(page).to have_title('Sign in')
      end

      it '[Profile]リンクが表示されないこと' do
        expect(page).not_to have_link('Profile', href: user_path(user))
      end

      it '[Sign out]リンクが表示されないこと' do
        expect(page).not_to have_link('Sign out', href: signout_path)
      end
    end

    context '無効な入力情報の時' do
      before { click_button 'Sign in' }

      it "'Invalid email/password combination'と表示されること" do
        expect(page).to have_selector('div.alert.alert-danger',
                                      text: 'Invalid email/password combination')
      end

      context '他のページに遷移した時' do
        before { click_link 'Home' }

        it "'Invalid email/password combination'と表示されないこと" do
          expect(page).not_to have_selector('div.alert.alert-danger')
        end
      end
    end

    context '有効な入力情報の時' do
      before do
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'password'
        click_button 'Sign in'
      end

      it 'ページタイトルにユーザー名が表示されること' do
        expect(page).to have_title(user.name)
      end

      it '[Profile]リンクが表示されること' do
        expect(page).to have_link('Profile', href: user_path(user))
      end

      it '[Sign out]リンクが表示されること' do
        expect(page).to have_link('Sign out', href: signout_path)
      end

      it '[Sign in]リンクが表示されないこと' do
        expect(page).not_to have_link('Sign in', href: signin_path)
      end
    end

    describe '/signout' do
      before do
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'password'
        click_button 'Sign in'
      end

      context "[Sign out]リンクを押下した時" do
        before { click_link 'Sign out' }

        it 'ページタイトルがデフォルト表示になること' do
          expect(page).to have_title(full_title(''))
        end

        it '[Profile]リンクが表示されないこと' do
          expect(page).not_to have_link('Profile', href: user_path(user))
        end

        it '[Sign out]リンクが表示されないこと' do
          expect(page).not_to have_link('Sign out', href: signout_path)
        end

        it '[Sign in]リンクが表示されること' do
          expect(page).to have_link('Sign in', href: signin_path)
        end
      end
    end
  end
end
