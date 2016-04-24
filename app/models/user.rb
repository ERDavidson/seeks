class User < ActiveRecord::Base
	before_save do
		self.email.downcase!
	end

	has_secure_password
	validates :name, presence: true
	validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
	validates :email, uniqueness: { case_sensitive: false }
	validates :password, confirmation: true
	validates :password_confirmation, presence: true

end
