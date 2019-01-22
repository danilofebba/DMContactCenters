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
    [SurrKeyDate]     integer     NOT NULL,          -- Surrogate Key
    [Ano]             smallint    NOT NULL,          -- Ano
    [NumeSeme]        tinyint     NOT NULL,          -- Número do Semestre
    [NomeCompSeme]    varchar(11) NOT NULL,          -- Nome Completo do Semestre
    [NomeAbreSeme]    varchar(2)  NOT NULL,          -- Nome Abreviado do Semestre

    [NumeTrim]        tinyint     NOT NULL,          -- Campo Número do Trimestre
    [NomeTrim]        varchar(12) NOT NULL,          -- Campo Nome do Trimestre
    [NomeTrimAbre]    varchar(2)  NOT NULL,          -- Campo Nome do Trimestre Abreviado
    [NumeMes]         tinyint     NOT NULL,          -- Campo Número do Mês
    [NomeMes]         varchar(8)  NOT NULL,          -- Campo Nome do Mês
    [NomeMesAbre]     varchar(3)  NOT NULL,          -- Campo Nome do Mês Abreviado
    [UltiDiaMes]      tinyint     NOT NULL,          -- Campo Último Dia do Mês
    [NumeQuin]        tinyint     NOT NULL,          -- Campo Número da Quianzena
    [NomeQuin]        varchar(11) NOT NULL,          -- Campo Nome da Quianzena
    [NumeSemaAno]     tinyint     NOT NULL,          -- Campo Número da Semana do Ano ISO 8601
    [NomeSemaAno]     varchar(33) NOT NULL,          -- Campo Nome da Semana do Ano ISO 8601
    [NomeSemaAnoAbre] varchar(8)  NOT NULL,          -- Campo Nome da Semana do Ano Abreviado ISO 8601
    [NumeDiaSema]     tinyint     NOT NULL,          -- Campo Número do Dia da Semana
    [NomeDiaSema]     varchar(13) NOT NULL,          -- Campo Nome do Dia da Semana
    [NomeDiaSemaAbre] varchar(3)  NOT NULL,          -- Campo Nome do Dia da Semana Abreviado
    [Data]            date        NOT NULL,          -- Data
    [UnixEpoc]        integer     NOT NULL,          -- Campo Posix Time ou Unix Epoch ou Unix Timestamp
    [Dia]             tinyint     NOT NULL,          -- Campo Dia
    [NumeDiaAno]      smallint    NOT NULL,          -- Campo Número do Dia do Ano
);
-- Primary Key Constraint of the Calendar Dimension Table
ALTER TABLE [DW].[dmCale] ADD CONSTRAINT [pkDimeCale] PRIMARY KEY ([SurrKeyDate]);
GO

DECLARE @DataInicio date = '2016-12-26' --CONVERT(varchar(4), YEAR(GETDATE())) + '-01-01';
DECLARE @DataFim date = '2026-01-04' --DATEADD(DAY, -1, DATEADD(YEAR, 10, @DataInicio));
DECLARE @Data date = @DataInicio;

SET LANGUAGE portuguese;
SET DATEFIRST 1

WHILE @Data <= @DataFim
BEGIN
    INSERT INTO [DW].[dmCale]
        SELECT [SurrKeyDate]  = CONVERT(integer, CONVERT(varchar(8), @Data, 112))
             , [Ano]          = CONVERT(smallint, YEAR(@Data))
             , [NumeSeme]     = CONVERT(tinyint, CASE WHEN MONTH(@Data) < 7 THEN 1 ELSE 2 END)
             , [NomeCompSeme] = CONVERT(varchar(11), CASE WHEN MONTH(@Data) < 7 THEN '1º semestre' ELSE '2º semestre' END)
             , [NomeAbreSeme] = CONVERT(varchar(2), CASE WHEN MONTH(@Data) < 7 THEN 'S1' ELSE 'S2' END)
             , CONVERT(tinyint, DATEPART(QUARTER, @Data))                                                                        AS [NumeTrim]        -- Número do Trimestre
             , CONVERT(varchar(12), CASE DATEPART(QUARTER, @Data)
                                        WHEN 1 THEN '1º trimestre'
                                        WHEN 2 THEN '2º trimestre'
                                        WHEN 3 THEN '3º trimestre'
                                        ELSE '4º trimestre'
                                    END)                                                                                         AS [NomeTrim]        -- Nome do Trimestre
             , CONVERT(varchar(2), 'T' + CONVERT(varchar(1), DATEPART(QUARTER, @Data)))                                          AS [NomeTrimAbre]    -- Nome do Trimestre Abreviado
             , CONVERT(tinyint, MONTH(@Data))                                                                                    AS [NumeMes]         -- Número do Mês
             , CONVERT(varchar(8), DATENAME(MONTH, @Data))                                                                       AS [NomeMes]         -- Nome do Mês
             , CONVERT(varchar(3), DATENAME(MONTH, @Data))                                                                       AS [NomeMesAbre]     -- Nome do Mês Abreviado
             , CONVERT(tinyint, DAY(EOMONTH(@Data)))                                                                             AS [UltiDiaMes]      -- Último Dia do Mês
             , CONVERT(tinyint, CASE WHEN DAY(@Data) < 16 THEN 1 ELSE 2 END)                                                     AS [NumeQuin]        -- Número da Quianzena
             , CONVERT(varchar(11), CASE WHEN DAY(@Data) < 16 THEN '1º quinzena' ELSE '2º quinzena' END)                         AS [NomeQuin]        -- Nome da Quianzena
             , CONVERT(tinyint, DATEPART(ISO_WEEK, @Data))                                                                       AS [NumeSemaAno]     -- Número da Semana do Ano ISO 8601
             , CONVERT(varchar(33), CASE WHEN DATEPART(ISO_WEEK, @Data) = 1 THEN
                                        CONVERT(varchar(4), YEAR(DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data))) + '-' + 
                                        CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00')) + ': ' +
                                        CONVERT(varchar(10), DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data), 103) + ' - ' +
                                        CONVERT(varchar(10), DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data), 103)
                                    ELSE
                                        CONVERT(varchar(4), YEAR(DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data))) + '-' + 
                                        CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00')) + ': ' +
                                        CONVERT(varchar(10), DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data), 103) + ' - ' +
                                        CONVERT(varchar(10), DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data), 103)
                                    END)                                                                                         AS [NomeSemaAno]     -- Nome da Semana do Ano ISO 8601
             , CONVERT(varchar(8), CASE WHEN DATEPART(ISO_WEEK, @Data) = 1 THEN
                                       CONVERT(varchar(4), YEAR(DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data))) + '-' + 
                                       CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00'))
                                   ELSE
                                       CONVERT(varchar(4), YEAR(DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data))) + '-' + 
                                       CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00'))
                                   END)                                                                                          AS [NomeSemaAnoAbre] -- Nome da Semana do Ano Abreviado ISO 8601
             , CONVERT(tinyint, DATEPART(WEEKDAY, @Data))                                                                        AS [NumeDiaSema]     -- Número do Dia da Semana
             , CONVERT(varchar(13), DATENAME(WEEKDAY, @Data))                                                                    AS [NomeDiaSema]     -- Nome do Dia da Semana
             , CONVERT(varchar(3), DATENAME(WEEKDAY, @Data))                                                                     AS [NomeDiaSemaAbre] -- Nome do Dia da Semana Abreviado
             , [Data] = CONVERT(date, @Data)
             , CONVERT(integer, DATEDIFF(SECOND, {d '1970-01-01'}, @Data))                                                       AS [UnixEpoc]        -- Posix Time ou Unix Epoch ou Unix Timestamp
             , CONVERT(tinyint, DAY(@Data))                                                                                      AS [Dia]             -- Dia
             , CONVERT(smallint, DATEPART(DAYOFYEAR, @Data))                                                                     AS [NumeDiaAno]      -- Número do Dia do Ano
    SET @Data = DATEADD(DAY, 1, @Data);
END;

SELECT * FROM [DW].[dmCale];