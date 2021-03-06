require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { build(:user) }

  describe '属性' do
    it 'name' do
      expect(user).to respond_to(:name)
    end

    it 'email' do
      expect(user).to respond_to(:email)
    end

    it 'password_digest' do
      expect(user).to respond_to(:password_digest)
    end

    it 'password' do
      expect(user).to respond_to(:password)
    end

    it 'password_confirmation' do
      expect(user).to respond_to(:password_confirmation)
    end

    it 'remember_digest' do
      expect(user).to respond_to(:remember_digest)
    end

    it 'remember_token' do
      expect(user).to respond_to(:remember_token)
    end

    it 'activation_token' do
      expect(user).to respond_to(:activation_token)
    end

    it 'reset_token' do
      expect(user).to respond_to(:reset_token)
    end
  end

  describe 'アソシエーション' do
    context 'microposts' do
      let!(:user) { create(:user, :with_default_microposts) }
      it 'micropostsメソッドが使えること' do
        expect(user).to respond_to(:microposts)
      end

      it 'ユーザーを削除した時、micropostも削除されること' do
        expect { user.destroy }.to change(Micropost, :count).by(-1)
      end
    end

    context 'relationships' do
      before { user.save }
      let!(:other_user) { create(:user, name: 'Other User', email: 'test-other@example.com') }
      before { Relationship.create(follower_id: user.id, followed_id: other_user.id) }

      it 'active_relationshipsメソッドが使えること' do
        expect(user).to respond_to(:active_relationships)
      end

      it 'passive_relationshipsメソッドが使えること' do
        expect(user).to respond_to(:passive_relationships)
      end

      context 'フォロー中のユーザーを削除した時' do
        it 'Relationshipsテーブルのレコードが1件削除されること' do
          expect { other_user.destroy }.to change(Relationship, :count).by(-1)
        end

        it 'フォロー中のユーザーから該当ユーザーが削除されること' do
          other_user.destroy
          expect(user.following.include?(other_user)).to be_falsey
        end
      end

      context 'フォロワーを削除した時' do
        it 'Relationshipsテーブルのレコードが1件削除されること' do
          expect { user.destroy }.to change(Relationship, :count).by(-1)
        end

        it 'フォロワーから該当ユーザーが削除されること' do
          user.destroy
          expect(other_user.followers.include?(user)).to be_falsey
        end
      end
    end

    context 'following' do
      it 'followingメソッドが使えること' do
        expect(user).to respond_to(:following)
      end
    end

    context 'followers' do
      it 'followersメソッドが使えること' do
        expect(user).to respond_to(:followers)
      end
    end
  end

  describe 'インスタンスメソッド' do
    it '#authenticate' do
      expect(user).to respond_to(:authenticate)
    end

    it '#remember' do
      expect(user).to respond_to(:remember)
    end

    it '#authenticated?' do
      expect(user).to respond_to(:authenticated?)
    end

    it '#forget' do
      expect(user).to respond_to(:forget)
    end

    it '#activate' do
      expect(user).to respond_to(:activate)
    end

    it '#send_activation_email' do
      expect(user).to respond_to(:send_activation_email)
    end

    it '#create_reset_digest' do
      expect(user).to respond_to(:create_reset_digest)
    end

    it '#send_password_reset_email' do
      expect(user).to respond_to(:send_password_reset_email)
    end

    it '#password_reset_expired?' do
      expect(user).to respond_to(:password_reset_expired?)
    end

    it '#following?' do
      expect(user).to respond_to(:following?)
    end

    it '#follow' do
      expect(user).to respond_to(:follow)
    end

    it '#unfollow' do
      expect(user).to respond_to(:unfollow)
    end
  end

  describe 'バリデーション' do
    describe 'name' do
      context '空の時' do
        before { user.name = '' }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end

      context '空白文字の時' do
        before { user.name = ' ' * 10 }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end

      context 'nilの時' do
        before { user.name = nil }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end

      context '51バイト以上の時' do
        before { user.name = 'a' * 51 }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end
    end

    describe 'email' do
      context '空の時' do
        before { user.email = '' }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end

      context 'nilの時' do
        before { user.email = nil }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end

      context '256バイト以上の時' do
        before { user.email = 'a' * 244 + '@example.com' }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end

      context '無効なフォーマットの時' do
        invalid_addresses = %w[
          user@foo,com
          user_at_foo.org
          it.user@foo.foo@bar.com
          foo@bar+baz.com
          foo@bar..com
        ]
        it '無効であること' do
          invalid_addresses.each do |invalid_address|
            user.email = invalid_address
            expect(user).to be_invalid
          end
        end
      end

      context '有効なフォーマットの時' do
        valid_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        it '有効であること' do
          valid_addresses.each do |valid_address|
            user.email = valid_address
            expect(user).to be_valid
          end
        end
      end

      context '既に存在する時' do
        before do
          user_with_same_email = user.dup
          user_with_same_email.email = user.email.upcase
          user_with_same_email.save
        end
        it '無効であること' do
          expect(user).to be_invalid
        end
      end
    end

    describe 'password_digest' do
      context '空の時' do
        before { user.password = user.password_confirmation = '' }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end

      context 'passwordとpassword_confirmationが一致しない時' do
        before { user.password_confirmation = '' }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end
    end

    describe 'password' do
      context '空文字の時' do
        before { user.password = user.password_confirmation = ' ' * 6 }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end

      context '5文字以下の時' do
        before { user.password = user.password_confirmation = 'a' * 5 }
        it '無効であること' do
          expect(user).to be_invalid
        end
      end
    end
  end

  describe '#authenticateの戻り値' do
    before { user.save }
    let(:found_user) { User.find_by(email: user.email) }

    context '有効なパスワードの時' do
      it '該当のユーザーが返されること' do
        expect(user).to eq(found_user.authenticate(user.password))
      end
    end

    context '無効なパスワードの時' do
      it 'ユーザーが取得できないこと' do
        expect(user).not_to eq(found_user.authenticate('invalid'))
      end

      specify 'falseが返されること' do
        expect(found_user.authenticate('invalid')).to be_falsey
      end
    end
  end

  describe '#authenticated?の戻り値' do
    before { user.save }
    context 'remember_digestがnilの時' do
      specify 'falseが返されること' do
        expect(user.authenticated?(:remember, ''))
      end
    end
  end

  describe '#follow, #unfollow, #following?の動作' do
    before { user.save }
    let!(:other_user) { create(:user, name: 'Other User', email: 'test-other@example.com') }

    context 'フォロー中のユーザーが存在しない時' do
      it '#following?がfalseを返すこと' do
        expect(user.following?(other_user)).to be_falsey
      end
    end

    context '他のユーザーをフォローした時' do
      it '#following?がtrueを返すこと' do
        user.follow(other_user)
        expect(user.following?(other_user)).to be_truthy
      end
    end

    context 'フォロー解除した時' do
      it '#following?がfalseを返すこと' do
        user.follow(other_user)
        user.unfollow(other_user)
        expect(user.following?(other_user)).to be_falsey
      end
    end
  end
end
