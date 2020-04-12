require 'rails_helper'

RSpec.describe 'Sessions' , type: :request do
  let!(:user) { create(:user) }
  before { get signin_path }

  describe '#create' do
    context '有効な入力情報の時' do
      it 'サインインできること' do
        valid_sign_in(signin_path)
        expect(response).to redirect_to user
        expect(is_signed_in?).to be_truthy
      end
    end

    context '無効な入力情報の時' do
      it 'サインインできないこと' do
        invalid_sign_in(signin_path)
        expect(response).to render_template('sessions/new')
        expect(is_signed_in?).to be_falsey
      end
    end
  end

  describe '#destroy' do
    context '有効な情報でログインしてからサインアウトする時' do
      it 'サインアウトできること' do
        valid_sign_in(signin_path)
        expect(is_signed_in?).to be_truthy
        expect(response).to redirect_to user
        delete signout_path
        expect(is_signed_in?).to be_falsey
        expect(response).to redirect_to root_url
      end
    end
  end
end
