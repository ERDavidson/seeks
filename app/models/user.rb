class User < ActiveRecord::Base
	before_save do
		self.email.downcase!
	end

	has_many :secrets
	has_many :likes, dependent: :destroy
	has_many :secrets_liked, through: :likes, source: :secret
	has_secure_password
	validates :name, presence: true
	validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
	validates :email, uniqueness: { case_sensitive: false }
	validates :password, confirmation: true, :on => :create
	validates :password_confirmation, presence: true, :on => :create

	def mine(this_user, this_secret)
		User.find(this_user[:id]).secrets.pluck(:id).include? this_secret[:id]
	end

end
