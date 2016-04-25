class SecretsController < ApplicationController
	before_action :require_login, only: [:index, :create, :destroy]

	def index
		@trimmed_secrets = Secret.prepare_secrets(current_user)
	end

	def create
		new_secret = User.find(session[:user]).secrets.new(content:params[:secret_content])
		if new_secret.valid?
			new_secret.save
			flash[:action_status] = "Secret shared."
		else
			flash[:errors] = new_secret.errors.full_messsages
		end
		redirect_to "/users/#{session[:user]}"
	end

	def destroy
		deleted_secret = Secret.find(params[:id]).destroy
		flash[:action_status] = "Secret returned to secrecy."
		redirect_to "/users/#{session[:user]}"
	end

	

end
