require 'rails_helper'

RSpec.describe 'User signout', type: :request do
  example "login with valid information followed by signout" do
    user = create(:user)
    get signin_path
    post signin_path, params: { session: { email: 'testuser1@example.com',
                                           password: 'testuser1'} }
    expect(is_logged_in?).to be_truthy
    expect(response).to redirect_to user
    delete signout_path
    expect(is_logged_in?).to be_falsey
    expect(response).to redirect_to root_url
  end
end
