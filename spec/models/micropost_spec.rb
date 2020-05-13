require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:micropost) { build(:micropost) }

  describe '属性' do
    it 'content' do
      expect(micropost).to respond_to(:content)
    end

    it 'user_id' do
      expect(micropost).to respond_to(:user_id)
    end
  end

  describe 'バリデーション' do
    describe 'content' do
      context '空の時' do
        before { micropost.content = '' }
        it '無効であること' do
          expect(micropost).to be_invalid
        end
      end

      context '空文字の時' do
        before { micropost.content = ' '}
        it '無効であること' do
          expect(micropost).to be_invalid
        end
      end

      context 'nilの時' do
        before { micropost.content = nil }
        it '無効であること' do
          expect(micropost).to be_invalid
        end
      end

      context '141文字以上の時' do
        before { micropost.content = 'a' * 141 }
        it '無効であること' do
          expect(micropost).to be_invalid
        end
      end
    end

    describe 'user_id' do
      context '空の時' do
        before { micropost.user_id = '' }
        it '無効であること' do
          expect(micropost).to be_invalid
        end
      end

      context 'nilの時' do
        before { micropost.user_id = nil }
        it '無効であること' do
          expect(micropost).to be_invalid
        end
      end
    end

    describe 'デフォルトのスコープ' do
      let!(:user) { build(:user, :with_sorted_microposts) }
      context 'マイクロポストの順序付け' do
        it '最新のマイクロポストが最初に取得できること' do
          most_recent = Micropost.find_by(content: 'Most Resent')
          expect(most_recent).to eq Micropost.first
        end
      end
    end
  end
end
