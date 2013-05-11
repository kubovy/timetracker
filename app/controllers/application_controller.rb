class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper

  before_action :set_available_employers
  before_action :set_cookies_to_user_model

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
end
