class TimesheetController < ApplicationController

  # GET /timesheet(/:year/:month/:day)
  def show
    if params[:year].present? && params[:month].present? && params[:day].present?
      @date = Time.zone.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
      @week_summary = Timesheet.new(current_user).week_hours
      @day_entries  = Timesheet.new(current_user).day_entries(@date)
    else
      date = Time.zone.now
      redirect_to timesheet_url(year: date.year, month: date.month, day: date.day)
    end
  end
end