class SessionsController < ApplicationController
def login
	@user = User.find_by(email: params[:user][:email].downcase).try(:authenticate, params[:user]['password'])
	if !@user
		flash[:errors] = "Login failed.  Please try again"
		redirect_to "/"
	else
		flash[:action_status] = "Login successful!"
		session[:user] = @user['id']
		redirect_to "/users/#{@user['id']}"
	end
end

  def logout
  	reset_session
  	flash[:action_status] = "You have been logged out."
  	redirect_to "/"
  end
end
