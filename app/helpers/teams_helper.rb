module TeamsHelper
	def get_available_teams
		@teams ||= Team.joins(:members).where(
				"`teams`.`employer_id` = ? AND (`teams`.`is_deleted` = false OR `teams`.`id` IN (?)) AND `members`.`user_id` = ?",
				selected_employer_id, current_user.teams, current_user.id)
	end
end
