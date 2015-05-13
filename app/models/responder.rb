class Responder < ActiveRecord::Base
  self.primary_key        = :name
  self.inheritance_column = nil

  validates :capacity, presence: true, inclusion: { in: 1..5 }
  validates :type,     presence: true
  validates :name,     presence: true, uniqueness: true

  belongs_to :emergency,                    foreign_key: :emergency_code
  has_many   :emergency_responder_archives, foreign_key: :responder_name
  has_many   :archived_emergencies,         through: :emergency_responder_archives, source: :emergency

  def self.available
    where on_duty: true, emergency_code: nil
  end

  def available?
    !emergency_code
  end

  def type?(type)
    self.type == type
  end
end
