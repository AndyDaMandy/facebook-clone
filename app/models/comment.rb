class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :comment, presence: true, length: { minimum: 1, maximum: 300 }
end
