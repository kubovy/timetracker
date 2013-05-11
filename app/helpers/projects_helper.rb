module ProjectsHelper
	def get_available_projects(log = Log.new)
		@projects ||= Project.joins("LEFT OUTER JOIN `logs` ON `logs`.`project_id` = `projects`.`id`").where(
				"`projects`.`employer_id` = ? AND (`projects`.`is_deleted` = false OR `logs`.`project_id` IN (?))",
				selected_employer_id, log.project_id).group("`projects`.`id`")
	end
end
