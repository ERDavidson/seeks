class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	def current_user
	    User.find(session[:user]) if session[:user]
	end
	helper_method :current_user

	def mine(user, secret)
		puts "this secret is " + secret.inspect.to_s
		puts "this user is " + user.inspect.to_s
		puts User.find(user[:id]).secrets.inspect.to_s
		puts User.find(user[:id]).secrets.find_by(secret[:id]).inspect
		User.find(user[:id]).secrets.pluck(:id).include? secret[:id]
	end
	helper_method :mine
end
