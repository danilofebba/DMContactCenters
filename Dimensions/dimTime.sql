DECLARE @Minute integer = 1 /*Parameter*/
;WITH [dimTime] AS (
    SELECT CAST('00:00:00' AS time(0)) AS [nkTime]
     UNION ALL
    SELECT CAST(DATEADD(MINUTE, @Minute, [nkTime]) AS time(0)) FROM [dimTime]
)
SELECT -- Surrogate Key Time
       CAST(DATEDIFF(SECOND, CAST('00:00:00' AS time(0)), [nkTime]) AS integer) AS [skTime]
       -- Natural Key Time
     , CAST([nkTime] AS time(0)) AS [nkTime]
       -- Name of the Period
     , CAST(CASE WHEN DATEPART(HOUR, [nkTime]) < 12 THEN 'Morning'
                 WHEN DATEPART(HOUR, [nkTime]) < 18 THEN 'Afternoon'
                 ELSE 'Evening'
            END AS varchar(9)) AS [NamePeri]
       -- Nome do Período
     , CAST(CASE WHEN DATEPART(HOUR, [nkTime]) < 6 THEN 'madrugada'
                 WHEN DATEPART(HOUR, [nkTime]) < 12 THEN 'manhã'
                 WHEN DATEPART(HOUR, [nkTime]) < 18 THEN 'tarde'
                 ELSE 'noite'
            END AS varchar(9)) AS [NomePeri]
       -- Hour
     , CAST(CONVERT(char(3), [nkTime]) + '00' AS char(5)) AS [Hour]
       -- Half an Hour
     , CAST(CASE WHEN DATEPART(MINUTE, [nkTime]) < 30 THEN CONVERT(char(3), [nkTime]) + '00' ELSE CONVERT(char(3), [nkTime]) + '30' END AS char(5)) AS [HalfHour]
  FROM [dimTime] OPTION (MAXRECURSION 1439 /*Parameter*/)