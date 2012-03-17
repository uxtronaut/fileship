class Folder < ActiveRecord::Base
  acts_as_tree :order => 'name'

  has_many :user_files, :dependent => :destroy

  attr_accessible :name, :user_id

  validates_uniqueness_of :name, :scope => :parent_id
  validates_presence_of :name
  validates_presence_of :parent_id, :unless => lambda { Folder.all.empty? }

  def parent_of?(folder)
    self.children.each do |child|
      if child == folder
        return true
      else
        return child.parent_of?(folder)
      end
    end
    false
  end

  def is_root?
    parent.nil? && !new_record?
  end

  def has_children?
    children.count > 0
  end

  def self.root
    find_by_name_and_parent_id('Root folder', nil)
  end

end