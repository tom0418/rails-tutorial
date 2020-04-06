require 'rails_helper'

RSpec.describe 'User sign in' , type: :request do
  example 'valid sign in information' do
    user = create(:user)
    get signin_path
    post signin_path, params: { session: { email: 'testuser1@example.com',
                                           password: 'testuser1' } }
    expect(response).to redirect_to user
    expect(is_logged_in?).to be_truthy
  end

  example 'invalid sign in information' do
    get signin_path
    post signin_path, params: { session: { email: 'testuser1@example.com',
                                           password: 'invalid-password'} }
    expect(response).to render_template('sessions/new')
    expect(is_logged_in?).to be_falsey
  end
end
