class Rating < ApplicationRecord
  belongs_to :wow
  belongs_to :user

end
