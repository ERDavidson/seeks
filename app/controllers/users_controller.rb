class UsersController < ApplicationController
	before_action :require_login, except: [:new, :create]
	before_action :require_correct_user, only: [:show, :edit, :update, :destroy]
	
	def index
  		@user_list = User.all
  	end

	def new
	end

	def create
	  	registering_user = User.create( register_params )
	  	if registering_user.errors.full_messages.length > 0
	  		flash[:errors] = registering_user.errors.full_messages
	  		redirect_to "/users/new"
	  	else
	  		flash[:action_status] = "Registration successful!"
	  		session[:user] = registering_user['id']
	  		redirect_to "/users/#{registering_user[:id]}"
	  	end
	end

	def show
		@view_user = User.find(params[:id])
		@secret_list = Secret.prepare_secrets(current_user,@view_user)
	end

	def edit
	end

	def update
		updated_user = current_user
		updated_user.with_lock do 
			updated_user.name = update_params[:name]
			updated_user.email = update_params[:email]
			if updated_user.valid? == false
				flash[:errors] = updated_user.errors.full_messages
				redirect_to "/users/#{current_user[:id]}/edit"
			else
				updated_user.save
				flash[:action_status] = "Profile updated."
				redirect_to "/users/#{current_user[:id]}"
		 	end
		end
	end

	def destroy
		destroyed_user = User.find(params[:id]).destroy
		reset_session
		flash[:action_status] = "Your account has been deleted."
		redirect_to "/sessions/new"
	end

	private
		def register_params
	  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		def update_params
			params.require(:user).permit(:name, :email)
		end

end
