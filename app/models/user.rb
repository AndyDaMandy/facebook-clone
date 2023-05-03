# frozen_string_literal: true

# Users, uses devise
class User < ApplicationRecord
  # after_commit :create_slug, on: :create
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships, class_name: 'Friendship', dependent: :destroy
  has_many :friends, through: :friendships, dependent: :destroy
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :friends_posts, through: :friends, source: :posts

  has_one_attached :avatar do |attach|
    attach.variant :thumb, resize_to_limit: [100, 100], format: :jpg
    attach.variant :mini, resize_to_fit: [40, 40], format: :jpg
  end

  extend FriendlyId
  friendly_id :generated_slug, use: :slugged
  def generated_slug
    require 'securerandom'
    @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(15)
  end

  def should_generate_new_friendly_id?
    slug.blank?
  end




  enum role: %i[user moderator admin]
  after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :user
  end

  validates :first_name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 40 }
  # validates :age, presence: true, numericality: { only_integer: true }
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  # scope :by_last_name, ->(last_name) { where('last_name LIKE ?', last_name) }
  # scope :by_first_name, ->(first_name) { where('last_name LIKE ?', first_name) }

end
