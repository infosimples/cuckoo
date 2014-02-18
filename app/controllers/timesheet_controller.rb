class TimesheetController < ApplicationController

  # GET /timesheet/:user_id(/:year/:month/:day)
  def show
    @users = User.all
    args = params.clone

    if args[:user_id].blank?
      args[:user_id] = current_user.id
    end

    if current_user.is_admin || (current_user.id == args[:user_id].to_i)
      if args[:year].present? && args[:month].present? && args[:day].present?
        @timesheet = Timesheet.new(args)
      else
        date = Time.zone.now
        redirect_to timesheet_url(user_id: args[:user_id], year: date.year, month: date.month, day: date.day)
      end
    else
      date = Time.zone.now
      redirect_to timesheet_url(user_id: current_user.id, year: date.year, month: date.month, day: date.day),
                    alert: flash_message(:have_no_right, User)
    end

  end

end