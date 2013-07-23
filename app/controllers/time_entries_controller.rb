class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: [:show, :update, :destroy, :finish, :edit]

  # GET /time_entries/new
  def new
    @time_entry = TimeEntry.new
  end

  # GET /time_entries/:id/edit
  def edit
  end

  # POST /time_entries
  def create
    @time_entry = TimeEntry.new(time_entry_params.merge(user: current_user))

    if @time_entry.save
      redirect_to({
        controller: :timesheet,
        action:     :show,
        year:       @time_entry.started_at.year,
        month:      @time_entry.started_at.month,
        day:        @time_entry.started_at.day
      })

    else
      render action: 'new'
    end
  end

  # PATCH/PUT /time_entries/:id
  def update
    puts params.inspect
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
    unless @time_entry.stop
      flash[:notice] = flash_message(:timer_not_stopped)
    end

    redirect_to controller: :timesheet, action: :show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_time_entry
    if current_user.is_admin?
      @time_entry = TimeEntry.find(params[:id])
    else
      @time_entry = TimeEntry.where(id: params[:id], user_id: current_user.id).first
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def time_entry_params
    args = params.require(:time_entry).permit(:project_id, :task_id, :description, :start_time, :end_time)

    hsh = params[:time_entry]

    args[:entry_date] = "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    args[:start_time] = (hsh[:start_time].present? ? hsh[:start_time] : Time.zone.now)
    args[:end_time]   = hsh[:end_time]

    args
  end

  def date_from_time_entry
    year  = @time_entry.started_at.year
    month = @time_entry.started_at.month
    day   = @time_entry.started_at.day

    { year: year, month: month, day: day }
  end

  def flash_message(message)
    super(message, TimeEntry)
  end

end