require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  subject { page }

  describe 'Home Page' do
    before { visit root_path }

    it { is_expected.to have_content('Sample App') }
    it { is_expected.to have_title(full_title('')) }
    it { is_expected.not_to have_title('Home |') }
  end

  describe 'Help Page' do
    before { visit help_path }

    it { is_expected.to have_content('Help') }
    it { is_expected.to have_title(full_title('Help')) }
  end

  describe 'About Page' do
    before { visit about_path }

    it { is_expected.to have_content('About') }
    it { is_expected.to have_title(full_title('About')) }
  end

  describe 'Contact Page' do
    before { visit contact_path }

    it { is_expected.to have_content('Contact') }
    it { is_expected.to have_title(full_title('Contact')) }
  end
end
