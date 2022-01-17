require "rails_helper"

RSpec.describe "Viewing site in multiple languages", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "can visit site in English, Spanish, and simplified Chinese" do
    visit "/"

    expect(page).to have_content("Place your pre-order")

    page.all("a", text: "Español").first.click

    expect(page).to have_content(I18n.t("shared.banner.official_site", locale: "es"))

    page.all("a", text: "中文").first.click

    expect(page).to have_content(I18n.t("shared.banner.official_site", locale: "zh"))

    page.all("a", text: "English").first.click

    expect(page).to have_content("Place your pre-order")
  end
end
