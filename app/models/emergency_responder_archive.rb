class EmergencyResponderArchive < ActiveRecord::Base
  belongs_to :emergency, foreign_key: :emergency_code
  belongs_to :responder, foreign_key: :responder_name
end
