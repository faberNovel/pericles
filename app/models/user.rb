class User < ApplicationRecord
  devise :database_authenticatable, :omniauthable, :trackable, :validatable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(access_token)
    data = access_token.info

    User.find_or_create_by(email: data['email']) do |user|
      user.password = Devise.friendly_token[0,20]
    end
  end
end
