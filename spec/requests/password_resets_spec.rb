require 'rails_helper'

RSpec.describe 'PasswordReset', type: :request do
  let!(:user) { create(:user) }

  describe '#create' do
    context 'メールアドレスが無効な時' do
      it "'password_resets/new'が再描画されること" do
        reset_password(password_resets_url, email: '')
        expect(response).to render_template('password_resets/new')
      end
    end

    context 'メールアドレスが有効な時' do
      it 'Home Pageにリダイレクトされること' do
        reset_password(password_resets_url, email: user.email)
        expect(response).to redirect_to root_url
      end
    end
  end

  describe '#edit' do
    context 'メールアドレスが無効な時' do
      it 'Home Pageにリダイレクトされること' do
        reset_password(password_resets_url, email: user.email)
        user = assigns(:user)
        get edit_password_reset_url(user.reset_token, email: '')
        expect(response).to redirect_to root_url
      end
    end

    context 'メールアドレスが有効な時' do
      context 'アカウントが無効な時' do
        before { user.toggle!(:activated) }

        it 'Home Pageにリダイレクトされること' do
          reset_password(password_resets_url, email: user.email)
          user = assigns(:user)
          get edit_password_reset_url(user.reset_token, email: user.email)
          expect(response).to redirect_to root_url
        end
      end

      context 'アカウントが有効な時' do
        before { reset_password(password_resets_url, email: user.email) }

        context 'reset_tokenが無効な時' do
          it 'Home Pageにリダイレクトされること' do
            user = assigns(:user)
            get edit_password_reset_url('wrong token', email: user.email)
            expect(response).to redirect_to root_url
          end
        end

        context 'reset_tokenが有効な時' do
          context 'パスワード再設定が期限切れの時' do
            it "'password_resets/new'にリダイレクトされること" do
              user = assigns(:user)
              expired_time = user.reset_sent_at - 2.hours
              user.update(reset_sent_at: expired_time)
              user.reload
              get edit_password_reset_url(user.reset_token, email: user.email)
              expect(response).to redirect_to new_password_reset_url
            end
          end

          context 'パスワード再設定が期限切れでない時' do
            it 'Reset password Pageに遷移すること' do
              user = assigns(:user)
              get edit_password_reset_url(user.reset_token, email: user.email)

              # 200 OKを返すこと
              expect(response.status).to eq(200)

              # password_resets/editが表示されること
              expect(response).to render_template('password_resets/edit')
            end
          end
        end
      end
    end
  end

  describe '#update' do
    context 'メールアドレスが無効な時' do
      it 'Home Pageにリダイレクトされること' do
        reset_password(password_resets_url, email: user.email)
        user = assigns(:user)
        update_password(password_reset_url(user.reset_token), email: '')
        expect(response).to redirect_to root_url
      end
    end

    context 'メールアドレスが有効な時' do
      context 'アカウントが無効な時' do
        before { user.toggle!(:activated) }

        it 'Home Pageにリダイレクトされること' do
          reset_password(password_resets_url, email: user.email)
          user = assigns(:user)
          update_password(password_reset_url(user.reset_token), email: user.email)
          expect(response).to redirect_to root_url
        end
      end

      context 'アカウントが有効な時' do
        before { reset_password(password_resets_url, email: user.email) }

        context 'reset_tokenが無効な時' do
          it 'Home Pageにリダイレクトされること' do
            user = assigns(:user)
            update_password(password_reset_url('wrong token'), email: user.email)
            expect(response).to redirect_to root_url
          end
        end

        context 'reset_tokenが有効な時' do
          context 'パスワード再設定が期限切れの時' do
            it "'password_resets/new'にリダイレクトされること" do
              user = assigns(:user)
              expired_time = user.reset_sent_at - 2.hours
              user.update(reset_sent_at: expired_time)
              user.reload
              update_password(password_reset_url(user.reset_token), email: user.email)
              expect(response).to redirect_to new_password_reset_url
            end
          end

          context 'パスワード再設定が期限切れでない時' do
            context 'passwordが空の時' do
              it "'password_resets/edit'が再描画されること" do
                user = assigns(:user)
                update_password(password_reset_url(user.reset_token), email: user.email, password: '')
                expect(response).to render_template('password_resets/edit')
              end
            end

            context 'password_confirmationが空の時' do
              it "'password_resets/edit'が再描画されること" do
                user = assigns(:user)
                update_password(password_reset_url(user.reset_token), email: user.email, confirmation: '')
                expect(response).to render_template('password_resets/edit')
              end
            end

            context 'password, password_confirmationが有効な時' do
              it 'Profile Pageにリダイレクトされること' do
                user = assigns(:user)
                update_password(password_reset_url(user.reset_token), email: user.email)

                # サインインすること
                expect(is_signed_in?).to be_truthy

                # Profile Pageにリダイレクトされること
                expect(response).to redirect_to user
              end
            end
          end
        end
      end
    end
  end
end
