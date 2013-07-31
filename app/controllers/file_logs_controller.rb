# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class FileLogsController < ApplicationController

  prepend_before_filter RubyCAS::Filter::GatewayFilter
  before_filter :check_permission
    

  # View for seeing file logs
  def index
    @file_logs = FileLog.includes(:user, :user_file, :file_revisions).order("file_logs.created_at, file_revisions.created_at")
    @file_logs = search(params[:search])
    @users = User.order(:first_name, :last_name)
    @file_log = FileLog.new
  end




  private
    # Ensures that current user is site admin
    def check_permission
      unless @current_user.is_admin? 
        render_403
      end
    end
    
    
    
    # Limits displayed file logs to those maching the provided conditions
    def search(search)
      return @file_logs if search.blank?
      @user = search[:user]
      @name = search[:name]
      @size = search[:size]
      @downloads = search[:downloads]
      
      log_ids = FileRevision.where("file_name LIKE '%#{@name}%'").pluck(:file_log_id).uniq unless @name.blank? 
      
      search_string = ""
      search_array = ["true"]
      search_array << "users.id = #{@user} " unless @user.blank?
      search_array << "file_logs.downloads >= #{@downloads.to_f}" unless @downloads.blank? 
      search_array << "file_logs.size >= #{@size.to_f.kilobyte}" unless @size.blank? 
      search_string = search_array.join(" AND ")
      @file_logs = @file_logs.where(search_string)
      @file_logs = @file_logs.where("file_logs.id IN (?)", log_ids) unless log_ids.blank? 
      
      return @file_logs
    end
end
