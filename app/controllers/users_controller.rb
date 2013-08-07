# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class UsersController < ApplicationController
  
  prepend_before_filter RubyCAS::Filter::GatewayFilter
  before_filter :check_permission
  

  # View for seeing existing admins and adding new ones
  def index
    @user = User.new
    @admins = User.where(:is_admin => true).order(:first_name, :last_name)
    @users = User.order(:first_name, :last_name) - @admins
  end



  # Adds a new admin
  def add_admin
    unless params[:user].blank? || params[:user][:id].blank?
      new_admin = User.find(params[:user][:id])
      new_admin.is_admin = true
      new_admin.save
      flash[:notice] = 'Officer added'
    end
    redirect_to users_path
  end



  private
  # Ensures that current user is an admin
    def check_permission
      unless @current_user.is_admin? 
        render_403
      end
    end
    
end