require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user, name: 'Other User', email: 'test-other@example.com') }

  describe '#create' do
    context '未サインインの時' do
      it 'フォローできないこと' do
        # Relationshipsテーブルにレコードが追加されないこと
        expect { post relationships_url, params: { followed_id: other_user.id }, xhr: true }
          .to change(Relationship, :count).by(0)
        # サインインページにリダイレクトすること
        expect(response).to redirect_to signin_url
      end
    end

    context 'サインイン済みの時' do
      before { sign_in(signin_url) }
      it 'フォローできること' do
        # Relationshipsテーブルにレコードが1件追加されること
        expect { post relationships_url, params: { followed_id: other_user.id }, xhr: true }
          .to change(Relationship, :count).by(1)
      end
    end
  end

  describe '#destroy' do
    before { Relationship.create(follower_id: user.id, followed_id: other_user.id) }
    let!(:relationship) { Relationship.find_by(followed_id: other_user.id) }

    context '未サインインの時' do
      it 'フォロー解除できないこと' do
        # Relationshipsテーブルのレコード数が変化しないこと
        expect { delete relationship_url(relationship), xhr: true }.to change(Relationship, :count).by(0)
        # サインインページにリダイレクトすること
        expect(response).to redirect_to signin_url
      end
    end

    context 'サインイン済みの時' do
      before { sign_in(signin_url) }
      it 'フォロー解除できること' do
        # Relationshipsテーブルからレコードが1件削除されること
        expect { delete relationship_url(relationship), xhr: true }.to change(Relationship, :count).by(-1)
      end
    end
  end
end
