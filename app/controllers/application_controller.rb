class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper

  before_action :set_available_employers
  before_action :set_cookies_to_user_model
  before_action :force_login_using_basic_auth

  protected

  def do_login(login)
    user = User.find_by(login: login)
    unless user
      user = User.new(login: login)
      user[:is_admin] = true if User.count == 0

      unless user.save
        flash[:error] = 'Error while login attempt.'
	 return false
      end
    end

    login user
    return true
  end

  def do_logout
    logout
    force_login_using_basic_auth
  end

  private

  def set_available_employers
		@available_employers = available_employers

    if logged_in? and
		    not is_employer_selected? and
		    (params[:controller] != 'sessions' or params[:action] != 'destroy') and
		    (params[:controller] != 'pages' or params[:action] != 'select_employer') and
		    (params[:controller] != 'employers') and
        not multiple_employers? then
			only_employer = available_employers.first
			if only_employer.nil? then
				redirect_to new_employer_path
			else
				redirect_to select_employer_url(:selected_employer_id => available_employers.first[:id])
			end
		end
  end

  def set_cookies_to_user_model
    User.cookies = cookies
  end

  def force_login_using_basic_auth
		@basic_auth = !request.authorization.nil?
		if @basic_auth then
				do_login ActionController::HttpAuthentication::Basic::user_name_and_password(request)[0] if not logged_in?
		end
  end
end
