module Capacities
  def self.counts
    results = ActiveRecord::Base.connection.execute(<<-SQL)
      SELECT type, sum(c) AS total, sum(u) AS unassigned, sum(d) AS on_duty, sum(a) AS available
      FROM (
        SELECT 'Fire' AS type, 0 AS c, 0 AS u, 0 AS d, 0 AS a
        UNION
        SELECT 'Police', 0, 0, 0, 0
        UNION
        SELECT 'Medical', 0, 0, 0, 0
        UNION
        SELECT type,
               capacity,
               ( CASE WHEN (emergency_code IS NULL)
                 THEN capacity ELSE 0 END
               ),
               ( CASE WHEN (on_duty = 't')
                 THEN capacity ELSE 0 END
               ),
               ( CASE WHEN (emergency_code IS NULL AND on_duty = 't')
                 THEN capacity ELSE 0 END
               )
        FROM responders
      )
      GROUP BY type
    SQL

    results.map { |result|
      type, *counts = result.select { |k, v| k.kind_of? Integer }.sort_by(&:first).map(&:last)
      [type, counts]
    }.to_h
  end
end
