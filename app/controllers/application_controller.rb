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
    @logo_image_path =  Setting.find_by_name("Logo image path")
    @logo_image_path =  @logo_image_path.value  unless @logo_image_path.blank?
    @logo_url =         Setting.find_by_name("Logo url")
    @logo_url =         @logo_url.value         unless @logo_url.blank?
    @policy_path =      Setting.find_by_name("Policy path")
    @policy_path =      @policy_path.value      unless @policy_path.blank?
    @stylesheet_path =  Setting.find_by_name("Stylesheet path")
    @stylesheet_path =  @stylesheet_path.value  unless @stylesheet_path.blank?
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





# Helpers

  # Returns current user
  def current_user
    return @current_user
  end


  # Returns whether a user is signed in
  def signed_in?
    !!current_user
  end





# Error handling

  # Rescues internal server error with 500
  rescue_from Exception do |exception|
    respond_to do |format|
      format.html { render "pages/500.html.erb", :status => :internal_server_error, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 500, error...'}, :status => :rejected, :content_type => 'text/plain' }
    end
  end
  
  
  # Rescues from invalid record with 404
  rescue_from ActiveRecord::RecordNotFound do |exception|
    respond_to do |format|
      format.html { render "pages/404.html.erb", :status => :not_found, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 404, not found...'}, :status => :not_found, :content_type => 'text/plain' }
    end
  end
  
  
  # Rescues with non-existing page with 404
  rescue_from ActionController::RoutingError do |exception|
    respond_to do |format|
      format.html { render "pages/404.html.erb", :status => :not_found, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 404, not found...'}, :status => :not_found, :content_type => 'text/plain' }
    end
  end
 
 
  # Renders permission denied page
  def render_403
    respond_to do |format|
      format.html { render "pages/403.html.erb", :status => :forbidden, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 403, forbidden...'}, :status => :forbidden, :content_type => 'text/plain' }
    end
  end
  
 
  # Rescues unprocessible entity with 422
  rescue_from ActiveResource::ClientError do |exception|
    respond_to do |format|
      format.html { render "pages/422.html.erb", :status => :rejected, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 404, rejected...'}, :status => :rejected, :content_type => 'text/plain' }
    end
  end
  
end