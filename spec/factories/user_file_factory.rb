include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user_file do
    folder
    attachment { fixture_file_upload(Rails.root.join('spec', 'files', 'test.png'), 'image/png') }
  end
end