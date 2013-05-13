class SessionsController < ApplicationController
  def new
	redirect_to root_path if logged_in?
  end

  def create
    do_login params[:session][:login]
    redirect_to root_path
  end

  def destroy
    do_logout
    redirect_to root_path
  end
end
