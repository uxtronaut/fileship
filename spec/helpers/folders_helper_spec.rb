require 'spec_helper'

describe FoldersHelper do
  before do
    @current_user = FactoryGirl.create(:admin)
    @folder = FactoryGirl.create(:folder, :name => "test", :id => 999)
  end
  
  describe '#breadcrumbs' do
    it 'should return a bunch of html in a string' do
      helper.breadcrumbs(@folder).should eq "<li><a href=\"/folders/1\">Root folder</a></li><span class=\"divider\">/</span><li class=\"active\">test</li>"
    end
  end
  
  
  
  describe '#file_icon' do
    context "for known extension" do
      it 'should return path to correct image' do
        helper.file_icon("png").should eq "/assets/fileicons/png.png"
      end
    end
    
    
    context "for unknown extension" do
      it 'should return path to correct image' do
        helper.file_icon("awesome").should eq "/assets/fileicons/unknown.png"
      end
    end
  end
  
  
  
  describe '#upload_button' do
    it 'should return a bunch of html in a string' do
      helper.upload_button(@folder).should eq "<div data-folder-html-action=\"/folders/999\" data-ie-progress-image-src=\"/assets/loading.gif\" data-upload-action=\"/folders/999/user_files.json\" id=\"file-uploader\"><noscript><a href=\"/folders/999/user_files/new\" class=\"btn btn-large\" id=\"noscript-file-upload\"><i class=\"icon-upload-alt icon-large\"></i> Upload File</a></noscript></div>"
    end
  end
  
  
  
  describe '#ie_upload_button' do
    it 'should return a bunch of html in a string' do
      helper.ie_upload_button(@folder).should eq "<div id=\"ie-uploads-button\"><a href=\"/folders/999/user_files/new\" class=\"btn btn-large\"><i class=\"icon-upload-alt icon-large\"></i> Upload File</a></div>"
    end
  end
  
  
  
  describe '#new_folder_button' do
    it 'should return a bunch of html in a string' do
      helper.new_folder_button(@folder).should eq "<a href=\"/folders/999/folders/new\" class=\"btn btn-large\" data-toggle=\"modal\" id=\"new-folder-button\"><i class=\"icon-folder-open icon-large\"></i> New Folder</a>"
    end
  end
  
  
  
  describe '#dropdown_menu_toggle' do
    it 'should return a bunch of html in a string' do
      helper.dropdown_menu_toggle.should eq "<button class=\"btn dropdown-toggle\" data-toggle=\"dropdown\"><span class=\"caret\"></span></button>"
    end
  end
  
  
  
  describe '#rename_folder_menu_item' do
    it 'should return a bunch of html in a string' do
      helper.rename_folder_menu_item(@folder).should eq "<a href=\"#rename-folder-modal-999\" data-toggle=\"modal\"><i class=\"icon-edit icon-large\"></i> Rename</a>"
    end
  end
  
  
  
  describe '#delete_folder_menu_item' do
    it 'should return a bunch of html in a string' do
      helper.delete_folder_menu_item(@folder).should eq "<a href=\"#delete-folder-modal-999\" data-toggle=\"modal\"><i class=\"icon-trash icon-large\"></i> Delete</a>"
    end
  end
  
end




