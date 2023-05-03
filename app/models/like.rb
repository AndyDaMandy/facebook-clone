# frozen_string_literal: true

# Likes, should belong to posts?
class Like < ApplicationRecord
  belongs_to :post
  belongs_to :user
end
