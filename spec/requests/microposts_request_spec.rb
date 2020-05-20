require 'rails_helper'

RSpec.describe 'Microposts', type: :request do
  let!(:user) { create(:user, :with_default_microposts) }
  let!(:another) { create(:user, :with_default_microposts, name: 'Another User', email: 'another@example.com') }

  describe '#create' do
    context '未サインインの時' do
      it '/signinにリダイレクトされること' do
        # Micropostsテーブルにレコードが追加されないこと
        expect { post_microposts(microposts_url) }.to change(Micropost, :count).by(0)

        # /signinにリダイレクトされること
        expect(response).to redirect_to signin_url
      end
    end

    context 'サインイン済みの時' do
      before { sign_in(signin_url) }
      it 'micropostを新規作成できること' do
        # Micropostsテーブルにレコードが1件追加されること
        expect { post_microposts(microposts_url) }.to change(Micropost, :count).by(1)

        # Home Pageにリダイレクトされること
        expect(response).to redirect_to root_url
      end

      context '画像をアップロードする時' do
        let(:image_path) { Rails.root.join('spec/fixtures/rails.png') }
        let(:image) { Rack::Test::UploadedFile.new(image_path) }

        it 'アップロードできること' do
          expect(post_microposts(microposts_url, picture: image)).to eq(302)
        end
      end
    end
  end

  describe '#destroy' do
    context '未サインインの時' do
      it '/signinにリダイレクトされること' do
        micropost = user.microposts.last
        delete micropost_url(micropost)
        expect(response).to redirect_to signin_url
      end
    end

    context 'サインイン済みの時' do
      before { sign_in(signin_url) }

      context '自身のmicropostの時' do
        it '削除できること' do
          micropost = user.microposts.last

          # Micropostsテーブルのレコードが1件削除されること
          expect { delete micropost_url(micropost) }.to change(Micropost, :count).by(-1)
        end
      end

      context '他のユーザーのmicropostの時' do
        it '削除できないこと' do
          another_micropost = Micropost.find_by(user_id: another.id)

          # Micropostsテーブルのレコード数が変化しないこと
          expect { delete micropost_url(another_micropost) }.to change(Micropost, :count).by(0)

          # Home Pageにリダイレクトされること
          expect(response).to redirect_to root_url
        end
      end
    end
  end
end
