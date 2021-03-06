IF (NOT EXISTS (SELECT * FROM [sys].[schemas] WHERE [name] = '[DW]'))
BEGIN
    -- Data Warehouse Schema
    EXEC('CREATE SCHEMA [DW]')
END;
GO

IF (EXISTS(SELECT * FROM [INFORMATION_SCHEMA].[TABLES] WHERE [TABLE_SCHEMA] = '[DW]' AND [TABLE_NAME] = '[dmCale]'))
BEGIN
    -- Calendar Dimension Table
    EXEC('DROP TABLE [DW].[dmCale]')
END;
GO

CREATE TABLE [DW].[dmCale] (
    [skDate]          integer     NOT NULL,          -- Surrogate Key of the Date
    [nkDate]          date        NOT NULL,          -- Natural Key of the Date
    [nkUnixEpoc]      integer         NULL,          -- Surogate Key of Posix Time or Unix Epoch or Unix Timestamp
    [Year]            smallint        NULL,          -- Year
    [FullNameSeme]    char(13)        NULL,          -- Full Name of Semester
    [ShorNameSeme]    char(7)         NULL,          -- Short Name of Semester
    [NomeSeme]        char(12)        NULL,          -- Nome do Semestre

    [NomeCompTrim]    varchar(1)     NULL,          -- Nome Completo do Trimestre
    [NomeAbreTrim]    varchar(2)      NULL,          -- Nome Abreviado do Trimestre
    [NumeMes]         tinyint         NULL,          -- Número do Mês
    [NomeCompMes]     varchar(8)      NULL,          -- Nome Completo do Mês
    [NomeAbreMes]     varchar(3)      NULL,          -- Nome Abreviado do Mês
    [UltiDiaMes]      tinyint         NULL,          -- Último Dia do Mês
    [NumeQuin]        tinyint         NULL,          -- Número da Quianzena
    [NomeQuin]        varchar(11)     NULL,          -- Nome da Quianzena
    [NumeSemaAno]     tinyint         NULL,          -- Número da Semana do Ano (ISO 8601)
    [NomeCompSemaAno] varchar(33)     NULL,          -- Nome Completo da Semana do Ano (ISO 8601)
    [NomeAbreSemaAno] varchar(8)      NULL,          -- Nome Abreviado da Semana do Ano (ISO 8601)
    [NumeDiaSema]     tinyint         NULL,          -- Número do Dia da Semana
    [NomeCompDiaSema] varchar(13)     NULL,          -- Nome Completo do Dia da Semana
    [NomeAbreDiaSema] varchar(3)      NULL,          -- Nome Abreviado do Dia da Semana
    [Dia]             tinyint         NULL,          -- Dia
    [NumeDiaAno]      smallint        NULL,          -- Número do Dia do Ano
);
-- Primary Key Constraint of the Calendar Dimension Table
ALTER TABLE [DW].[dmCale] ADD CONSTRAINT [pkDimeCale] PRIMARY KEY ([skDate]);
GO

DECLARE @StartDate date = CONVERT(varchar(4), YEAR(GETDATE())) + '-01-01';
DECLARE @EndDate date = DATEADD(DAY, -1, DATEADD(YEAR, 1, @StartDate));
DECLARE @Date date = @StartDate;
SET DATEFIRST 1

WHILE @Date <= @EndDate
BEGIN
    INSERT INTO [DW].[dmCale] (
        [skDate],
        [nkDate],
        [nkUnixEpoc]) 
    VALUES (
        CONVERT(integer, CONVERT(varchar(8), @Date, 112)),
        @Date,
        CONVERT(integer, DATEDIFF(SECOND, {d '1970-01-01'}, @Date)));
    SET @Date = DATEADD(DAY, 1, @Date);
END;

SET @Date = @StartDate;
SET LANGUAGE us_english;

WHILE @Date <= @EndDate
BEGIN
    UPDATE [DW].[dmCale]
       SET [year]         = CONVERT(smallint, YEAR(@Date))
         , [FullNameSeme] = CONVERT(char(13), CASE WHEN MONTH(@Date) < 7 THEN CONVERT(char(4), YEAR(@Date)) + ' 1st Half' ELSE CONVERT(char(4), YEAR(@Date)) + ' 2nd Half' END)
         , [ShorNameSeme] = CONVERT(char(7), CASE WHEN MONTH(@Date) < 7 THEN CONVERT(char(4), YEAR(@Date)) + ' 1H' ELSE CONVERT(char(4), YEAR(@Date)) + ' 2H' END)

     WHERE [nkDate] = @Date
    SET @Date = DATEADD(DAY, 1, @Date);
END;

SET @Date = @StartDate;
SET LANGUAGE portuguese;

WHILE @Date <= @EndDate
BEGIN
    UPDATE [DW].[dmCale]
       SET [NomeSeme] = CONVERT(char(12), CASE WHEN MONTH(@Date) < 7 THEN CONVERT(char(4), YEAR(@Date)) + ' 1º sem.' ELSE CONVERT(char(4), YEAR(@Date)) + ' 2º sem.' END)
         
     WHERE [nkDate] = @Date
    -- INSERT INTO [DW].[dmCale]
    --     SELECT [NomeCompTrim]    = CONVERT(varchar(12), CASE DATEPART(QUARTER, @Data)
    --                                                         WHEN 1 THEN '1º trimestre'
    --                                                         WHEN 2 THEN '2º trimestre'
    --                                                         WHEN 3 THEN '3º trimestre'
    --                                                         ELSE '4º trimestre'
    --                                                     END)
    --          , [NomeAbreTrim]    = CONVERT(varchar(2), 'T' + CONVERT(varchar(1), DATEPART(QUARTER, @Data)))
    --          , [NumeMes]         = CONVERT(tinyint, MONTH(@Data))
    --          , [NomeCompMes]     = CONVERT(varchar(8), DATENAME(MONTH, @Data))
    --          , [NomeAbreMes]     = CONVERT(varchar(3), DATENAME(MONTH, @Data))
    --          , [UltiDiaMes]      = CONVERT(tinyint, DAY(EOMONTH(@Data)))
    --          , [NumeQuin]        = CONVERT(tinyint, CASE WHEN DAY(@Data) < 16 THEN 1 ELSE 2 END)
    --          , [NomeQuin]        = CONVERT(varchar(11), CASE WHEN DAY(@Data) < 16 THEN '1º quinzena' ELSE '2º quinzena' END)
    --          , [NumeSemaAno]     = CONVERT(tinyint, DATEPART(ISO_WEEK, @Data))
    --          , [NomeCompSemaAno] = CONVERT(varchar(33), CASE WHEN DATEPART(ISO_WEEK, @Data) = 1 THEN
    --                                                              CONVERT(varchar(4), YEAR(DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data))) + '-' + 
    --                                                              CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00')) + ': ' +
    --                                                              CONVERT(varchar(10), DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data), 103) + ' - ' +
    --                                                              CONVERT(varchar(10), DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data), 103)
    --                                                          ELSE
    --                                                              CONVERT(varchar(4), YEAR(DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data))) + '-' + 
    --                                                              CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00')) + ': ' +
    --                                                              CONVERT(varchar(10), DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data), 103) + ' - ' +
    --                                                              CONVERT(varchar(10), DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data), 103)
    --                                                     END)
    --          , [NomeAbreSemaAno] = CONVERT(varchar(8), CASE WHEN DATEPART(ISO_WEEK, @Data) = 1 THEN
    --                                                             CONVERT(varchar(4), YEAR(DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data))) + '-' + 
    --                                                             CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00'))
    --                                                         ELSE
    --                                                             CONVERT(varchar(4), YEAR(DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data))) + '-' + 
    --                                                             CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00'))
    --                                                    END)
    --          , [NumeDiaSema]     = CONVERT(tinyint, DATEPART(WEEKDAY, @Data))
    --          , [NomeCompDiaSema] = CONVERT(varchar(13), DATENAME(WEEKDAY, @Data))
    --          , [NomeAbreDiaSema] = CONVERT(varchar(3), DATENAME(WEEKDAY, @Data))
    --          , [Data]            = CONVERT(date, @Data)
    --          , [Dia]             = CONVERT(tinyint, DAY(@Data))
    --          , [NumeDiaAno]      = CONVERT(smallint, DATEPART(DAYOFYEAR, @Data))
    SET @Date = DATEADD(DAY, 1, @Date);
END;

SELECT * FROM [DW].[dmCale];