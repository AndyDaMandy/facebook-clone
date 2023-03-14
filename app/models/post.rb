class Post < ApplicationRecord
  belongs_to :user #dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many_attached :images

  enum visibility: [:post_visible, :friends_only, :not_visible]
  after_initialize :set_default_visibility, :if => :new_record?
  def set_default_visibility
    self.visibility ||= :post_visible
  end

  validates :images, content_type: ['image/png', 'image/jpeg'], limit: { max: 3 }

  scope :post_visible, -> { where(visibility: "post_visible")}
  scope :legacy_visible, -> { where(visibility: '')}
  scope :post_friends_only, -> { where(visibility: "friends_only")}

  #scope :filter_by_user_id, -> (user_id) { where(user_id: user_id)}
end
