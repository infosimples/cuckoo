class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :destroy]
  before_filter :allow_admin_only, except: [:edit, :update]
  before_filter :check_user_update_privilege, only: [:edit, :update]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users/create
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to action: :index, notice: flash_message(:create_success) }
        format.json { render action: :show, status: :created, location: @user }
      else
        format.html { render action: :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/:id/edit
  def edit
  end

  # PATCH/PUT /users/:id
  def update
    current_user_id = current_user.id

    respond_to do |format|
      successfully_updated = if user_params[:password].blank?
        @user.update_without_password(user_params)
      else
        @user.update(user_params)
      end

      if successfully_updated
        sign_in(User.find_by_id(current_user_id), bypass: true) if current_user_id == @user.id
        format.html { redirect_to users_path, notice: flash_message(:update_success) }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @user.erros, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    redirect_to action: :index
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :is_admin, :password,
                                 :password_confirmation, :time_zone)
  end

  def check_user_update_privilege
    if !(current_user.is_admin? or current_user.id == params[:id].to_i)
      redirect_to :root, alert: flash_message(:have_no_right)
    end
  end

  def flash_message(message)
    super(message, User)
  end

end
