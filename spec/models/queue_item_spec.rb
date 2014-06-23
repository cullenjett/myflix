require "rails_helper"

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "QueueItem #video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: "Monk")
      queue_item1 = Fabricate(:queue_item, video: video)

      expect(queue_item1.video_title).to eq("Monk")
    end
  end

  describe "QueueItem #rating" do
    it "returns the rating from the review when the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 3)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(queue_item.rating).to eq(3)
    end
    it "returns nil when the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)

      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "QueueItem #category_name" do
    it "returns the name of the video's category" do
      category = Fabricate(:category, name: "Comedy")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.category_name).to eq("Comedy")
    end
  end

  describe "QueueItem #category" do
    it "returns the category of the video" do
      category = Fabricate(:category, name: "Comedy")
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)

      expect(queue_item.category).to eq(category)
    end
  end
end