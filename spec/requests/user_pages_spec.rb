require 'rails_helper'

RSpec.describe 'User pages', type: :request do
  subject { page }

  describe 'Profile page' do
    let(:user) { FactoryBot.create(:user) }
    before { visit user_path(user) }

    it { is_expected.to have_content(user.name) }
    it { is_expected.to have_title(user.name) }
  end
end
