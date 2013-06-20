# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_settings
  before_filter :get_current_user
  helper_method :current_user, :signed_in?

  
  # Loads settings specified in app.yml
  def load_settings
    settings = Fileship::Application.config.fileship_config
    @policy_path = settings['policy_path']
    @stylesheet_path = settings['stylesheet_path']
    @logo_image_path = settings['logo_image_path']
    @logo_url = settings['logo_url']
  end
  

  # Retrieves current user if they are in the application, or attempts to add them using information
  # from ldap. 
  def get_current_user
    if session[:cas_user]
      uid = session[:cas_user]
      @current_user = User.find_or_import(uid)
      # Ensure the user was successfully retrieved from ldap. If no information for them is
      # available, the app is unusable, so we need to let them try to log in again
      unless @current_user
        Rails.logger.error "Valid CAS session, but no LDAP record for " + uid
        RubyCAS::Filter.logout(self, welcome_url)
        return
      end
    end
  end


  # Destroys current user's session, redirects to CAS login page.
  def signout
    RubyCAS::Filter.logout(self, welcome_url)
  end


  # Renders permission denied page
  def render_403
    respond_to do |format|
      format.html { render :file => Rails.root.join('public', '403.html'), :status => :forbidden, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 403, forbidden...'}, :status => :forbidden, :content_type => 'text/plain' }
    end
  end


  # Renders not found page
  def render_404
    respond_to do |format|
      format.html { render :file => Rails.root.join('public', '404.html'), :status => :not_found, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 404, not found...'}, :status => :not_found, :content_type => 'text/plain' }
    end
  end


  # Renders rejected page
  def render_422
    respond_to do |format|
      format.html { render :file => Rails.root.join('public', '422.html'), :status => :rejected, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 422, rejected...'}, :status => :rejected, :content_type => 'text/plain' }
    end
  end
  
  
  # Renders internal server error page
  def render_500
    respond_to do |format|
      format.html { render :file => Rails.root.join('public', '500.html'), :status => :error, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 500, internal server error...'}, :status => :error, :content_type => 'text/plain' }
    end
  end


  # Returns current user
  def current_user
    return @current_user
  end


  # Returns whether a user is signed in
  def signed_in?
    !!current_user
  end

end