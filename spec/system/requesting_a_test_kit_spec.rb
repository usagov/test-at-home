require "rails_helper"

RSpec.describe "Person requests a test kit", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "accepts input" do
    visit "/"

    fill_in "Full name", with: "Kewpee Doll"
    fill_in "Address", with: "1234 Fake St Lima, OH"
    fill_in "Email", with: "hello@example.com"
    fill_in "Phone", with: "5551234567"
    click_on "Submit"

    expect(page).to have_content "Your request for a Covid test kit has been received."
  end
end
