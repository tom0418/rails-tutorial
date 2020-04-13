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
end
