require 'rails_helper'

RSpec.describe 'Users signup', type: :request do
  context '有効な入力情報の時' do
    example 'サインアップできること' do
      get signup_path
      expect {
        post users_path, params: { user: { name: 'Example User',
                                           email: 'user@example.com',
                                           password: 'password',
                                           password_confirmation: 'password' } }
      }.to change(User, :count).by(1)
      # redirect_to @user
      follow_redirect!
      # Test
      expect(response).to render_template('users/show')
      expect(is_signed_in?).to be_truthy
    end
  end

  context '無効な入力情報の時' do
    example "サインアップできないこと" do
      get signup_path
      expect {
        post users_path, params: { user: { name: 'Invalid User',
                                           email: 'invalid@example.com',
                                           password: 'password',
                                           password_confirmation: 'invalid' } }
      }.to change(User, :count).by(0)
      expect(response).to render_template('users/new')
      expect(is_signed_in?).to be_falsey
    end
  end
end
