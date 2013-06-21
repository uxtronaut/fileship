class Setting < ActiveRecord::Base
  attr_accessible :name, :value
  validate :validate_all_settings


  # Validates the current app setting based on its code.
  def validate_all_settings
    if name == "Days until purge"
      unless (value.to_f > 0) && (value.to_f % 1 == 0)
        errors.add(:value, "Not a positive integer")
      end
    else
      unless value.blank? || value.index("http")
        errors.add(:value, "Must be a valid URL or blank")
      end
    end
  end

end
