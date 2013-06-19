# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class Folder < ActiveRecord::Base

  ROOT_NAME = 'Root folder'

  acts_as_tree :order => 'name'

  has_many :user_files, :dependent => :destroy, :order => 'lower(name)'
  belongs_to :user

  attr_accessible :name, :user_id

  validates_uniqueness_of :name, :scope => :parent_id
  validates_presence_of :name
  validates_presence_of :parent_id, :unless => lambda { Folder.all.empty? }

  def size
    size = 0
    user_files.collect {|file| size += file.attachment.file.size}
    size
  end

  def is_root?
    parent.nil? && !new_record?
  end

  def self.root
    find_by_name_and_parent_id(ROOT_NAME, nil)
  end

end