class PagesController < ApplicationController

  prepend_before_filter RubyCAS::GatewayFilter

  def welcome
    redirect_to folders_path if signed_in?
  end

  def help
  end

  def feedback
  end

  def policy
  end

end
