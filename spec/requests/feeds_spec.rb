require 'rails_helper'

RSpec.describe 'Feeds', type: :request do
  describe '#show' do
    let!(:user) { create(:user, :with_default_microposts) }
    other_user_params = { name: 'Other User', email: 'test-other@example.com' }
    let!(:other_user) { create(:user, :with_other_user_microposts, other_user_params) }
    before { sign_in(signin_url) }

    context '他のユーザーをフォローしている時' do
      it '自身とフォローしているユーザーのマイクロポストが取得できること' do
        Relationship.create(follower_id: user.id, followed_id: other_user.id)
        get root_url
        expect(response.body).to include('Test micropost.')
        expect(response.body).to include('Test other micropost.')
      end
    end

    context '他のユーザーをフォローしていない時' do
      it 'フォローしていないユーザーのマイクロポストが取得されないこと' do
        get root_url
        expect(response.body).to include('Test micropost.')
        expect(response.body).not_to include('Test other micropost.')
      end
    end
  end
end
