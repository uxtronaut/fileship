class User < ActiveRecord::Base

  acts_as_osu_ldap_user
  after_osu_ldap_import :after_import

  attr_accessible :email, :first_name, :last_name

  attr_accessor :department, :title

  validates_presence_of :email, :uid
  validates_uniqueness_of :email, :uid
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/

  def after_import
    save!
    if home_folder.nil?
      folder = Folder.new(:name => uid)
      folder.parent = Folder.root
      folder.user = self
      folder.save!
    end
  end

  def self.osu_ldap_field_map
    return {
      :uid => [:uid],
      :first_name => [:givenname],
      :last_name => [:sn],
      :email => [:mail],
      :osu_id => [:osuid],
      :ldap_identifier  => [:osuuid, :uidnumber],
      :department => [:osudepartment],
      :title => [:title]
    }
  end

  def home_folder
    return Folder.where(:name => uid, :parent_id => Folder.root.id).first
  end

  def name
    return "#{first_name} #{last_name}"
  end

end