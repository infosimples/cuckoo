class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: [:show, :update, :destroy, :finish]

  def index
    @time_entries = TimeEntry.for_user(@current_user)
  end

  def show
  end

  # GET /time_entries/new
  def new
    @time_entry = TimeEntry.new
    @projects = Project.all
    @tasks = Task.all
  end

  # GET /time_entries/:id/edit
  def edit
    @time_entry = TimeEntry.find(params[:id])
    @projects = Project.all
    @tasks = Task.all
  end

  # POST /time_entries
  def create
    @time_entry = TimeEntry.new(time_entry_params.merge(user: @current_user))

    respond_to do |format|
      if @time_entry.save
        # TODO: redirect to show but show the time_entry day
        format.html { redirect_to controller: 'timesheet', action: 'show', :year => params[:year], :month => params[:month], :day => params[:day]  }
        format.json { redirect_to controller: 'timesheet', action: 'show', status: :created, location: @time_entry }
      else
        @projects = Project.all
        @tasks = Task.all

        format.html { render action: 'new' }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end

  end

  # PATCH/PUT /time_entries/:id
  def update
    @projects = Project.all
    @tasks = Task.all
    respond_to do |format|
      if @time_entry.update(time_entry_params)
        format.html { redirect_to controller: 'timesheet', action: 'show', :year => params[:time_entry][:year], :month => params[:time_entry][:month], :day => params[:time_entry][:day] }
        format.json { render action: 'show', status: :created, location: @time_entry }
      else

        format.html { render action: 'edit' }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_entries/:id
  def destroy
    year = @time_entry.started_at.year
    month = @time_entry.started_at.month
    day = @time_entry.started_at.day
    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to controller: 'timesheet', action: 'show', :year => year, :month => month, :day => day }
      format.json { head :no_content }
    end
  end

  def finish

    params[:time_entry] = { ended_at: Time.zone.now }
    update
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_time_entry
    @time_entry = TimeEntry.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def time_entry_params
    args = params.require(:time_entry).permit(:project_id, :task_id, :description, :started_at, :ended_at)

    args[:entry_date] =  "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    args[:start_time] = "#{params[:time_entry][:started_at]}"
    args[:end_time]   = "#{params[:time_entry][:ended_at]}"

    # if params[:time_entry][:started_at].present?
    #   args[:started_at] = DateTime.parse("#{params[:time_entry][:year]}-#{params[:time_entry][:month]}-#{params[:time_entry][:day]} #{params[:time_entry][:started_at]}").to_s

    # end
    # if params[:time_entry][:ended_at].present?
    #   args[:ended_at] = DateTime.parse("#{params[:time_entry][:year]}-#{params[:time_entry][:month]}-#{params[:time_entry][:day]} #{params[:time_entry][:ended_at]}").to_s
    # end
    args
  end

  def flash_message(message)
    super(message, TimeEntry)
  end

end