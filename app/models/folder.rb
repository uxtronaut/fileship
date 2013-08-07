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
  validate :parent_id_unless_root

  # Only allows root folder to not have parent id
  def parent_id_unless_root
    if self.parent_id.blank?
      errors.add(:parent_id, "cannot be blank") unless Folder.all.blank? || Folder.first == self
    end
  end

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