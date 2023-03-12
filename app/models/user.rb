class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
  has_many :posts
  has_many :likes, dependent: :destroy
  has_one :profile
  accepts_nested_attributes_for :profile
  has_many :friendships, :class_name => "Friendship"
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  has_one_attached :avatar

  enum role: [:user, :moderator, :admin]
  after_initialize :set_default_role, :if => :new_record?
  def set_default_role
    self.role ||= :user
  end

  validates :first_name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :last_name, presence: true, length: { minimum: 1, maximum: 40 }
  validates :age, presence: true, numericality: { only_integer: true }

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  #scope :filter_by_first_name, -> (first_name) { where("first_name LIKE?", first_name)}
  #scope :filter_by_last_name, -> (last_name) {where("last_name LIKE?", last_name)}
  #scope :filter_by_username, -> (username) {where("username LIKE?", username)}

  
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
