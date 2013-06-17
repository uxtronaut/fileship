class Feedback < ActiveResource::Base
    
  # Get ahold of AM validations for client side validation
  include ActiveModel::Validations
  validates_presence_of :subject, :description
  
  feedback_config = Fileship::Application.config.feedback
  self.element_name = "issue"
  self.site = feedback_config["site"]
  self.proxy = feedback_config["proxy"]

  # Define the attributes we want to access
  schema do
    attribute 'subject', :string
    attribute 'description', :text
    attribute 'project_id', :string
    attribute 'tracker_id', :integer
  end
  
end