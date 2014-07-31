require "rails_helper"

feature "User registers", { js: true, vcr: true } do
  background do
    visit register_path
  end

  scenario "with valid user info and credit card" do
    fill_in_valid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(page).to have_content("Welcome to MyFlix!")
  end

  scenario "with valid user info and invalid credit card" do
    fill_in_valid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end

  scenario "with valid user info and declined credit card" do
    fill_in_valid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined")
  end

  scenario "with invalid user info and valid credit card" do
    fill_in_invalid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect(page).to have_content("Oops")
  end

  scenario "with invalid user info and invalid credit card" do
    fill_in_invalid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end

  scenario "with invalid user info and declined credit card" do
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect(page).to have_content("Oops")
  end

  private

  def fill_in_valid_user_info
    fill_in "user_name", with: "Testy LaRue"
    fill_in "user_email", with: "testy@fakeemail.com"
    fill_in "user_password", with: "password"
  end

  def fill_in_invalid_user_info
    fill_in "user_email", with: "notenoughinfo@breakmytest.com"
  end

  def fill_in_valid_card
    fill_in "cc-number", with: "4242424242424242"
    fill_in "cvc-code", with: "123"
    select "7 - July", from: "date_month"
    select "2016", from: "date_year"
  end

  def fill_in_invalid_card
    fill_in "cc-number", with: "123"
    fill_in "cvc-code", with: "123"
    select "7 - July", from: "date_month"
    select "2016", from: "date_year"
  end

  def fill_in_declined_card
    fill_in "cc-number", with: "4000000000000002"
    fill_in "cvc-code", with: "123"
    select "7 - July", from: "date_month"
    select "2016", from: "date_year"
  end
end