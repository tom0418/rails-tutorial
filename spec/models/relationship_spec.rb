require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user, name: 'Other User', email: 'test-other@example.com') }
  let!(:relationship) { Relationship.new(follower_id: user.id, followed_id: other_user.id) }

  describe 'バリデーション' do
    context 'follower_id, followed_idが正しい時' do
      it '有効であること' do
        expect(relationship).to be_valid
      end
    end

    context 'follower_idが設定されていない時' do
      it '無効であること' do
        relationship.follower_id = nil
        expect(relationship).to be_invalid
      end
    end

    context 'followed_idが設定されていない時' do
      it '無効であること' do
        relationship.followed_id = nil
        expect(relationship).to be_invalid
      end
    end
  end
end
