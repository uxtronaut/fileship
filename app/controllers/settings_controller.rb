# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class SettingsController < ApplicationController
  
  prepend_before_filter RubyCAS::Filter::GatewayFilter
  before_filter :check_permission
  before_filter :load_settings


  #
  def index
  end


  # Updates the application's settings based off selections made on "index" view. 
  def update_settings
    @settings.each do |setting|
      unless Setting.save_setting(setting, params[:setting][setting.name])
        @error = true
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


    def load_settings
      @days_until_purge_setting = Setting.find_by_name("days_until_purge")
      @logo_image_path_setting =  Setting.find_by_name("logo_image_path")
      @logo_url_setting =         Setting.find_by_name("logo_url")
      @policy_path_setting =      Setting.find_by_name("policy_path")
      @stylesheet_path_setting =  Setting.find_by_name("stylesheet_path")
      @settings = [@days_until_purge_setting, @logo_image_path_setting, @logo_url_setting, @policy_path_setting, @stylesheet_path_setting]
    end
end