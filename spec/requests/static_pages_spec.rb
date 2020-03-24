require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'Home Page' do
    it "should have the content 'Sample APP'" do
      visit 'static_pages/home'
      expect(page).to have_content('Sample APP')
    end
  end
end
