CREATE TABLE [##tzdata] (
    [year]      smallint     NOT NULL,
    [tz]        varchar(255) NOT NULL,
    [utc]       smallint     NOT NULL,
    [dst]       smallint     NOT NULL,
    [start_dst] date         NOT NULL,
    [end_dst]   date         NOT NULL);
ALTER TABLE [##tzdata] ADD CONSTRAINT uq_tzdata UNIQUE ([year], [tz]);
INSERT INTO [##tzdata] VALUES (2017, 'America/Sao_Paulo', -3, -2, '2017-10-15', '2018-02-18');
INSERT INTO [##tzdata] VALUES (2018, 'America/Sao_Paulo', -3, -2, '2018-11-04', '2019-02-17');
INSERT INTO [##tzdata] VALUES (2017, 'America/Fortaleza', -3, -3, '2017-10-15', '2018-02-18');
INSERT INTO [##tzdata] VALUES (2018, 'America/Fortaleza', -3, -3, '2018-11-04', '2019-02-17');
GO
