class Post < ApplicationRecord
  belongs_to :user #dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images do |attach|
    attach.variant :small, loader: { n: -1 }, resize_to_limit: [400, nil]
    #attach.variant :small, loader: { page: nil }, coalesce: true, resize_to_fit: [400, nil]
  end

  enum visibility: [:post_visible, :friends_only, :not_visible]
  validates :visibility, presence: true
=begin
  after_initialize :set_default_visibility, :if => :new_record?
  def set_default_visibility
    self.visibility ||= :post_visible
  end
=end
  validates :images, content_type: ['image/png', 'image/jpeg', 'image/gif'], limit: { max: 1 }

  #scope :post_visibility, -> (visibility) { where("visibility Like ? AND ", post_visible)}
  #scope :filter_by_user, -> (user_id, number) { where("user_id LIKE ? AND ", user_id, number)}
end
