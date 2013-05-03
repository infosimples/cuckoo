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
    activities
  end

  # GET /time_entries/:id/edit
  def edit
    @time_entry = TimeEntry.find(params[:id])
    activities
  end

  # POST /time_entries
  def create
    @time_entry = TimeEntry.new(time_entry_params.merge(user: @current_user))

    if @time_entry.save
      # TODO: redirect to show but show the time_entry day
      redirect_to({ controller: 'timesheet', action: 'show' }.merge(working_date(params)))
    else
      activities
      render action: 'new'
    end


  end

  # PATCH/PUT /time_entries/:id
  def update
    activities

    if @time_entry.update(time_entry_params)
      redirect_to({ controller: 'timesheet', action: 'show' }.merge(date_from_time_entry))
    else
      render action: 'edit'
    end

  end

  # DELETE /time_entries/:id
  def destroy
    @time_entry.destroy
    redirect_to({ controller: 'timesheet', action: 'show' }.merge(date_from_time_entry))
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

    args
  end

  def flash_message(message)
    super(message, TimeEntry)
  end

  def activities
    @projects = Project.all
    @tasks = Task.all
  end

  def date_from_time_entry
    year = @time_entry.started_at.year
    month = @time_entry.started_at.month
    day = @time_entry.started_at.day

    {year: year, month: month, day: day}

  end

end