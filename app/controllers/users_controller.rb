class UsersController < ApplicationController
	def welcome
		if session[:user]
			redirect_to "/users/index"
		end
	end

	def index
#	  	if !session[:user]
#	  		flash[:errors] = "Please log in"
#	  		redirect_to "/"
#	  	end
	  	@user_list = User.all
#	  	@current_user = session[:user]
  	end

  def register
  	if session[:user]
  		flash[:action_status] = "You are already logged in!"
  		redirect_to "/users/index"
  	else
	  	@user = User.create( register_params )  #
	  	if @user.errors.full_messages.length >0
	  		flash[:errors] = @user.errors.full_messages
	  		redirect_to "/"
	  	else
	  		flash[:action_status] = "Registration successful!"
	  		session[:user] = @user['id']
	  		redirect_to "/users/index"
	  	end
	 end
  end

  def login
  	if session[:user]
		redirect_to "/users/index"
	else
	  	@user = User.find_by(email: params[:user][:email].downcase).try(:authenticate, params[:user]['password'])
	  	if !@user
	  		flash[:errors] = "Login failed.  Please try again"
	  		redirect_to "/"
	  	else
	  		flash[:action_status] = "Login successful!"
	  		session[:user] = @user['id']
	  		redirect_to "/users/index"
  		end
 	end
  end

  def destroy
  	destroyed_user = User.find(params[:id]).destroy
  	flash[:action_status] = "Removed #{destroyed_user[:name]} from database."
  	redirect_to "/users/index"
  end

  def logout
  	reset_session
  	flash[:action_status] = "You have been logged out."
  	redirect_to "/"
  end

  def sneak
    @user_list = User.all
    render "index"
  end

  private
  	def register_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

end
