require "rails_helper"

feature "User invites friend" do
  scenario "User successfully invites a friend and invitation is accepted", { js: true, vcr: true } do
    alice = Fabricate(:user)
    sign_in(alice)

    invite_a_friend
    friend_accepts_invitation

    friend_should_follow(alice)
    inviter_should_follow_friend(alice)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "invitation_recipient_name", with: "John Doe"
    fill_in "invitation_recipient_email", with: "john@example.com"
    fill_in "invitation_message", with: "Hey John, sign up for this site!"
    click_button "Send Invite"
    sign_out
  end

  def friend_accepts_invitation
    open_email "john@example.com"
    current_email.click_link "Accept This Invitation"

    fill_in "user_password", with: "password"
    fill_in "user_name", with: "John Doe"
    fill_in "Credit Card #", with: "4242424242424242"
    fill_in "CVC", with: "123"
    select "7 - July", from: "date_month"
    select "2016", from: "date_year"
    click_button "Sign Up"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content(user.name)
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content("John Doe")
  end
end