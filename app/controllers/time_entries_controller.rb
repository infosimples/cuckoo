class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: [:show, :update, :destroy]

  def show
  end

  # GET /time_entries/new
  def new
    @time_entry = TimeEntry.new
  end

  # GET /time_entries/:id/edit
  def edit
  end

  # POST /time_entries
  def create
    @time_entry = TimeEntry.new(time_entry_params.merge(user: @current_user))
    respond_to do |format|
      if @time_entry.save
        # TODO: redirect to show but show the time_entry day
        format.html { redirect_to action: show, notice: flash_message(:create_success) }
        format.json { render action: 'show', status: :created, location: @time_entry }
      else
        format.html { render action: 'show' }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_entries/:id
  def update
    respond_to do |format|
      if @time_entry.update(time_entry_params)
        format.html { redirect_to @time_entry, notice: flash_message(:update_success) }
        format.json { render action: 'show', status: :created, location: @time_entry }
      else
        format.html { render action: 'edit' }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_entries/:id
  def destroy
    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to time_entrys_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_time_entry
    @time_entry = TimeEntry.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def time_entry_params
    params.require(:time_entry).permit(:started_at, :ended_at, :project_id, :task_id, :description)
  end

  def flash_message(message)
    super(message, TimeEntry)
  end

end