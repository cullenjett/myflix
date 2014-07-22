require "rails_helper"

feature "admin adds video" do
  scenario "admin successfully adds a new video" do
    admin = Fabricate(:admin)
    drama = Fabricate(:category, name: "Drama")
    sign_in(admin)
    visit new_admin_video_path

    add_new_video
    sign_out
    
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")
  end

  def add_new_video
    fill_in "Title", with: "Monk"
    select "Drama", from: "Category"
    fill_in "Description", with: "Not that funny..."
    attach_file "Large Cover Image", "spec/support/uploads/monk_large.jpg"
    attach_file "Small Cover Image", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"
    click_button "Add Video"
  end
end