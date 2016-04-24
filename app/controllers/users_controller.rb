class UsersController < ApplicationController
	def index
	  	if session[:user]
		  	@current_user = session[:user]
	  		@user_list = User.all
		end
  	end

	def new
	  	if session[:user]
	  		flash[:action_status] = "Please log out before registering as a new user."
	  		redirect_to "/"
	  	end
	end

	def show
		@view_user = User.find(params[:id])
	end

	def create
	  	@user = User.create( register_params )
	  	if @user.errors.full_messages.length > 0
	  		flash[:errors] = @user.errors.full_messages
	  		redirect_to "/users/new"
	  	else
	  		flash[:action_status] = "Registration successful!"
	  		session[:user] = @user['id']
	  		redirect_to "/"
	  	end
	end

	def login
		@user = User.find_by(email: params[:user][:email].downcase).try(:authenticate, params[:user]['password'])
		if !@user
			flash[:errors] = "Login failed.  Please try again"
		else
			flash[:action_status] = "Login successful!"
			session[:user] = @user['id']
		end
		redirect_to "/"
	end

  def destroy
  	destroyed_user = User.find(params[:id]).destroy
  	flash[:action_status] = "Removed #{destroyed_user[:name]} from database."
  	redirect_to "/"
  end

  def logout
  	reset_session
  	flash[:action_status] = "You have been logged out."
  	redirect_to "/"
  end

  private
  	def register_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

end
