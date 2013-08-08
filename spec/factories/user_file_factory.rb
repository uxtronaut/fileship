include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user_file do
    user { FactoryGirl.create(:user)}
    folder { user.home_folder }
    attachment { fixture_file_upload(Rails.root.join('spec', 'files', 'test.png'), 'image/png') }
  end
end