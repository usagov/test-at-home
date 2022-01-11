require "rails_helper"

RSpec.describe "Person requests a test kit", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "accepts input" do
    visit "/"

    fill_in "First name", with: "Kewpee"
    fill_in "Last name", with: "Doll"
    fill_in "Email", with: "hello@example.com"

    fill_in "Mailing address 1", with: "1234 Fake St"
    fill_in "Mailing address 2", with: "Apt 2"
    fill_in "City", with: "Lima"
    select "OH", from: "State"
    fill_in "Zip code", with: "12345"

    click_on "Place your order"

    expect(page).to have_content "Thank you, your pre-order has been placed."
  end
end
