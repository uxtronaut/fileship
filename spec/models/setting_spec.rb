# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  value       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Setting do
  pending "add some examples to (or delete) #{__FILE__}"
end
