class SettingsController < ApplicationController

  before_filter :allow_admin_only

  # GET /settings
  # GET /settings.json
  def index
  end

  # PATCH/PUT /settings/:id
  # PATCH/PUT /settings/:id.json
  def update
    respond_to do |format|
      if settings.update(setting_params)
        format.html { redirect_to settings_url, notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'index' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def setting_params
    params.require(:setting).permit(:time_zone)
  end
end
