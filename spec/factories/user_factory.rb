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

FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    is_admin false
    uid { Faker::Internet.user_name }
    email {|u| "#{u}@#{Faker::Internet.domain_name}.#{Faker::Internet.domain_suffix}" }
    after(:create) do |u|
      FactoryGirl.create(:home_folder, :name => u.uid, :user => u)
    end
  end

  factory :admin, :parent => :user do
    is_admin true
  end
end
