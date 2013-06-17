FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    is_admin false
    uid { Faker::Internet.user_name }
    email {|u| "#{u}@#{Faker::Internet.domain_name}.#{Faker::Internet.domain_suffix}" }
    after(:create) do |u|
      FactoryGirl.create(:home_folder, :name => u.uid)
    end
  end

  factory :admin, :parent => :user do
    is_admin true
  end
end