require 'rails_helper'

RSpec.describe 'Sessions#destroy', type: :request do
  context "有効な情報でログインしてからサインアウトする時" do
    example 'サインアウトできること' do
      user = create(:user)
      get signin_path
      post signin_path, params: { session: { email: 'testuser1@example.com',
                                             password: 'testuser1'} }
      expect(is_signed_in?).to be_truthy
      expect(response).to redirect_to user
      delete signout_path
      expect(is_signed_in?).to be_falsey
      expect(response).to redirect_to root_url
    end
  end
end
