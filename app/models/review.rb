class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :content, :rating
  validates_uniqueness_of :user_id, scope: :video
end