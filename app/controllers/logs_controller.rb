class LogsController < ApplicationController
	before_action :set_log, only: [:edit, :update, :destroy]
	before_action :set_available_options, only: [:new, :edit]
	before_action :set_date

  # GET /logs/new
  def new
    @log = Log.new
		@logs = Log.where :date => @selected_date, :user_id => current_user.id

    day_diff = (@selected_date.wday - 1 < 0 ? 6 : @selected_date.wday - 1) - 1
    week_begin = Time.at(@selected_date.to_time.to_i - day_diff * 60 * 60 * 24).utc
    week_begin = Time.new(week_begin.year, week_begin.month, week_begin.day, 0, 0, 0).utc
    week_end   = week_begin + 60 * 60 * 24 * 7 - 1
    week = week_begin..week_end

    @weekly_total = Log.select("(sum(TIME_TO_SEC(`duration`))) as result")
        .where(:employer_id => selected_employer_id, :user_id => current_user.id, :date => week)

    unless @weekly_total.first[:result].nil? then
      hours = (@weekly_total.first[:result] / 3600).floor
      minutes =  ((@weekly_total.first[:result] - (hours * 3600)) / 60).to_i
      @weekly_total = "#{hours}:#{minutes}"
    else
			@weekly_total = "0:00"
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
        format.json { render action: 'show', status: :created, location: @log }
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

    def set_available_options
			@teams = Team.where :is_del

			#t = Team.arel_table
			#t[:is_deleted].eq(false).or(t[:id].in(current_user.teams.map{|t| t.id}))
			@teams = Team.joins(:members).where(
					"`teams`.`employer_id` = ? AND (`teams`.`is_deleted` = false OR `teams`.`id` IN (?)) AND `members`.`user_id` = ?",
					selected_employer_id, current_user.teams, current_user.id)

			@clients = []
			@projects = Project.joins("LEFT OUTER JOIN `logs` ON `logs`.`project_id` = `projects`.`id`").where(
					"`projects`.`employer_id` = ? AND (`projects`.`is_deleted` = false OR `logs`.`project_id` IN (?))",
					selected_employer_id, set_log.project_id).group("`projects`.`id`")
			@tasks = Task.all

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:date, :team_id, :client_id, :project_id,
          :task_id, :start, :duration, :description, :billable).merge({
		    :employer_id => selected_employer_id,
		    :user_id => current_user.id })
    end
end
