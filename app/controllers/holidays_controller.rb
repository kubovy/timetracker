class HolidaysController < ApplicationController
  before_action :set_holiday, only: [:destroy]

  # GET /holidays
  # GET /holidays.json
  def index
    @holidays = Holiday.where :employer_id => selected_employer_id
  end

  # GET /holidays/new
  def new
    @holiday = Holiday.new
  end

  # POST /holidays
  # POST /holidays.json
  def create
	  respond_to do |format|
		  holiday_params[:date].split("\n").each do |date|
		    @holiday = Holiday.new(:employer_id => holiday_params[:employer_id], :date => date)

        unless @holiday.save
	        format.html { render action: 'new' }
          format.json { render json: @holiday.errors, status: :unprocessable_entity }
        end
		  end
		  format.html { redirect_to holidays_url, notice: 'Holiday was successfully created.' }
		  format.json { head :no_content }
	  end
  end

  # DELETE /holidays/1
  # DELETE /holidays/1.json
  def destroy
    @holiday.destroy
    respond_to do |format|
      format.html { redirect_to holidays_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def holiday_params
      params.require(:holiday).permit(:employer_id, :date)
    end
end
