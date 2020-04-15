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

  describe '#edit' do
    let!(:user) { create(:user) }

    describe '#logged_in_user' do
      context 'サインイン済みの時' do
        before { sign_in(signin_path) }

        it '自身のEdit Pageに遷移できること' do
          get edit_user_path(user)
          expect(response.status).to eq(200)
        end
      end

      context 'サインインしていない時' do
        before { get edit_user_path(user) }

        it '/signinにリダイレクトされること' do
          expect(response).to redirect_to signin_url
        end

        context 'リダイレクト後にサインインした時' do
          it '自身のEdit Pageに遷移できること' do
            expect(sign_in(signin_path)).to redirect_to edit_user_path(user)
          end

          context '次回以降のサインインの時' do
            it '自身のProfile Pageにリダイレクトされること' do
              sign_in(signin_path)
              delete signout_path
              expect(sign_in(signin_path)).to redirect_to user
            end
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
              update_user(user_path(user), name: name, email: email, password: '', confirmation: '')
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
      end

      context 'サインインしていない時' do
        it '/signinにリダイレクトされること' do
          response_without_sign_in = update_user(user_path(user))
          expect(response_without_sign_in).to redirect_to signin_url
        end
      end
    end
  end

  describe '#correct_user' do
    let!(:user) { create(:user) }
    let!(:another) { create(:another) }
    before { sign_in(signin_path) }

    describe '#edit' do
      context '他ユーザーのEdit Pageにリクエストを送った時' do

        it 'Home Pageにリダイレクトされること' do
          another_user = User.find_by(email: 'another@example.com')
          get edit_user_path(another_user)
          expect(response).to redirect_to root_url
        end
      end
    end

    describe '#update' do
      context '他ユーザーの情報を更新しようとした時' do
        it 'Home Pageにリダイレクトされること' do
          another_user = User.find_by(email: 'another@example.com')
          update_user(user_path(another_user), name: 'Another Edit User')
          expect(response).to redirect_to root_url
        end
      end
    end
  end
end
