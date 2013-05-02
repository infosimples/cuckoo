class TimesheetController < ApplicationController

  def show
    if params[:year].present? and params[:month].present? and params[:day].present?
      @date = Time.zone.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
      @week_summary = Timesheet.new(@current_user).week_hours
      @day_entries  = Timesheet.new(@current_user).day_entries(@date)
    else
      date = Time.zone.now
      redirect_to timesheet_url(year: date.year, month: date.month, day: date.day)
    end
  end
end