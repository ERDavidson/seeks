class Secret < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :users_liked_by, through: :likes, source: :user
  validates :content, presence: true

  def self.prepare_secrets(*owner)
		if owner != []
			raw_secrets = User.find(owner[0]).secrets
		else
			raw_secrets = Secret.all
		end
		trimmed_secrets = []
		raw_secrets.each do |entry|
			entry.likes.count > 0 ? likes = entry.likes.count : likes = 0
			trimmed_secrets.push({:id=>entry[:id],:content=>entry[:content],:likes=>likes})
		end
		trimmed_secrets
	end
end
