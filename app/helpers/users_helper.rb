module UsersHelper
	def get_available_users
		if current_user.is_manager?
			@users ||= User.all
	  else
			@users ||= User
			    .select("DISTINCT(`users`.`id`), `users`.*")
					.joins("LEFT JOIN `employees` ON (`employees`.`user_id` = `users`.`id`)")
					.where("`employees`.`employer_id` = ?" +
							" AND (`users`.`id` = ?" +
							"   OR (SELECT `is_manager` FROM `employees` WHERE `employer_id` = ? and `user_id` = ?))",
			           selected_employer_id, current_user.id, selected_employer_id, current_user.id)
		end
	end
end
