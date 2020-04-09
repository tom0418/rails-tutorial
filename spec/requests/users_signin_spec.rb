require 'rails_helper'

RSpec.describe 'Sessions#create' , type: :request do
  context '有効な入力情報の時' do
    example 'サインインできること' do
      user = create(:user)
      get signin_path
      post signin_path, params: { session: { email: 'testuser1@example.com',
                                             password: 'testuser1' } }
      expect(response).to redirect_to user
      expect(is_signed_in?).to be_truthy
    end
  end

  context '無効な入力情報の時' do
    example 'サインインできないこと' do
      get signin_path
      post signin_path, params: { session: { email: 'testuser1@example.com',
                                             password: 'invalid-password'} }
      expect(response).to render_template('sessions/new')
      expect(is_signed_in?).to be_falsey
    end
  end
end
