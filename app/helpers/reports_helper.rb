module ReportsHelper

  def all_projects
    Project.all
  end

  def all_users
    User.all
  end

  def all_tasks
    Task.all
  end

  def total_time_info(seconds)
    "#{number_with_precision(@total_time.to_f / (60 * 60), precision: 2)} hours"
  end

end
