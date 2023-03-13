class Post < ApplicationRecord
  belongs_to :user #dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images

  #scope :filter_by_user_id, -> (user_id) { where(user_id: user_id)}
end
