# == Schema Information
#
# Table name: user_files
#
#  id         :integer          not null, primary key
#  attachment :string(255)
#  name       :string(255)
#  link_token :string(255)
#  password   :string(255)
#  folder_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user_file do
    user { FactoryGirl.create(:user)}
    folder { user.home_folder }
    attachment { fixture_file_upload(Rails.root.join('spec', 'files', 'test.png'), 'image/png') }
  end
end
