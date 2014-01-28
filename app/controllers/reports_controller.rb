class ReportsController < ApplicationController

  # GET /reports
  def new
  end

  # POST /reports
  def view

    @time_entries = TimeEntry.order(:started_at)

    if report_params[:start_date].present?
      @time_entries = @time_entries.where('DATE(started_at) >= ?', "#{report_params[:start_date]}")
      @start_date   = Date.parse(report_params[:start_date]).strftime("%B %d, %Y")
    end

    if report_params[:end_date].present?
      @time_entries = @time_entries.where('DATE(started_at) <= ?', report_params[:end_date])
      @end_date     = Date.parse(report_params[:end_date]).strftime("%B %d, %Y")
    end

    if report_params[:project_id].present?
      @time_entries = @time_entries.where(project_id: report_params[:project_id])
      @project      = Project.find_by_id(report_params[:project_id])
    end

    if report_params[:user_id].present?
      @time_entries = @time_entries.where(user_id: report_params[:user_id])
      @user         = User.find_by_id(report_params[:user_id])
    end

    if report_params[:task_id].present?
      @time_entries = @time_entries.where(task_id: report_params[:task_id])
      @task         = Task.find_by_id(report_params[:task_id])
    end

    if report_params[:is_billable] == '1'
      @time_entries = @time_entries.where(is_billable: true)
      @is_billable  = true
    end

    @total_time = @time_entries.sum(:total_time)

  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params.require(:report).permit(:project_id, :user_id, :task_id, :start_date, :end_date, :is_billable)
  end

end