class FeedbackController < ApplicationController

  def new
    @feedback = Feedback.new
  end

  def create

    # Create an issue and inject our project id and our tracker id
    @feedback = Feedback.new(params[:feedback])
    
    # Add our project id and tracker id
    @feedback.project_id = Feedback::PROJECT_ID
    @feedback.tracker_id = Feedback::TRACKER_ID
    
    # Add's current user's uid to the description at the end
    user = User.find_by_uid(session[:cas_user])
    @feedback.description = @feedback.description + "\r\n\nSubmitted by: #{user.first_name} #{user.last_name}, #{user.email}"
    
    # Dont bother conditionally determining response...
    # no matter what we show them the form again with 
    # proper message
    if @feedback.save_with_validation
      redirect_to thanks_feedback_index_path
    else
      render :action => 'new'
    end

  end

end
