class User < ApplicationRecord
  devise :database_authenticatable, :omniauthable, :trackable, :validatable
end
