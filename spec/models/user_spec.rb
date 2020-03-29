require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.build(:user) }

  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }

  it { is_expected.to be_valid }

  describe 'name' do
    describe 'when name is not present' do
      before { user.name = '' }
      it { is_expected.to be_invalid }
    end

    describe 'when name is too long' do
      before { user.name = 'a' * 51 }
      it { is_expected.to be_invalid }
    end
  end

  describe 'email' do
    describe 'when email is not present' do
      before { user.email = '' }
      it { is_expected.to be_invalid }
    end

    describe 'when email format is invalid' do
      it 'should be invalid' do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          user.email = invalid_address
          expect(user).to be_invalid
        end
      end
    end

    describe 'when email format is valid' do
      it 'should be valid' do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end

    describe 'when email address is already taken' do
      before do
        user_with_same_email = user.dup
        user_with_same_email.email = user.email.upcase
        user_with_same_email.save
      end

      it { is_expected.to be_invalid }
    end
  end
end
