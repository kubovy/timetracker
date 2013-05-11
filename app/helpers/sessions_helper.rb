module SessionsHelper

	# USERS

  def login(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def logout
    cookies.delete(:remember_token);
    self.current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by(remember_token: cookies[:remember_token])
  end

	# EMPLOYERS

  def selected_employer
	  @selected_employer ||= cookies[:selected_employer_id].nil? ?
			  nil : Employer.find_by_id(cookies[:selected_employer_id])
  end

  def selected_employer_id
	  is_employer_selected? ? selected_employer[:id] : nil
  end

  def is_employer_selected?
	  not selected_employer.nil?
  end

  def available_employers
		if current_user.nil? then
			@available_employers = nil
		else
	    @available_employers ||= Employer
	        .select("DISTINCT(`employers`.`id`), `employers`.*")
	        .joins(:employees)
	        .where("`employers`.`is_deleted` = false AND `employees`.`user_id` = ? OR ?",
				      current_user.id, current_user.is_manager?)
		end
  end

  def multiple_employers?
	  available_employers.count > 1
  end

end
