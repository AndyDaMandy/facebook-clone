class Like < ApplicationRecord
  belongs_to :post, dependent: :destroy
  belongs_to :user
end
