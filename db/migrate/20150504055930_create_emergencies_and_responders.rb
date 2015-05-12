class CreateEmergenciesAndResponders < ActiveRecord::Migration
  def change
    create_table :emergencies, id: false do |t|
      t.string   :code
      t.integer  :fire_severity,    null: false
      t.integer  :police_severity,  null: false
      t.integer  :medical_severity, null: false
      t.datetime :resolved_at
    end

    create_table :emergency_responder_archives do |t|
      t.string :emergency_code
      t.string :responder_name
    end

    create_table :responders, id: false do |t|
      t.string  :name
      t.string  :type
      t.integer :capacity
      t.string  :emergency_code
      t.boolean :on_duty, default: false
    end
  end
end
