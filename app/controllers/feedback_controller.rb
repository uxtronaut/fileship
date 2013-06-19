class FeedbackController < ApplicationController

  prepend_before_filter RubyCAS::Filter
  

  def new
    @feedback = Feedback.new
  end


  def create
    # Load feedback configurations
    feedback_config = Fileship::Application.config.feedback
            
    # Add our project id and tracker id
    @feedback = Feedback.new(params[:feedback])
    @feedback.project_id = feedback_config["project_id"]
    @feedback.tracker_id = feedback_config["tracker_id"]
    
    unless @feedback.subject.blank? || @feedback.description.blank?
      # Prepends subject line 
      @feedback.subject = feedback_config['prepend_subject'] + @feedback.subject unless feedback_config['prepend_subject'].blank?
      
      # Add's current user's uid to the description at the end
      @feedback.description = @feedback.description + "\r\n\nSubmitted by: #{@current_user.name},  #{@current_user.email}"
    end
    
    # Thanks user for feedback unless they forgot a field
    if @feedback.save_with_validation
      redirect_to thanks_feedback_index_path
    else
      render :action => 'new'
    end
  end

end
