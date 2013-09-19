require 'spec_helper'

describe ApplicationHelper do
  describe '#tophat_tag' do
    it 'should return nothing if image is blank' do
      helper.tophat_tag(nil, "www.example.com").should eq nil
    end
  end
  
  
  
  describe '#flash_messages' do
    context 'with no message' do
      before do
        flash[:notice] = nil
        flash[:alert] = nil
      end
      
      it 'should return empty string ' do
        helper.flash_messages.should eq ""
      end
    end
    
    
    context 'with notice message' do
      before do
        flash[:notice] = "test"
        flash[:alert] = nil
      end
      
      it 'should return a bunch of html in a string' do
        helper.flash_messages.should eq "<div class=\"alert alert-success\" data-alert=\"alert\" id=\"notice\"><h4 class=\"alert-heading\">test</h4></div>"
      end
    end
    
    
    context 'with alert message' do
      before do
        flash[:notice] = nil
        flash[:alert] = "test"
      end
      
      it 'should return a bunch of html in a string' do
        helper.flash_messages.should eq "<div class=\"alert alert-error\" id=\"alert\"><h4 class=\"alert-heading\">test</h4></div>"
      end
    end
  end
  
  
end













