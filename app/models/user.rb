class User < ApplicationRecord
  INTERNAL_EMAIL_DOMAIN = ENV['INTERNAL_EMAIL_DOMAIN']

  devise :database_authenticatable, :omniauthable, :trackable, :validatable, :registerable, :recoverable, omniauth_providers: Devise.omniauth_configs.keys

  has_many :members
  has_many :projects, through: :members

  validates :email, presence: true

  scope :external, -> { where(internal: false) }

  before_create :set_internal

  def self.from_omniauth(access_token)
    data = access_token.info
    return unless data['email'].present?

    User.find_or_create_by(email: data['email']) do |user|
      user.first_name = data['first_name']
      user.last_name = data['last_name']
      user.password = Devise.friendly_token[0, 20]
      user.avatar_url = data['image']
    end
  end

  def set_internal
    return unless INTERNAL_EMAIL_DOMAIN
    self.internal = email.ends_with? INTERNAL_EMAIL_DOMAIN
  end

  def name
    "#{first_name} #{last_name}"
  end
end
