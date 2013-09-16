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

class Setting < ActiveRecord::Base
  attr_accessible :name, :value
  validate :validate_all_settings


  # Validates the current app setting based on its code.
  def validate_all_settings
    if name.index("purge")
      unless (value.to_f > 0) && (value.to_f % 1 == 0)
        errors.add(:value, "Not a positive integer")
      end
      if name.index("log") && (value.to_f < Setting.find_by_name("Days until file purge").value.to_f)
        errors.add(:value, "Must be greater than 'Days until file purge'")
      end
    else
      unless value.blank? || value.index("http")
        errors.add(:value, "Must be a valid URL or blank")
      end
    end
  end

end
