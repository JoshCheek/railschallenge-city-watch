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
