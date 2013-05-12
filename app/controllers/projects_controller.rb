class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = {:existing => [], :deleted => []}
    @projects.keys.each do |list|
      break if list == :deleted and not current_user.is_admin?
      @projects[list] = Project.where :is_deleted => (list == :deleted), :employer_id => selected_employer_id
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    project_params[:owner_id] = current_user.id if project_params[:owner_id].nil? or not current_user.is_admin?
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_url, notice: 'Project was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    project_params[:owner_id] = current_user[:id] if project_params[:owner_id].nil? or not current_user.is_admin?
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to projects_url, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    message = @project.is_deleted? ? 'Project was successfully deleted.' : 'Project was successfully restored.'
    respond_to do |format|
      format.html { redirect_to projects_url, notice: message }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      @project_params ||= params.require(:project).permit(:employer_id, :name, :description, :owner_id)
    end
end
