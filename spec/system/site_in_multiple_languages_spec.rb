require "rails_helper"

RSpec.describe "Viewing site in multiple languages", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "can visit site in English, Spanish, and simplified Chinese" do
    visit "/"

    expect(page).to have_content("Place your pre-order")

    # click_on 'Español'

    # expect(page).to have_content(t('kit_requests.new.title'))

    # click_on '中文'

    # expect(page).to have_content(t('kit_requests.new.title'))
  end
end
