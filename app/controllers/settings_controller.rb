# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class SettingsController < ApplicationController
  
  prepend_before_filter RubyCAS::Filter::GatewayFilter
  before_filter :check_permission
  skip_before_filter :load_settings


  #
  def index
    @settings = Setting.order(:name)
  end



  # Updates the application's settings based off selections made on "index" view. 
  def update_settings
    unless params[:settings].blank?
      @settings = []
      params[:settings].each do |setting|
        updated_setting = Setting.find(setting.last["id"])
        @error = true unless updated_setting.update_attributes(setting.last)
        @settings << updated_setting
      end
      if @error
        render :index
        return
      end
    end
    redirect_to settings_path, :notice => 'Settings updated'
  end



  private
    def check_permission
      unless @current_user.is_admin? 
        render_403
      end
    end
    
end