class ReportsController < ApplicationController
	before_action :set_favorites

	def configure

	end

	def generate
		generate_report unless params[:generate].nil?
		create_report unless params[:create].nil?
		update_report unless params[:update].nil?
		load_report unless params[:load].nil?
		delete_report unless params[:delete].nil?
  end

	private

	def generate_report

		@params = report_params
		p = report_params[:report]

		if p[:time_period].empty? and (
				p['start(1i)'].empty? or p['start(2i)'].empty? or p['start(3i)'].empty? or
				p['end(1i)'].empty? or p['end(2i)'].empty? or p['end(3i)'].empty?) then
			redirect_to reports_path, notice: 'Time period or start and end date needs to be selected!'
			return
		end

		#TIME_PERIODS = {1 => 'this month', 2 => 'last month', 3 => 'this week', 4 => 'last week'}
		if p[:time_period].empty? then
			@begin = Date.parse "#{p['start(1i)']}-#{p['start(2i)']}-#{p['start(3i)']}"
			@end = Date.parse "#{p['end(1i)']}-#{p['end(2i)']}-#{p['end(3i)']}"
		else
			p[:time_period] = p[:time_period].to_i
			t = Date.today
			@begin = Date.new(t.year, t.month, 1)                       if p[:time_period] == 1
			@begin = Date.new(t.prev_month.year, t.prev_month.month, 1) if p[:time_period] == 2
			@begin = t.prev_day(wday(t))                                if p[:time_period] == 3
			@begin = t.prev_day(wday(t) + 6)                            if p[:time_period] == 4

			@end = @begin.next_month.prev_day if [1, 2].include?(p[:time_period])
			@end = @begin.next_day(6)         if [3, 4].include?(p[:time_period])
		end

		groups = {:by => [nil], :per => [nil]}

		#GROUPING_BY  = {1 => 'user', 2 => 'team', 3 => 'project', 4 => 'task'}
		unless p[:group_by].empty?
			p[:group_by] = p[:group_by].to_i
			@by_type = Report::GROUPING_BY[p[:group_by]]
			groups[:by] = User.all    if p[:group_by] == 1
			groups[:by] = Team.all    if p[:group_by] == 2
			groups[:by] = Project.all if p[:group_by] == 3
			groups[:by] = Task.all    if p[:group_by] == 4
		end

		#GROUPING_PER = {1 => 'month', 2 => 'week', 3 => 'day'}
		unless p[:group_per].empty?
			p[:group_per] = p[:group_per].to_i
			@per_type = p[:group_per]

			groups[:per] = (@begin..@end).map{ |date|
					[ Date.new(date.year, date.month),
					  Date.new(date.year, date.month).next_month.prev_day ]
			} if p[:group_per] == 1

			groups[:per] = (@begin..@end).map{ |date|
				[ date.prev_day(wday(date)),
				  date.prev_day(wday(date)).next_day(6) ]
			} if p[:group_per] == 2

			groups[:per] = (@begin..@end).map{ |date|
				[ date, date ]
			} if p[:group_per] == 3
		end

		logs = Log
				.where('employer_id = ? AND user_id IN (?) AND project_id IN (?) AND task_id IN (?) AND date >= ? AND date <= ?',
							selected_employer_id,
							p[:user_ids].map{|i| i.to_i},
							p[:project_ids].map{|i| i.to_i},
							p[:task_ids].map{|i| i.to_i},
							@begin,
							@end)
				.order("date asc, start asc")

		date_min = nil
		date_max = nil
		logs.each do |record|
			date_min = record.date if date_min.nil? or record.date < date_min
			date_max = record.date if date_max.nil? or record.date > date_max
		end
		date_min = date_min.prev_month
		date_max = date_max.next_month

		@groups = []
		groups[:per].each do |per|
			groups[:by].each do |by|
				if per.nil? || (per[0] >= date_min and per[1] <= date_max) then
					@groups << {:per => per, :by => by}
				end
			end
		end

		@log = {}
		holidays = {}
		Employer.all.each do |employer|
			holidays[employer] = Holiday.where(:employer_id => employer.id).map{|h| h.date}
		end

		timetable = {}
		User.all.each do |user|
			timetable[user] = Hash[
					Timetable.where(:user_id => user.id, :employer_id => selected_employer_id).map{ |t|
						[t.day.to_i, t.hours.hour * 3600 + t.hours.min * 60 + t.hours.sec]
					}]
		end


		@groups.each do |group|
			records = logs.map{ |record|
				if group[:by].is_a?(User) and group[:by] != record.user or
						group[:by].is_a?(Team) and group[:by] != record.team or
						group[:by].is_a?(Project) and group[:by] != record.project or
						group[:by].is_a?(Task) and group[:by] != record.task or (
						not group[:per].nil? or
					  p[:group_per] == 1 and (
					      (group[:per][0] <=> record.date) == 1 or
							  (group[:per][1] <=> record.date) == -1
					  ) or
						p[:group_per] == 2 and (
								(group[:per][0] <=> record.date) == 1 or
								(group[:per][1] <=> record.date) == -1 or
								group[:per][0].cweek != record.date.cweek
						) or
					  p[:group_per] == 3 and (
						    (group[:per][0] <=> record.date) == 1 or
							  (group[:per][1] <=> record.date) == -1
					  ))
				then
					nil
				else
					record
				end
			}.compact

			total = records.map{ |r|
				r.duration.hour * 3600 + r.duration.min * 60 + r.duration.sec
			}.inject{|sum, x| sum + x }

			todo = records.map{ |r| r.user }.uniq.count == 1
			if todo then
				user = records.first.user
				todo = Hash[records.map{ |r|
					[r.date, holidays[r.employer].include?(r.date) ? 0 : timetable[user][r.date.wday]]
				}].values.compact.inject{|sum, x| sum + x }
			end
			todo = 0 unless todo.is_a?(Fixnum)


			@log[group] = {
					:records   => records,
					:start     => records.map{|r| r.date}.sort.first,
					:end       => records.map{|r| r.date}.sort.last,
					:total     => total,
					:todo      => todo,
			    :remaining => (todo == 0 or todo < total) ? 0 : todo - total,
					:overtime  => (todo == 0 or todo > total) ? 0 : total - todo
			} unless records.empty?
		end

		@columns = 1
		@fields = p[:fields].nil? ? [] : p[:fields]
		@columns += 1 if @fields.include? 'user'
		@columns += 1 if @fields.include? 'team'
		@columns += 1 if @fields.include? 'project'
		@columns += 1 if @fields.include? 'task'
		@columns += 1 if @fields.include? 'start'
		@columns += 1 if @fields.include? 'finish'
		@columns += 1 if @fields.include? 'duration'
		@columns += 1 if @fields.include? 'description'

		respond_to do |format|
			format.html { render action: 'report' }
			format.json { render json: @report, status: :ok }
		end
	end

	def load_report
		@favorite = Report.find(report_params[:id])
		respond_to do |format|
			format.html { render action: 'configure' }
			format.json { render json: @favorite, status: :ok }
		end
	end

	def create_report
		@report = Report.new(report_params(true)[:report])
		respond_to do |format|
			if @report.save
				format.html { redirect_to reports_path, notice: 'Report was successfully created.' }
				format.json { head :no_content }
			else
				format.html { render action: 'configure' }
				format.json { render json: @report.errors, status: :unprocessable_entity }
			end
		end
	end

	def update_report
		@report = Report.find(params[:id])
		respond_to do |format|
			if @report.update(report_params(true)[:report])
				format.html { redirect_to reports_path, notice: 'Report was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'configure' }
				format.json { render json: @report.errors, status: :unprocessable_entity }
			end
		end
	end

	def delete_report
		@report = Report.find(params[:id])

		respond_to do |format|
			if @report.destroy
				format.html { redirect_to reports_path, notice: 'Report was successfully deleted.' }
				format.json { head :no_content }
			else
				format.html { redirect_to projects_url, notice: 'Report could not be deleted.' }
				format.json { render json: @report.errors, status: :unprocessable_entity }
			end
		end
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def report_params(db_format = false)
		p = params.permit(
				:generate, :save, :load, :delete, :id,
				{:report => [{:project_ids => true},
				             {:task_ids    => true},
				             {:user_ids    => true},
				              :time_period, :start, :end,
				             {:fields => [:user, :team, :project, :task,
				                          :start, :finish, :duration,
				                          :description,
				                          #:billable, :idle,
				                          :todo, :remaining, :overtime]},
				              :group_by, :group_per, :name]})

		p[:report][:project_ids] = p[:report][:project_ids].keys unless p[:report][:project_ids].nil?
		p[:report][:user_ids]    = p[:report][:user_ids].keys    unless p[:report][:user_ids].nil?
		p[:report][:task_ids]    = p[:report][:task_ids].keys    unless p[:report][:task_ids].nil?
		p[:report][:fields]      = p[:report][:fields].keys      unless p[:report][:fields].nil?

		if db_format
			unless p[:report][:time_period].empty? then
				p[:report][:start] = nil
				p[:report][:start] = nil
			end

			p[:report][:user_id] = current_user.id
			p[:report][:project_ids] = p[:report][:project_ids].join(',') unless p[:report][:project_ids].nil?
			p[:report][:user_ids]    = p[:report][:user_ids].join(',')    unless p[:report][:user_ids].nil?
			p[:report][:task_ids]    = p[:report][:task_ids].join(',')    unless p[:report][:task_ids].nil?
			p[:report][:fields]      = p[:report][:fields].join(',')      unless p[:report][:fields].nil?
		end

		return p
	end

	def set_favorites
		@favorite = Report.new
		@favorites = Report.where("user_id = ? AND name IS NOT NULL", current_user.id)
	end

	def wday(date)
		date.wday == 0 ? 6 : date.wday - 1
	end
end
