class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  # TODO: fix for JSON!
  # protect_from_forgery with: :exception

  #
  # Filters.
  #
  before_filter :set_user_time_zone, :should_register_first_admin?, :authenticate_user!

  def settings
    @settings ||= Setting.first_or_create
  end
  helper_method :settings

  def working_date(params)
    params.permit(:year,:month,:day)
    { year: params[:year], month: params[:month], day: params[:day] }
  end
  helper_method :working_date

  protected

  def flash_message(message, model)
    I18n.t(message, scope: :flash_messages, model: model.model_name.human)
  end

  def set_user_time_zone
    Setting.first_or_initialize.setup_time_zone
  end

  #
  # Checks if it is necessary to create the first admin.
  #
  def should_register_first_admin?
    unless User.any?
      redirect_to controller: 'users/registrations', action: 'new_admin'
    end
  end

  def allow_admin_only
    unless current_user.is_admin?
      redirect_to :root
    end
  end

end