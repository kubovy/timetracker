class PagesController < ApplicationController

  def home
    if logged_in? then
			redirect_to new_log_path
    else
      redirect_to login_path
    end
  end

  def help
  end

	def select_employer
		p = params.permit(:selected_employer_id)
		cookies.permanent[:selected_employer_id] = p[:selected_employer_id]
		#self.selected_employer = Employer.find(employer_id)
		#set_selected_employer p[:selected_employer_id]
		redirect_to request.referer || root_url
	end
end
