SELECT -- Surrogate Key Time
       "skTime"
       -- Natural Key Time
     , "nkTime"
       -- Name of the Period
     , CASE WHEN EXTRACT(HOUR FROM "nkTime") < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM "nkTime") < 18 THEN 'Afternoon'
            ELSE 'Evening'
       END AS "NamePeri"
       -- Nome do Período
     , CASE WHEN EXTRACT(HOUR FROM "nkTime") < 6 THEN 'madrugada'
            WHEN EXTRACT(HOUR FROM "nkTime") < 12 THEN 'manhã'
            WHEN EXTRACT(HOUR FROM "nkTime") < 18 THEN 'tarde'
            ELSE 'noite'
       END AS "NomePeri"
       -- Hour
     , to_char("nkTime", 'HH24:00')::character(5) AS "Hour"
       -- Half an Hour
     , CASE WHEN EXTRACT(MINUTE FROM "nkTime") < 30 THEN to_char("nkTime", 'HH24:00')::character(5) ELSE to_char("nkTime", 'HH24:30')::character(5) END AS "HalfHour"
  FROM (SELECT ("skTime" * 60)::integer AS "skTime"
             , '0:00'::time without time zone + ("skTime" || ' minute')::interval AS "nkTime"
          FROM generate_series(0::integer, 1439::integer, 1::integer) AS "skTime") AS "dimTime"