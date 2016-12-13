class Project < ApplicationRecord
	validates :title, presence: true, length: { in: 2..40 }
	validates :description, length: { maximum: 500 }
end
