class SecretsController < ApplicationController
  def index
  	@secret_list = Secret.all
  end
end
