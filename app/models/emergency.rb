class Emergency < ActiveRecord::Base
  self.primary_key = :code

  validates :fire_severity, :police_severity, :medical_severity,
            presence:     true,
            numericality: { greater_than_or_equal_to: 0 }

  validates :code, uniqueness: true, presence: true

  has_many :responders,                   foreign_key: :emergency_code
  has_many :emergency_responder_archives, foreign_key: :emergency_code
  has_many :archived_responders,          through: :emergency_responder_archives, source: :responder

  def each_type
    [ ['Fire',    fire_severity   ],
      ['Police',  police_severity ],
      ['Medical', medical_severity],
    ]
  end

  def as_json(*args, &block)
    super.merge responders:    responders.map(&:name),
                full_response: full_response?
  end

  def full_response?
    responders = archived_responders.to_a
    each_type.all? do |type, severity|
      severity <= responders.select { |r| r.type? type }
                            .inject(0) { |s, r| s + r.capacity }
    end
  end
end
