class LogsController < ApplicationController
	before_action :set_log, only: [:edit, :update, :destroy]
	before_action :set_date

  # GET /logs/new
  def new
    @log = Log.new
		@logs = Log.where(
        :date => @selected_date,
        :employer_id => selected_employer_id,
        :user_id => current_user.id)


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

	def set_date
	  cookies.permanent[:selected_date] ||= Date.today.strftime("%Y-%m-%d")
	  cookies.permanent[:selected_date] = params[:date] unless params[:date].nil?
		@selected_date = Date.parse cookies[:selected_date]
	end

  # Never trust parameters from the scary internet, only allow the white list through.
  def log_params
    params.require(:log).permit(:date, :team_id, :client_id, :project_id,
        :task_id, :start, :duration, :description, :billable).merge({
		    :employer_id => selected_employer_id,
        :user_id => current_user.id })
  end

end
