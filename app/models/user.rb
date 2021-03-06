# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  is_admin        :boolean
#  uid             :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  ldap_identifier :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class User < ActiveRecord::Base

  attr_accessible :email, :first_name, :last_name

  has_many :folders, :dependent => :destroy, :order => 'lower(name)'
  has_many :user_files, :dependent => :destroy

  validates_presence_of :email, :uid, :first_name, :last_name
  validates_uniqueness_of :email, :uid
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/


  # Loads a user by the provided uid. If none by that name exist, attempts to import them from ldap.
  def self.find_or_import(uid)
    return nil if uid.blank?
    user = User.find_by_uid(uid)
    return user unless user.blank?
    return User.import(uid)
  end


  # Imports the user's attributes from ldap using the provided uid, assigns them to a new user, and
  # gives them administrative privilages if they are the first user
  def self.import(uid) 
    return nil if uid.blank?
    user_information = User.ldap_search(uid)
    return nil if user_information.blank?
    ldap_config = Fileship::Application.config.ldap    
    new_user = User.new
    
    # Seperates the name into its appropriate components.
    name = user_information[:cn][0] unless user_information[:cn].blank?
    name = name.gsub(/[^a-z ]/i, '') 
    name = name.split(" ")
    if ldap_config['first_name_position'] == 2  && name.length == 2 
      new_user.first_name = user_information[1]
    end
    if ldap_config['last_name_position'] == 2  && name.length == 2 
      new_user.last_name = user_information[1]
    end

    # Creates the user
    new_user.uid = uid
    new_user.first_name = name[ldap_config['first_name_position']] if new_user.first_name.blank?
    new_user.last_name = name[ldap_config['last_name_position']] if new_user.last_name.blank?
    new_user.ldap_identifier = user_information[ldap_config['ldap_identifier']][0] unless user_information[ldap_config['ldap_identifier']].blank?
    new_user.email = user_information[:mail][0] unless user_information[:mail].blank?
    
    # If user is first one in application, makes them an administrator
    new_user.is_admin = true if User.all.blank?
    new_user.save
    return new_user unless new_user.blank?
    return nil
  end


  # Returns an array of user attributes retrieved from ldap based on the provided uid.
  def self.ldap_search(uid)
    return nil if uid.blank?
    ldap_config = Fileship::Application.config.ldap
    filter = Net::LDAP::Filter.eq("uid", uid)
    ldap = Net::LDAP.new :host => ldap_config['host'], 
                         :port => ldap_config['port'],
                         :encryption => ldap_config['encryption']
    user_information = ldap.search(:base => ldap_config['base'], 
                         :filter => filter)
    return nil if user_information.blank?
    user_information = user_information[0]
    return user_information
  end


  def self.admins
    User.where(:is_admin => true).order(:first_name, :last_name)
  end


  # Returns the user's home folder
  def home_folder
    folder = Folder.where(:name => uid, :parent_id => Folder.root.id).first
    if folder.blank?
      folder = Folder.new(:name => uid)
      folder.parent = Folder.root
      folder.user = self
      folder.save!
    end
    return folder
  end


  # Returns the user's full name
  def name
    return "#{first_name} #{last_name}"
  end

end
