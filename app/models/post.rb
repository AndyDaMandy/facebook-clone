# frozen_string_literal: true

# Posts, main application
class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images do |attach|
    attach.variant :small, loader: { n: -1 }, resize_to_limit: [400, nil]
    # attach.variant :small, loader: { page: nil }, coalesce: true, resize_to_fit: [400, nil]
  end

  enum visibility: %i[post_visible friends_only not_visible]
  validates :visibility, presence: true
  validates :content, presence: true, length: { minimum: 1, maximum: 700 }

  validates :images, content_type: %w[image/png image/jpeg image/gif], limit: { max: 1 }

  # scope :post_visibility, -> (visibility) { where("visibility Like ? AND ", post_visible)}
  # scope :filter_by_user, -> (user_id, number) { where("user_id LIKE ? AND ", user_id, number)}
end
