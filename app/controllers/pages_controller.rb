class PagesController < ApplicationController

  prepend_before_filter RubyCAS::GatewayFilter

  def welcome
  end

end
