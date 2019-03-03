SELECT -- Surrogate Key Time
       "skTime"::integer
       -- Natural Key Time
     , "nkTime"::time(0) without time zone
       -- Name of the Period
     , CASE WHEN EXTRACT(HOUR FROM "nkTime") < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM "nkTime") < 18 THEN 'Afternoon'
            ELSE 'Evening'
       END::character varying(9) AS "NamePeri"
       -- Nome do Período
     , CASE WHEN EXTRACT(HOUR FROM "nkTime") < 6 THEN 'madrugada'
            WHEN EXTRACT(HOUR FROM "nkTime") < 12 THEN 'manhã'
            WHEN EXTRACT(HOUR FROM "nkTime") < 18 THEN 'tarde'
            ELSE 'noite'
       END::character varying(9) AS "NomePeri"
       -- Hour
     , to_char("nkTime", 'HH24:00:00')::time(0) without time zone AS "Hour"
       -- Half an Hour
     , CASE WHEN EXTRACT(MINUTE FROM "nkTime") < 30 THEN to_char("nkTime", 'HH24:00:00')::time(0) without time zone ELSE to_char("nkTime", 'HH24:30:00')::time(0) without time zone END AS "HalfHour"
  FROM (SELECT ("skTime" * 60)::integer AS "skTime"
             , '0:00'::time(0) without time zone + ("skTime" || ' minute')::interval AS "nkTime"
          FROM generate_series(0::integer, 1439::integer, 1/*parameter*/::integer) AS "skTime") AS "dimTime" x