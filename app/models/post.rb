class Post < ApplicationRecord
  belongs_to :user #dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images

  enum visibility: [:post_visible, :friends_only, :not_visible]
  validates :visibility, presence: true
=begin
  after_initialize :set_default_visibility, :if => :new_record?
  def set_default_visibility
    self.visibility ||= :post_visible
  end
=end
  validates :images, content_type: ['image/png', 'image/jpeg', 'image/gif'], limit: { max: 3 }

  scope :post_visibility, -> (visibility) { where("visibility Like ?", post_visible)}
  scope :filter_by_user, -> (user_id) { where("user_id LIKE ?", user_id)}
end
