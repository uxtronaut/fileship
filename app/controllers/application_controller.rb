class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :get_current_user

  helper_method :current_user, :signed_in?

  def get_current_user
    if session[:cas_user]
      uid = session[:cas_user]

      @current_user = User.find_or_import(uid)

      # Ensure the user was successfully retrieved from ldap. If no information for them is
      # available, the app is unusable, so we need to let them try to log in again
      unless @current_user
        Rails.logger.error "Valid CAS session, but no LDAP record for " + uid
        # Destroy old session
        session[:cas_user] = nil
        redirect_to RubyCAS::Filter.login_url(self)
        return
      end
    end
  end

  def signout
    RubyCAS::Filter.logout(self, welcome_url)
  end

  def render_403
    respond_to do |format|
      format.html { render :file => Rails.root.join('public', '403.html'), :status => :forbidden, :layout => 'dark' }
      format.json { render :json => {:error => 'Error 403, forbidden...'}, :status => :forbidden }
    end
  end

  def current_user
    return @current_user
  end

  def signed_in?
    !!current_user
  end

end