class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(login: params[:session][:login])
    unless user
      user = User.new(login: params[:session][:login])
      user[:is_admin] = true if User.count == 0

      unless user.save
        flash[:error] = "Welcome to the Sample App!"
        render 'new'
      end
    end

    login user
    redirect_to root_path
  end

  def destroy
    logout
    redirect_to root_path
  end
end
