require 'rails_helper'

describe 'root', type: :system, js: true do
  xit 'show login' do
    visit root_url
    expect(page).to have_content 'Monitoring the health of packages'
  end
end
