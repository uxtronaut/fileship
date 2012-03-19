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

    # Dont bother conditionally determining response...
    # no matter what we show them the form again with 
    # proper message
    if @feedback.save_with_validation
      redirect_to new_feedback_path, :notice => 'Thank you for your feedback.'
    else
      render :action => 'new'
    end

  end

end
