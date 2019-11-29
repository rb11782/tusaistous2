class Wow < ApplicationRecord
  validates :comment, presence: true
  validates :address, presence: true
  validates :picture, presence: true
  geocoded_by :address
  after_validation :geocode
  mount_uploader :picture, PictureUploader
  belongs_to :user
end
