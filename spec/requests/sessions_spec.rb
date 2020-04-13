require 'rails_helper'

RSpec.describe 'Sessions' , type: :request do
  let!(:user) { create(:user) }
  before { get signin_path }

  describe '#create' do
    context '有効な入力情報の時' do
      it 'サインインできること' do
        sign_in(signin_path, password: 'password')
        expect(response).to redirect_to user
        expect(is_signed_in?).to be_truthy
      end
    end

    context '無効な入力情報の時' do
      it 'サインインできないこと' do
        sign_in(signin_path, password: 'invalid_password')
        expect(response).to render_template('sessions/new')
        expect(is_signed_in?).to be_falsey
      end
    end

    context "'remember_me == 1'の時" do
      it "'remember_token'が空でないこと" do
        sign_in_with_remember(signin_path, remember_me: '1')
        remember_token = cookies['remember_token']
        expect(remember_token).not_to be_empty
      end
    end

    context "'remember_me == 0'の時" do
      it "'remember_token'がnilであること" do
        sign_in_with_remember(signin_path, remember_me: '0')
        remember_token = cookies['remember_token']
        expect(remember_token).to be_nil
      end
    end
  end

  describe '#destroy' do
    context '有効な情報でログインしてからサインアウトする時' do
      it 'サインアウトできること' do
        sign_in(signin_path, password: 'password')
        expect(is_signed_in?).to be_truthy
        expect(response).to redirect_to user
        delete signout_path
        expect(is_signed_in?).to be_falsey
        expect(response).to redirect_to root_url
      end
    end

    context 'ログアウト済みのユーザーの時' do
      it "Home Pageにリダイレクトされること" do
        sign_in(signin_path, password: 'password')
        delete signout_path
        follow_redirect!
        delete signout_path
        expect(is_signed_in?).to be_falsey
        expect(response).to redirect_to root_url
      end
    end
  end
end