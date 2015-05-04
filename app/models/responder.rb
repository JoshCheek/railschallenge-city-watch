class Responder < ActiveRecord::Base
  establish_connection adapter: 'sqlite3', database: ':memory:'

  # TODO: migration
  connection.create_table table_name, id: false do |t|
    t.string  :type
    t.string  :name
    t.integer :capacity
    t.string  :emergency_code
    t.boolean :on_duty, default: false
  end

  self.primary_key        = :name
  self.inheritance_column = nil

  validates :capacity, presence: true, inclusion: { in: 1..5 }
  validates :type,     presence: true
  validates :name,     presence: true, uniqueness: true

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

  # not currently assigned to an emergency
  def available?
    !emergency_code
  end

  def type?(type)
    self.type == type
  end

  # TODO: can I delete this?
  def as_json(*)
    { emergency_code: emergency_code,
      type:           type,
      name:           name,
      capacity:       capacity,
      on_duty:        on_duty,
    }
  end
end
