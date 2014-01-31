class Users::RegistrationsController < Devise::RegistrationsController

  skip_before_filter :should_register_first_admin?, only: [:new_admin, :create_admin]
  before_filter :redirect_to_root_if_needed, only: [:new_admin, :create_admin]

  # GET /users/new_admin
  def new_admin
    @user = User.new
  end

  # POST /users/create_admin
  def create_admin
    @user = User.new(registration_params.merge(is_admin: true))

    if @user.save
      redirect_to new_user_session_path, notice: flash_message(:first_admin_created)
    else
      render action: :new_admin
    end
  end

  # Protected methods.
  protected

  #
  # Redirects the user to the root path if there's any user already registered.
  #
  def redirect_to_root_if_needed
    redirect_to(root_path) if User.any?
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def registration_params
    params.require(:user).permit(:name, :email, :is_admin, :password,
                                 :password_confirmation, :time_zone)
  end

  def flash_message(message)
    super(message, User)
  end

end