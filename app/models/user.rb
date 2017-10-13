class User < ApplicationRecord
  devise :database_authenticatable, :omniauthable, :trackable, :validatable, omniauth_providers: [:google_oauth2]

  validates :email, presence: true

  def self.from_omniauth(access_token)
    data = access_token.info
    return unless /.+@fabernovel\.com/ =~ data['email']

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
end
