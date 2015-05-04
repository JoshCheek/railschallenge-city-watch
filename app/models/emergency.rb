class Emergency < ActiveRecord::Base
  self.primary_key = :code

  validates :fire_severity, :police_severity, :medical_severity,
            presence:     true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :code, uniqueness: true, presence: true
end
