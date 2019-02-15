
SELECT "nkTime"
  FROM generate_series('00:00:00'::time without time zone,'23:59:59'::time without time zone,interval '30 minute') AS "nkTime";