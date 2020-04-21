require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#create' do
    before { get signup_path }

    context '有効な入力情報の時' do
      it 'サインアップできること' do
        expect { sign_up(users_path) }.to change(User, :count).by(1)
        follow_redirect!
        expect(response).to render_template('users/show')
        expect(is_signed_in?).to be_truthy
      end
    end

    context '無効な入力情報の時' do
      it 'サインアップできないこと' do
        expect { sign_up(users_path, confirmation: 'invalid') }.to change(User, :count).by(0)
        expect(response).to render_template('users/new')
        expect(is_signed_in?).to be_falsey
      end
    end
  end

  describe '#show' do
    context 'ユーザーが存在する時' do
      let!(:user) { create(:user) }
      before { get user_path(user) }

      it '200 OKを返すこと' do
        get user_path(user)
        expect(response.status).to eq(200)
      end
    end

    context 'ユーザーが存在しない時' do
      it 'ActiveRecord::RecordNotFoundを返すこと' do
        expect { get user_path(1) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#index' do
    let!(:list_user) { create_list(:list_user, 31) }

    describe '#logged_in_user' do
      context 'サインイン済みの時' do
        before { sign_in(signin_path, email: 'test1@example.com') }

        it 'Usersページに30番目のユーザーが取得でき、31番目のユーザーが取得できないこと' do
          get users_path
          # 200 OKを返すこと
          expect(response.status).to eq(200)

          # 30番目のユーザーが取得できること
          expect(response.body).to include('Test User30')

          # 31番目のユーザーが取得できないこと
          expect(response.body).not_to include('Test User31')
        end
      end

      context '未サインインの時' do
        let!(:user) { create(:user) }
        before { get users_path }

        it '/signinにリダイレクトされること' do
          expect(response).to redirect_to signin_url
        end

        context 'リダイレクト後にサインインした時' do
          it 'Users Pageにリダイレクトされること' do
            sign_in(signin_path)
            expect(response).to redirect_to users_path
          end
        end

        context '次回以降のサインインの時' do
          it 'Profile Pageにリダイレクトされること' do
            sign_in(signin_path)
            delete signout_path
            sign_in(signin_path)
            expect(response).to redirect_to user
          end
        end
      end
    end
  end

  describe '#edit' do
    let!(:user) { create(:user) }

    describe '#logged_in_user' do
      context 'サインイン済みの時' do
        before { sign_in(signin_path) }

        # correct_user
        context '自身のEdit Pageにリクエストを送った時' do
          it '200 OKを返すこと' do
            get edit_user_path(user)
            expect(response.status).to eq(200)
          end
        end

        context '他ユーザーのEdit Pageにリクエストを送った時' do
          let!(:another) { create(:user, name: 'Another', email: 'another@example.com') }
          it 'Home Pageにリダイレクトされること' do
            another_user = User.find_by(email: 'another@example.com')
            get edit_user_path(another_user)
            expect(response).to redirect_to root_url
          end
        end
      end

      context '未サインインの時' do
        before { get edit_user_path(user) }

        it '/signinにリダイレクトされること' do
          expect(response).to redirect_to signin_url
        end

        context 'リダイレクト後にサインインした時' do
          it '自身のEdit Pageにリダイレクトされること' do
            sign_in(signin_path)
            expect(response).to redirect_to edit_user_path(user)
          end
        end

        context '次回以降のサインインの時' do
          it 'Profile Pageにリダイレクトされること' do
            sign_in(signin_path)
            delete signout_path
            sign_in(signin_path)
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
        before { sign_in(signin_path) }

        # correct_user
        context '自身のユーザー情報を更新しようとした時' do
          context '有効な入力情報の時' do
            let(:name) { 'Edit User' }
            let(:email) { 'edit_test@example.com' }

            context '全て入力した時' do
              it 'ユーザー情報が更新されること' do
                update_user(user_path(user), name: name, email: email)
                user.reload
                expect(user.name).to eq(name)
                expect(user.email).to eq(email)
              end
            end

            context 'password, password_confirmaitonを空にした時' do
              it 'ユーザー情報が更新されること' do
                update_user(user_path(user),
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
              update_user(user_path(user), confirmation: 'invalid')
              expect(response).to render_template('users/edit')
            end
          end

          context "一般ユーザーが'admin'属性を更新しようとした時" do
            it '更新できないこと' do
              patch user_path(user), params: { user: { name: user.name,
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
            update_user(user_path(another_user), name: 'Another Edit')
            expect(response).to redirect_to root_url
          end
        end
      end

      context '未サインインの時' do
        it '/signinにリダイレクトされること' do
          response_without_sign_in = update_user(user_path(user))
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
          before { sign_in(signin_path) }
          it 'ユーザーが削除できること' do
            # ユーザー数が-1になること
            expect { delete user_path(another) }.to change(User, :count).by(-1)
            # Users Pageにリダイレクトされること
            expect(response).to redirect_to users_path
          end
        end

        context 'ユーザーがadminでない時' do
          before { sign_in(signin_path, email: 'another@example.com') }

          it 'ユーザーを削除できないこと' do
            # ユーザー数が変化しないこと
            expect { delete user_path(user) }.to change(User, :count).by(0)
            # Home Pageにリダイレクトされること
            expect(response).to redirect_to root_url
          end
        end
      end

      context '未サインインの時' do
        before { delete user_path(user) }
        it '/signinにリダイレクトされること' do
          expect(response).to redirect_to signin_url
        end
      end
    end
  end
end
