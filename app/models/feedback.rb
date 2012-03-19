class Feedback < ActiveResource::Base

  PROJECT_ID = 345
  TRACKER_ID = 10

  # Get ahold of AM validations for client side validation
  include ActiveModel::Validations
  validates_presence_of :subject, :description
  
  self.element_name = "issue"
  self.site = 'https://834300db6a2a7045c0e87a3617cbb1639a4e726c:X@cws.oregonstate.edu/create/'
  self.proxy = "http://proxy.oregonstate.edu:3128"

  # Define the attributes we want to access
  schema do
    attribute 'subject', :string
    attribute 'description', :text
    attribute 'project_id', :integer
    attribute 'tracker_id', :integer
  end
  
end