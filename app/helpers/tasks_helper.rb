module TasksHelper
	def get_available_tasks
		@tasks ||= Task.all
	end
end
