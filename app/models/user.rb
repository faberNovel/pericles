class User < ApplicationRecord
  INTERNAL_EMAIL_DOMAIN = ENV['INTERNAL_EMAIL_DOMAIN']

  devise :database_authenticatable, :omniauthable, :trackable, :validatable, :registerable, :recoverable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true

  scope :external, -> { where.not('email LIKE ?', "%#{INTERNAL_EMAIL_DOMAIN}") }

  def self.from_omniauth(access_token)
    data = access_token.info
    return unless /.+#{Regexp.quote(INTERNAL_EMAIL_DOMAIN)}/ =~ data['email']

    User.find_or_create_by(email: data['email']) do |user|
      user.first_name = data['first_name']
      user.last_name = data['last_name']
      user.password = Devise.friendly_token[0,20]
      user.avatar_url = data['image']
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def internal?
    email.ends_with? INTERNAL_EMAIL_DOMAIN
  end
end
