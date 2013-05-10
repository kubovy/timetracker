class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper

  before_action :set_available_employers

  private

  def set_available_employers
		@available_employers = available_employers

    if not is_employer_selected? and
		    (params[:controller] != 'pages' or params[:action] != 'select_employer') and
		    single_employer? then
			redirect_to select_employer_url(:selected_employer_id => available_employers.first[:id])
		end
  end
end
