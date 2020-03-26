require 'rails_helper'

RSpec.describe 'User pages', type: :request do
  subject { page }

  describe 'Signup page' do
    before { visit signup_path }

    it { is_expected.to have_content('Sign up') }
    it { is_expected.to have_title(full_title('Sign up')) }
  end
end
