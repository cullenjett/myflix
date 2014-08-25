require 'rails_helper'

feature "Admin sees payments" do
  background do
    alice = Fabricate(:user, name: "Alice User", email: "alice@example.com")
    Fabricate(:payment, amount: 999, user: alice)
  end

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice User")
    expect(page).to have_content("alice@example.com")
  end

  scenario "user cannot see payments" do
    sign_in(Fabricate(:user, admin: false))
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content("Alice User")
  end
end
