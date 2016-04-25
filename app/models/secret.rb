class Secret < ActiveRecord::Base
  belongs_to :user
  has_many :likes
  has_many :users_liked_by, through: :likes, source: :user
  validates :content, presence: true

  def self.prepare_secrets(current_user,*secret_owner)	#converts a list of Active Record secrets into a list of hashes, where each hash represents
		if secret_owner != []				#a secret and contains its id, content, # of likes, & id (or false) of current_user's like.
			raw_secrets = User.find(secret_owner[0]).secrets
		else
			raw_secrets = Secret.all
		end
		trimmed_secrets = []
		raw_secrets.each do |entry|
			entry.likes.count > 0 ? likes = entry.likes.count : likes = 0
			puts entry.inspect
			current_user.secrets_liked.include? entry ? my_opinion = Like.where(user:current_user,secret:entry).pluck(:id)[0] : my_opinion = false
			puts my_opinion
			trimmed_secrets.push({:id=>entry[:id],:content=>entry[:content],:likes=>likes,:my_opinion=>my_opinion})
			puts trimmed_secrets.to_s
		end
		trimmed_secrets
	end
end
