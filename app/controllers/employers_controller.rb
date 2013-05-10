class EmployersController < ApplicationController
  before_action :set_employer, only: [:edit, :update, :destroy]
  before_action :set_all_users, only: [:new, :edit]

  # GET /employers
  # GET /employers.json
  def index
    @employers = {:existing => [], :deleted => []}
    if current_user.is_manager? then
      @employers.keys.each do |list|
        break if list == :deleted and not current_user.is_admin?
        @employers[list] = Employer.where :is_deleted => (list == :deleted)
      end
    else
      ids = current_user.employees.map{|e| e[:is_manager] ? e[:employer_id] : nil}.compact
      @employers.keys.each do |list|
        break if list == :deleted and not current_user.is_admin?
        @employers[list] = Employer.where :id => ids, :is_deleted => (list == :deleted)
      end
    end
  end

  # GET /employers/new
  def new
    @employer = Employer.new
  end

  # GET /employers/1/edit
  def edit
  end

  # POST /employers
  # POST /employers.json
  def create
    @employer = Employer.new(employer_params)

    respond_to do |format|
      if @employer.save
        add_employees
        format.html { redirect_to employers_path, notice: 'Employer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @employer }
      else
        format.html { render action: 'new' }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employers/1
  # PATCH/PUT /employers/1.json
  def update
    respond_to do |format|
      add_employees
      if @employer.update(employer_params)
        format.html { redirect_to employers_path, notice: 'Employer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employers/1
  # DELETE /employers/1.json
  def destroy
    @employer.destroy
    message = @employer.is_deleted? ? 'Employer was successfully deleted.' : 'Employer was successfully restored.'
    respond_to do |format|
      format.html { redirect_to employers_url, notice: message }
      format.json { head :no_content }
    end
  end

  private

  def add_employees
    employees_params.each do |user_id, data|
      if data[:included]
        existing = Employee.first :conditions => {:user_id => user_id, :employer_id => @employer.id}
        if existing then
          existing.update :is_manager => !data[:manager].nil?
        else
          existing = Employee.new :user_id => user_id, :employer_id => @employer.id, :is_manager => !data[:manager].nil?
          existing.save
        end
      end
    end

    if employees_params.empty? then
	    Employee.delete_all([ "employer_id = ?", @employer.id ])
		else
			Employee.delete_all([ "employer_id = ? AND user_id NOT IN (?)",
					  @employer.id, employees_params.map{|k,v| v[:included] ? k : nil}.compact ])
		end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_employer
      @employer = Employer.find(params[:id])
    end

    def set_all_users
      @all_users = User.where :is_deleted => false
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employer_params
      params.require(:employer).permit(:name, :employees)
    end

    def employees_params
      params.require(:employer)[:employees] || {}
    end
end
