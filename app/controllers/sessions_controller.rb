class SessionsController < ApplicationController
def new
	if current_user
		redirect_to "/users/#{current_user[:id]}"
	end
end

def login
	logging_user = User.find_by(email: params[:user][:email].downcase).try(:authenticate, params[:user]['password'])
	if !logging_user
		flash[:errors] = "Login failed.  Please try again"
		redirect_to "/sessions/new"
	else
		flash[:action_status] = "Login successful!"
		session[:user] = logging_user['id']
		redirect_to "/users/#{logging_user[:id]}"
	end
end

  def logout
  	reset_session
  	flash[:action_status] = "You have been logged out."
  	redirect_to "/sessions/new"
  end
end
