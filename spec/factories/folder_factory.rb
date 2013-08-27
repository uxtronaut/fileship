FactoryGirl.define do

  factory :folder do
    parent { Folder.root }
    user { FactoryGirl.create(:user) }
    sequence(:name) {|n| "#{Faker::Lorem.words}#{n}" }
  end

  factory :root_folder, :parent => :folder do
    parent nil
    name 'Root folder'
  end

  factory :home_folder, :parent => :folder do
    parent do
      Folder.root || FactoryGirl.create(:root_folder)
    end
    name { Faker::Internet.user_name }
  end
end