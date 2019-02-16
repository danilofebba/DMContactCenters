SELECT ("skTime" * 60)::integer AS "skTime"
     , '0:00'::time without time zone + ("skTime" || ' minute')::interval AS "nkTime"
  FROM generate_series(0::integer, 1439::integer, 1::integer) AS "skTime"