class Responder < ActiveRecord::Base
  self.primary_key        = :name
  self.inheritance_column = nil

  validates :capacity, presence: true, inclusion: { in: 1..5 }
  validates :type,     presence: true
  validates :name,     presence: true, uniqueness: true

  belongs_to :emergency, foreign_key: :emergency_code

  def self.available
    where on_duty: true, emergency_code: nil
  end

  # TODO: extract
  def self.capacity_counts
    responders = all.to_a

    count_capacity = lambda do |responders|
      responders.map(&:capacity).inject(0, :+)
    end

    counts_for = lambda do |type|
      for_type  = responders.select { |r| r.type? type }
      available = for_type.select &:available?
      on_duty   = for_type.select &:on_duty?
      [ count_capacity.(for_type),
        count_capacity.(available),
        count_capacity.(on_duty),
        count_capacity.(available & on_duty),
      ]
    end

    { 'Fire'    => counts_for.('Fire'),
      'Police'  => counts_for.('Police'),
      'Medical' => counts_for.('Medical'),
    }
  end

  def available?
    !emergency_code
  end

  def type?(type)
    self.type == type
  end
end
