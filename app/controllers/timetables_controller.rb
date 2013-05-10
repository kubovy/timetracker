class TimetablesController < ApplicationController

  # GET /timetable
  # GET /timetable.json
  def show
    @timetable = Timetable.where :employer_id => selected_employer.id, :employee_id => current_user.id
  end

  # PATCH/PUT /timetable
  # PATCH/PUT /timetable.json
  def update
	  respond_to do |format|
			params[:timetable].each do |day, hours|
				existing = Timetable.first :conditions => {
						:employer_id => selected_employer_id,
						:employee_id => current_user.id,
				    :day => day
				}

				if (existing) then
					success = existing.update :hours => hours unless hours.empty?
					success = existing.delete if hours.empty?
				elsif not hours.empty? then
					t = Timetable.new :employer_id => selected_employer_id,
						:employee_id => current_user.id, :day => day, :hours => hours
					success = t.save
			  else
					success = true
				end

				unless success then
					format.html { render action: 'show', error: sprintf("%s has wrong format.", I18n.t('date.day_names')[day]) }
					format.json { render json: sprintf("%s has wrong format.", I18n.t('date.day_names')[day]), status: :unprocessable_entity }
				end
			end
			format.html { redirect_to timetable_path, notice: 'Timetable was successfully updated.' }
			format.json { head :no_content }
    end
  end

end
