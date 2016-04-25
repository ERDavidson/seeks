class LikesController < ApplicationController
  def create
  	this_like = Like.new(secret:Secret.find(params[:this_secret]),user:current_user)
  	if this_like.valid? == true
  		this_like.save
  		flash[:action_status] = "Secret liked"
  	else
  		flash[:errors] = this_like.errors.full_messages
  	end
  	redirect_to "/secrets"
  end
end
