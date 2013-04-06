class TimesheetController < ApplicationController

  def show
    @week_summary = Timesheet.new(@current_user).week_hours
    @day_entries  = Timesheet.new(@current_user).day_entries(Time.zone.now)
  end

end