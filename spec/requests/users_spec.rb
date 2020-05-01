require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#create' do
    describe '有効な入力情報' do
      describe '共通処理' do
        ActionMailer::Base.deliveries.clear

        it 'Usersテーブルにレコードが1件追加されること' do
          # Usersテーブルにレコードが1件追加されること
          expect { sign_up(users_url) }.to change(User, :count).by(1)

          # アカウント有効化メールが1件送信されること
          expect(ActionMailer::Base.deliveries.size).to eq(1)

          # Home Pageにリダイレクトされること
          expect(response).to redirect_to root_url

          # 未サインインであること
          expect(is_signed_in?).to be_falsey
        end

        describe 'アカウント有効化' do
          before { sign_up(users_url) }
          let!(:user) { assigns(:user) }

          context '有効化トークンが不正な場合' do
            it 'サインインできないこと' do
              get edit_account_activation_url('invalid token', email: user.email)
              expect(is_signed_in?).to be_falsey
            end
          end

          context '有効化トークンは正しいがメールアドレスが無効な場合' do
            it 'サインインできないこと' do
              get edit_account_activation_url(user.activation_token, email: 'wrong')
              expect(is_signed_in?).to be_falsey
            end
          end

          context '有効化トークン、メールアドレスともに正しい場合' do
            it 'サインインできること' do
              get edit_account_activation_url(user.activation_token, email: user.email)

              # ユーザーが有効化されること
              expect(user.reload.activated?).to be_truthy

              # サインインできること
              expect(is_signed_in?).to be_truthy

              # Profile Pageにリダイレクトされること
              expect(response).to redirect_to user
            end
          end
        end
      end
    end

    describe '無効な入力情報' do
      it 'Usersテーブルにレコードが追加されないこと' do
        # Usersテーブルにレコードが追加されないこと
        expect { sign_up(users_url, confirmation: 'invalid') }.to change(User, :count).by(0)

        # Signup Pageが再描画されること
        expect(response).to render_template('users/new')

        # サインアップできないこと
        expect(is_signed_in?).to be_falsey
      end
    end
  end

  describe '#index' do
    describe '#logged_in_user' do
      context 'サインイン済みの時' do
        let!(:list_user) { create_list(:list_user, 31) }
        before { sign_in(signin_url, email: 'test1@example.com') }

        it 'Usersページに30番目のユーザーが取得でき、31番目のユーザーが取得できないこと' do
          get users_url
          # 200 OKを返すこと
          expect(response.status).to eq(200)

          # 30番目のユーザーが取得できること
          expect(response.body).to include('Test User30')

          # 31番目のユーザーが取得できないこと
          expect(response.body).not_to include('Test User31')
        end
      end

      context '有効化されていないユーザーが存在する時' do
        let!(:user) { create(:user) }
        deactivated_params = { name: 'Deactivated', email: 'deactivated@example.com', activated: 0, activated_at: nil }
        let!(:deactivated_user) { create(:user, deactivated_params) }
        before { sign_in(signin_url) }

        it '有効化されていないユーザーが取得できないこと' do
          get users_url
          # 200 OKを返すこと
          expect(response.status).to eq(200)

          # 有効化されていないユーザーが取得できないこと
          expect(response.body).not_to include('Deactivated')

          # 有効化されているユーザーが取得できること
          expect(response.body).to include('Test User')
        end
      end

      context '未サインインの時' do
        let!(:user) { create(:user) }
        before { get users_url }

        it '/signinにリダイレクトされること' do
          expect(response).to redirect_to signin_url
        end

        context 'リダイレクト後にサインインした時' do
          it 'Users Pageにリダイレクトされること' do
            sign_in(signin_url)
            expect(response).to redirect_to users_url
          end
        end

        context '次回以降のサインインの時' do
          it 'Profile Pageにリダイレクトされること' do
            sign_in(signin_url)
            delete signout_url
            sign_in(signin_url)
            expect(response).to redirect_to user
          end
        end
      end
    end
  end

  describe '#show' do
    context 'ユーザーが存在する時' do
      context 'ユーザーが有効化されている時' do
        let!(:user) { create(:user) }
        before { get user_url(user) }

        it '200 OKを返すこと' do
          expect(response.status).to eq(200)
        end

        it 'Profile Pageにリダイレクトすること' do
          expect(response).to render_template('users/show')
        end
      end

      context 'ユーザーが有効化されていない時' do
        deactivated_params = { activated: 0, activated_at: nil }
        let!(:deactivated_user) { create(:user, deactivated_params) }
        before { get user_url(deactivated_user) }

        it '200 OKを返すこと' do
          get user_url(deactivated_user)
        end

        it 'Home Pageにリダイレクトされること' do
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'ユーザーが存在しない時' do
      it 'ActiveRecord::RecordNotFoundを返すこと' do
        expect { get user_url(0) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#edit' do
    let!(:user) { create(:user) }

    describe '#logged_in_user' do
      context 'サインイン済みの時' do
        before { sign_in(signin_url) }

        # correct_user
        context '自身のEdit Pageにリクエストを送った時' do
          it '200 OKを返すこと' do
            get edit_user_url(user)
            expect(response.status).to eq(200)
          end
        end

        context '他ユーザーのEdit Pageにリクエストを送った時' do
          let!(:another) { create(:user, name: 'Another', email: 'another@example.com') }
          it 'Home Pageにリダイレクトされること' do
            another_user = User.find_by(email: 'another@example.com')
            get edit_user_url(another_user)
            expect(response).to redirect_to root_url
          end
        end
      end

      context '未サインインの時' do
        before { get edit_user_url(user) }

        it '/signinにリダイレクトされること' do
          expect(response).to redirect_to signin_url
        end

        context 'リダイレクト後にサインインした時' do
          it '自身のEdit Pageにリダイレクトされること' do
            sign_in(signin_url)
            expect(response).to redirect_to edit_user_url(user)
          end
        end

        context '次回以降のサインインの時' do
          it 'Profile Pageにリダイレクトされること' do
            sign_in(signin_url)
            delete signout_url
            sign_in(signin_url)
            expect(response).to redirect_to user
          end
        end
      end
    end
  end

  describe '#update' do
    let!(:user) { create(:user) }

    describe '#logged_in_user' do
      context 'サインイン済みの時' do
        before { sign_in(signin_url) }

        # correct_user
        context '自身のユーザー情報を更新しようとした時' do
          context '有効な入力情報の時' do
            let(:name) { 'Edit User' }
            let(:email) { 'edit_test@example.com' }

            context '全て入力した時' do
              it 'ユーザー情報が更新されること' do
                update_user(user_url(user), name: name, email: email)
                user.reload
                expect(user.name).to eq(name)
                expect(user.email).to eq(email)
              end
            end

            context 'password, password_confirmaitonを空にした時' do
              it 'ユーザー情報が更新されること' do
                update_user(user_url(user),
                            name: name,
                            email: email,
                            password: '',
                            confirmation: '')
                user.reload
                expect(user.name).to eq(name)
                expect(user.email).to eq(email)
              end
            end
          end

          context '無効な入力情報の時' do
            it '/users/edit/:idが再描画されること' do
              update_user(user_url(user), confirmation: 'invalid')
              expect(response).to render_template('users/edit')
            end
          end

          context "一般ユーザーが'admin'属性を更新しようとした時" do
            it '更新できないこと' do
              patch user_url(user), params: { user: { name: user.name,
                                                      email: user.email,
                                                      admin: 1 } }
              user.reload
              expect(user.admin?).to be_falsey
            end
          end
        end

        context '他ユーザーの情報を更新しようとした時' do
          let!(:another) { create(:user, name: 'Another', email: 'another@example.com') }
          it 'Home Pageにリダイレクトされること' do
            another_user = User.find_by(email: 'another@example.com')
            update_user(user_url(another_user), name: 'Another Edit')
            expect(response).to redirect_to root_url
          end
        end
      end

      context '未サインインの時' do
        it '/signinにリダイレクトされること' do
          response_without_sign_in = update_user(user_url(user))
          expect(response_without_sign_in).to redirect_to signin_url
        end
      end
    end
  end

  describe '#destroy' do
    let!(:user) { create(:user, admin: 1) }
    let!(:another) { create(:user, name: 'Another', email: 'another@example.com', admin: 0) }

    describe '#logged_in_user' do
      context 'サインイン済みの時' do
        context 'ユーザーがadminの時' do
          before { sign_in(signin_url) }
          it 'ユーザーが削除できること' do
            # ユーザー数が-1になること
            expect { delete user_url(another) }.to change(User, :count).by(-1)
            # Users Pageにリダイレクトされること
            expect(response).to redirect_to users_url
          end
        end

        context 'ユーザーがadminでない時' do
          before { sign_in(signin_url, email: 'another@example.com') }

          it 'ユーザーを削除できないこと' do
            # ユーザー数が変化しないこと
            expect { delete user_url(user) }.to change(User, :count).by(0)
            # Home Pageにリダイレクトされること
            expect(response).to redirect_to root_url
          end
        end
      end

      context '未サインインの時' do
        before { delete user_url(user) }
        it '/signinにリダイレクトされること' do
          expect(response).to redirect_to signin_url
        end
      end
    end
  end
end
