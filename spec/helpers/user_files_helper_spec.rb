require 'spec_helper'

describe FoldersHelper do
  describe '#file_menu_item' do
    it 'should return a bunch of html in a string' do
      helper.file_menu_item("test", "icon-trash", 999).should eq "<a href=\"#test-file-modal-999\" data-toggle=\"modal\"><i class=\"icon-trash icon-large\"></i> test</a>"
    end
  end
end




