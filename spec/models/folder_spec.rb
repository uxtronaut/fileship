require 'spec_helper'

describe Folder do
  describe 'validations' do
    it 'requires a name' do
      folder = FactoryGirl.build(:folder, :name => nil)
      folder.should_not be_valid
      folder.should have(1).error_on(:name)
    end

    it 'allows one folder without a parent (root)' do
      root = Folder.root
      root.parent.should be_nil
      root.name.should eq('Root folder')
      root.should be_valid
    end

    it 'requires a parent for non-root folders' do
      root = Folder.root
      folder = FactoryGirl.build(:folder, :parent => nil)
      folder.should_not be_valid
      folder.should have(1).error_on(:parent_id)
    end

    it "doesn't allow multiple folders with the same name under a parent" do
      parent_folder = FactoryGirl.create(:folder)
      child_1 = FactoryGirl.create(:folder, :parent => parent_folder)
      child_2 = FactoryGirl.build(:folder, :parent => parent_folder, :name => child_1.name)
      child_2.should_not be_valid
      child_2.should have(1).error_on(:name)
    end
  end

  describe '#is_root?' do
    before do
      @root = Folder.root
    end

    it 'returns true for the root folder' do
      @root.should be_is_root
    end

    it 'returns false for non-root folder' do
      folder = FactoryGirl.create(:folder)
      folder.should_not be_is_root
    end
  end

  describe '.root' do
    it 'returns the root folder' do
      root = Folder.root
      root.should_not eq nil
      Folder.root.should eq root
    end
  end
end