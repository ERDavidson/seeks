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

	def edit
		if session[:user]
			if session[:user].to_i != params[:id].to_i
				flash[:errors] = "You may only edit your own profile."
				redirect_to "/users/#{params[:id]}"
			end
		else
			flash[:errors] = "Please log in first."
			redirect_to "/"
		end
	end

	def update
		updated_user = User.find(session[:user])
		updated_user.with_lock do 
			updated_user.name = update_params[:name]
			updated_user.email = update_params[:email]
			if updated_user.valid? == false
				flash[:errors] = updated_user.errors.full_messages
			else
				updated_user.save
		 	end
		end
		redirect_to "/users/#{current_user[:id]}/edit"
	end

	def create
	  	@user = User.create( register_params )
	  	if @user.errors.full_messages.length > 0
	  		flash[:errors] = @user.errors.full_messages
	  		redirect_to "/users/new"
	  	else
	  		flash[:action_status] = "Registration successful!"
	  		session[:user] = @user['id']
	  		redirect_to "/users/#{@user['id']}"
	  	end
	end

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

  	def update_params
  		params.require(:user).permit(:name, :email)
  	end

end
