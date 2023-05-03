# frozen_string_literal: true

# Friendship - Join table between users
class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum friendship_status: %i[pending accepted ignore]
  after_initialize :set_default_friendship_status, if: :new_record?
  def set_default_friendship_status
    self.friendship_status ||= :pending
  end
end
