class Emergency < ActiveRecord::Base
  establish_connection adapter: 'sqlite3', database: ':memory:'

  connection.create_table table_name, id: false do |t|
    t.string  :code
    t.integer :fire_severity,    null: false
    t.integer :police_severity,  null: false
    t.integer :medical_severity, null: false
  end

  self.primary_key = :code

  validates :fire_severity, :police_severity, :medical_severity,
            presence:     true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :code, uniqueness: true, presence: true
end
