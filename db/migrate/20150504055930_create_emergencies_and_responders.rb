class CreateEmergenciesAndResponders < ActiveRecord::Migration
  def change
    create_table :emergencies, id: false do |t|
      t.string  :code
      t.integer :fire_severity,    null: false
      t.integer :police_severity,  null: false
      t.integer :medical_severity, null: false
    end

    create_table :responders, id: false do |t|
      t.string  :type
      t.string  :name
      t.integer :capacity
      t.string  :emergency_code
      t.boolean :on_duty, default: false
    end
  end
end
