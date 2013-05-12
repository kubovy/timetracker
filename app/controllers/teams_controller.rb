class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :set_all_users, only: [:new, :edit]

  # GET /teams
  # GET /teams.json
  def index
    @teams = {:existing => [], :deleted => []}
    @teams.keys.each do |list|
      break if list == :deleted and not current_user.is_admin?
      @teams[list] = Team.where :is_deleted => (list == :deleted), :employer_id => selected_employer_id
    end
  end

  # GET /teams/1
  # GET /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  # POST /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        add_members
        format.html { redirect_to teams_url, notice: 'Team was successfully created.' }
        format.json { render action: 'show', status: :created, location: @team }
      else
        format.html { render action: 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1
  # PATCH/PUT /teams/1.json
  def update
    respond_to do |format|
      add_members
      if @team.update(team_params)
        format.html { redirect_to teams_url, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.json
  def destroy
    @team.destroy
    message = @team.is_deleted? ? 'Team was successfully deleted.' : 'Team was successfully restored.'
    respond_to do |format|
      format.html { redirect_to teams_url, notice: message }
      format.json { head :no_content }
    end
  end

  private

  def add_members
    members_params.each do |user_id, data|
      if data[:included]
        unless Member.first(:conditions => {:user_id => user_id, :team_id => @team.id}) then
          Member.new(:user_id => user_id, :team_id => @team.id).save
        end
      end
    end

    if members_params.empty? then
	    Member.delete_all([ "team_id = ? AND user_id", @team.id ])
    else
	    Member.delete_all([ "team_id = ? AND user_id NOT IN (?)",
			      @team.id, members_params.map{|k,v| v[:included] ? k : nil}.compact ])
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  def set_all_users
	  @all_users = selected_employer.employees.map{|e| e.user}

		unless params[:id].nil? then
      team = Team.find(params[:id])
      @all_users = (@all_users + team.members.map{|m| m.user}).uniq
		end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_params
    params.require(:team).permit(:employer_id, :name)
  end

  def members_params
    params.require(:team)[:members] || {}
  end
end
