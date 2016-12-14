class Project < ApplicationRecord
	validates :title, presence: true, length: { in: 2..25 }
	validates :description, length: { maximum: 500 }
end
