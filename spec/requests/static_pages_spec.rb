require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  let(:base_title) { 'Ruby on Rails Tutorial Sample App' }

  describe 'Root' do
    it "should have the content 'Sample App'" do
      visit root_path
      expect(page).to have_content('Sample App')
    end

    it "should have the title 'Home'" do
      visit root_path
      expect(page).to have_title("Home | #{base_title}")
    end
  end

  describe 'Home Page' do
    it "should have the content 'Sample App'" do
      visit static_pages_home_path
      expect(page).to have_content('Sample App')
    end

    it "should have the title 'Home'" do
      visit static_pages_home_path
      expect(page).to have_title("Home | #{base_title}")
    end
  end

  describe 'Help Page' do
    it "should have the content 'Help'" do
      visit static_pages_help_path
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      visit static_pages_help_path
      expect(page).to have_title("Help | #{base_title}")
    end
  end

  describe 'About Page' do
    it "should have the content 'About'" do
      visit static_pages_about_path
      expect(page).to have_content('About')
    end

    it "should have the title 'About'" do
      visit static_pages_about_path
      expect(page).to have_title("About | #{base_title}")
    end
  end

  describe 'Contact Page' do
    it "should have the content 'Contact'" do
      visit static_pages_contact_path
      expect(page).to have_content('Contact')
    end

    it "should have the title 'Contact'" do
      visit static_pages_contact_path
      expect(page).to have_title('Contact | Ruby on Rails Tutorial Sample App')
    end
  end
end
