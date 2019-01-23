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
    [Ano]             smallint        NULL,          -- Ano
    [NumeSeme]        tinyint         NULL,          -- Número do Semestre
    [NomeCompSeme]    varchar(11)     NULL,          -- Nome Completo do Semestre
    [NomeAbreSeme]    varchar(2)      NULL,          -- Nome Abreviado do Semestre
    [NumeTrim]        tinyint         NULL,          -- Número do Trimestre
    [NomeCompTrim]    varchar(12)     NULL,          -- Nome Completo do Trimestre
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
    [Data]            date            NULL,          -- Data
    [UnixEpoc]        integer         NULL,          -- Posix Time ou Unix Epoch ou Unix Timestamp
    [Dia]             tinyint         NULL,          -- Dia
    [NumeDiaAno]      smallint        NULL,          -- Número do Dia do Ano
);
-- Primary Key Constraint of the Calendar Dimension Table
ALTER TABLE [DW].[dmCale] ADD CONSTRAINT [pkDimeCale] PRIMARY KEY ([SurrKeyDate]);
GO

DECLARE @DataInicio date = CONVERT(varchar(4), YEAR(GETDATE())) + '-01-01';
DECLARE @DataFim date = DATEADD(DAY, -1, DATEADD(YEAR, 1, @DataInicio));
DECLARE @Data date = @DataInicio;

SET LANGUAGE portuguese;
SET DATEFIRST 1

WHILE @Data <= @DataFim
BEGIN
    INSERT INTO [DW].[dmCale]
        SELECT [SurrKeyDate]     = CONVERT(integer, CONVERT(varchar(8), @Data, 112))
             , [Ano]             = CONVERT(smallint, YEAR(@Data))
             , [NumeSeme]        = CONVERT(tinyint, CASE WHEN MONTH(@Data) < 7 THEN 1 ELSE 2 END)
             , [NomeCompSeme]    = CONVERT(varchar(11), CASE WHEN MONTH(@Data) < 7 THEN '1º semestre' ELSE '2º semestre' END)
             , [NomeAbreSeme]    = CONVERT(varchar(2), CASE WHEN MONTH(@Data) < 7 THEN 'S1' ELSE 'S2' END)
             , [NumeTrim]        = CONVERT(tinyint, DATEPART(QUARTER, @Data))
             , [NomeCompTrim]    = CONVERT(varchar(12), CASE DATEPART(QUARTER, @Data)
                                                            WHEN 1 THEN '1º trimestre'
                                                            WHEN 2 THEN '2º trimestre'
                                                            WHEN 3 THEN '3º trimestre'
                                                            ELSE '4º trimestre'
                                                        END)
             , [NomeAbreTrim]    = CONVERT(varchar(2), 'T' + CONVERT(varchar(1), DATEPART(QUARTER, @Data)))
             , [NumeMes]         = CONVERT(tinyint, MONTH(@Data))
             , [NomeCompMes]     = CONVERT(varchar(8), DATENAME(MONTH, @Data))
             , [NomeAbreMes]     = CONVERT(varchar(3), DATENAME(MONTH, @Data))
             , [UltiDiaMes]      = CONVERT(tinyint, DAY(EOMONTH(@Data)))
             , [NumeQuin]        = CONVERT(tinyint, CASE WHEN DAY(@Data) < 16 THEN 1 ELSE 2 END)
             , [NomeQuin]        = CONVERT(varchar(11), CASE WHEN DAY(@Data) < 16 THEN '1º quinzena' ELSE '2º quinzena' END)
             , [NumeSemaAno]     = CONVERT(tinyint, DATEPART(ISO_WEEK, @Data))
             , [NomeCompSemaAno] = CONVERT(varchar(33), CASE WHEN DATEPART(ISO_WEEK, @Data) = 1 THEN
                                                                 CONVERT(varchar(4), YEAR(DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data))) + '-' + 
                                                                 CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00')) + ': ' +
                                                                 CONVERT(varchar(10), DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data), 103) + ' - ' +
                                                                 CONVERT(varchar(10), DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data), 103)
                                                             ELSE
                                                                 CONVERT(varchar(4), YEAR(DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data))) + '-' + 
                                                                 CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00')) + ': ' +
                                                                 CONVERT(varchar(10), DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data), 103) + ' - ' +
                                                                 CONVERT(varchar(10), DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data), 103)
                                                        END)
             , [NomeAbreSemaAno] = CONVERT(varchar(8), CASE WHEN DATEPART(ISO_WEEK, @Data) = 1 THEN
                                                                CONVERT(varchar(4), YEAR(DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Data), @Data))) + '-' + 
                                                                CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00'))
                                                            ELSE
                                                                CONVERT(varchar(4), YEAR(DATEADD(DAY, -DATEPART(WEEKDAY, @Data) + 1, @Data))) + '-' + 
                                                                CONVERT(varchar(3), 'S' + FORMAT(DATEPART(ISO_WEEK, @Data), '00'))
                                                       END)
             , [NumeDiaSema]     = CONVERT(tinyint, DATEPART(WEEKDAY, @Data))
             , [NomeCompDiaSema] = CONVERT(varchar(13), DATENAME(WEEKDAY, @Data))
             , [NomeAbreDiaSema] = CONVERT(varchar(3), DATENAME(WEEKDAY, @Data))
             , [Data]            = CONVERT(date, @Data)
             , [UnixEpoc]        = CONVERT(integer, DATEDIFF(SECOND, {d '1970-01-01'}, @Data))
             , [Dia]             = CONVERT(tinyint, DAY(@Data))
             , [NumeDiaAno]      = CONVERT(smallint, DATEPART(DAYOFYEAR, @Data))
    SET @Data = DATEADD(DAY, 1, @Data);
END;

SELECT * FROM [DW].[dmCale];