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
		redirect_to "/users/#{current_user[:id]}"
	end

	def destroy
		deleted_secret = Secret.find(params[:id])
		if deleted_secret.user == current_user
			deleted_secret.destroy
			flash[:action_status] = "Secret returned to secrecy."
		else
			flash[:errors] = "You may only tamper with your own secrets."
		end
		redirect_to "/users/#{current_user[:id]}"
	end

	

end
