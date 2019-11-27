class Wow < ApplicationRecord
  validates :comment, presence: true
  validates :address, presence: true
  belongs_to :user
end
