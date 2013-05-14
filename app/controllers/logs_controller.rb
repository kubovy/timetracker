class LogsController < ApplicationController
	include TimeHelper

	before_action :set_data

  # GET /logs/new
  def new
  end

  # GET /logs/1/edit
  def edit
  end

  # POST /logs
  # POST /logs.json
  def create
    @log = Log.new(log_params)

    respond_to do |format|
      if @log.save
        format.html { redirect_to new_log_url, notice: 'Log was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logs/1
  # PATCH/PUT /logs/1.json
  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to new_log_url, notice: 'Log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /logs/1
  # DELETE /logs/1.json
  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to new_log_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_log
    @log ||= params[:id].nil? ? Log.new : Log.find(params[:id])
  end

	def set_data
		cookies.permanent[:selected_date] ||= Date.today.strftime("%Y-%m-%d")
		cookies.permanent[:selected_date] = params[:date] unless params[:date].nil?
		@selected_date = Date.parse cookies[:selected_date]

		@logs = Log.where(
				:date => @selected_date,
				:employer_id => selected_employer_id,
				:user_id => current_user.id)

		set_log
		set_calculations
		set_stats
	end

	def set_calculations
		day_diff = (@selected_date.wday - 1 < 0 ? 6 : @selected_date.wday - 1) - 1
		week_begin = Time.at(@selected_date.to_time.to_i - day_diff * 60 * 60 * 24).utc
		week_begin = Time.new(week_begin.year, week_begin.month, week_begin.day, 0, 0, 0).utc
		week_end   = week_begin + 60 * 60 * 24 * 7 - 1
		week = week_begin..week_end

		month_begin = Time.new(@selected_date.year, @selected_date.month, 1, 0, 0, 0)
		month_end = Time.new(@selected_date.next_month.year, @selected_date.next_month.month, 1, 0, 0, 0) - 1
		month = month_begin..month_end

		@daily_total = Log.select("(sum(TIME_TO_SEC(`duration`))) as result")
		.where(:employer_id => selected_employer_id, :user_id => current_user.id, :date => @selected_date)
		@daily_total = @daily_total.first[:result].nil? ? 0 : @daily_total.first[:result]

		@weekly_total = Log.select("(sum(TIME_TO_SEC(`duration`))) as result")
		.where(:employer_id => selected_employer_id, :user_id => current_user.id, :date => week)
		@weekly_total = @weekly_total.first[:result].nil? ? 0 : @weekly_total.first[:result]

		@monthly_total = Log.select("(sum(TIME_TO_SEC(`duration`))) as result")
		.where(:employer_id => selected_employer_id, :user_id => current_user.id, :date => month)
		@monthly_total = @monthly_total.first[:result] .nil? ? 0 : @monthly_total.first[:result]

		@timetable = Hash[
				Timetable.select("day, TIME_TO_SEC(hours) as seconds")
				.where(:employer_id => selected_employer_id,
				       :user_id => current_user.id).map{|t|
					[t.day, t.seconds / 3600]} ]
		@holidays = Holiday.where(:employer_id => selected_employer_id).map{|holiday| holiday.date}

		@weekly_todo = 0
		(0..7).each do |i|
			day = week_begin + i * 24 * 3600
			@weekly_todo += @timetable[day.wday] * 3600 unless @holidays.include?(day) or @timetable[day.wday].nil?
		end

		@monthly_todo = 0
		(0..(month_end.day-1)).each do |i|
			day = month_begin + i * 24 * 3600
			@monthly_todo += @timetable[day.wday] * 3600 unless @holidays.include?(day) or @timetable[day.wday].nil?
		end
	end

	def set_stats
		cookies.permanent[:chart_period] ||= :day
		cookies.permanent[:chart_period] = params[:chart_period] unless params[:chart_period].nil?
		@chart_period = cookies[:chart_period]

		period = (cookies[:chart_period] || :day).to_sym

		date_begin = @selected_date if period == :day
		date_end = @selected_date if period == :day

		date_begin = @selected_date.prev_day(@selected_date.wday == 0 ? 6 : @selected_date.wday - 1) if period == :week
		date_end   = date_begin.next_day(6) if period == :week

		date_begin = Date.new(@selected_date.year, @selected_date.month, 1) if period == :month
		date_end = date_begin.next_month.prev_day if period == :month

		date_begin = Date.new(@selected_date.year, 1, 1) if period == :year
		date_end = date_begin.next_year.prev_day if period == :year

		if period == :all_time
			where = 'user_id = ? AND employer_id = ? AND (date >= ? OR date <= ? OR true)'
		else
			where = 'user_id = ? AND employer_id = ? AND date >= ? AND date <= ?'
		end

		@stats = {
				:project =>  Log
				.select('count(id) as count, project_id')
				.where(where, current_user.id, selected_employer_id, date_begin, date_end)
				.group(:project_id).map{ |s|
					{:project => Project.find(s[:project_id]).name, :count => s[:count]}},
				:task =>  Log
				.select("count(id) as count, task_id")
				.where(where, current_user.id, selected_employer_id, date_begin, date_end)
				.group(:task_id).map{ |s|
					{:task => Task.find(s[:task_id]).name, :count => s[:count]}},
		}
	end

  # Never trust parameters from the scary internet, only allow the white list through.
  def log_params
		if params[:log][:finish] then
			unless parse_time(params[:log][:finish]).nil? then
				diff = parse_time(params[:log][:finish]) - parse_time(params[:log][:start])
				params[:log][:duration] = params[:log][:finish] if diff < 0
				params[:log][:duration] = print_time(diff) unless diff < 0
			end
		end
    params.require(:log).permit(:date, :team_id, :client_id, :project_id,
        :task_id, :start, :duration, :description, :billable).merge({
		    :employer_id => selected_employer_id,
        :user_id => current_user.id })
  end
end
