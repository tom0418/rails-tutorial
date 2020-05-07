require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let!(:user) { create(:user, activated: 0, activated_at: nil) }
    let(:mail) { UserMailer.account_activation(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Account activation')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hi')
      expect(mail.body.encoded).to match(user.name)
      expect(mail.body.encoded).to match(user.activation_token)
      user_email = CGI.escape(user.email)
      expect(mail.body.encoded).to match(user_email)
    end
  end

  describe 'password_reset' do
    let!(:user) { create(:user) }
    before { user.reset_token = User.new_token }
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Password reset')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(user.reset_token)
      user_email = CGI.escape(user.email)
      expect(mail.body.encoded).to match(user_email)
    end
  end
end
