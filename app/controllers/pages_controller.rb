# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class PagesController < ApplicationController

  prepend_before_filter RubyCAS::Filter::GatewayFilter

  def welcome
    if signed_in?
      redirect_to folders_path
      return
    end
    render :layout => 'dark'
  end

  def help
  end

  def feedback
  end

  def policy
  end

end
