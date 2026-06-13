CREATE TABLE [Vozilo] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Vozilo_Id] DEFAULT (newid()),
    [Registracija] NVARCHAR(20) NOT NULL,
    [Marka] NVARCHAR(50) NOT NULL,
    [Model] NVARCHAR(50) NOT NULL,
    [Godiste] INT NOT NULL,
    [Kategorija_id] UNIQUEIDENTIFIER NOT NULL,
    [Kilometraza] INT NOT NULL CONSTRAINT [DF_Vozilo_Kilometraza] DEFAULT (0),
    [Datum_registracije] DATE NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL CONSTRAINT [DF_Vozilo_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    CONSTRAINT [PK_Vozilo] PRIMARY KEY ([Id]),
    CONSTRAINT [UQ_Vozilo_Registracija] UNIQUE ([Registracija]),
    CONSTRAINT [CK_Vozilo_Godiste] CHECK ([Godiste] BETWEEN 1980 AND YEAR(getdate()) + 1),
    CONSTRAINT [CK_Vozilo_Kilometraza] CHECK ([Kilometraza] >= 0)
);
GO

CREATE TABLE [Cas] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Cas_Id] DEFAULT (newid()),
    [Instruktor_id] UNIQUEIDENTIFIER NOT NULL,
    [Tip_id] UNIQUEIDENTIFIER NOT NULL,
    [Lokacija] NVARCHAR(200),
    [Datum] DATE NOT NULL,
    [Pocetak] DATETIME2 NOT NULL,
    [Kraj] DATETIME2 NOT NULL,
    [Status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Cas_Status] DEFAULT (N'Zakazan'),
    [Obuka_id] UNIQUEIDENTIFIER,
    [Vozilo_id] UNIQUEIDENTIFIER,
    [Grupa_id] UNIQUEIDENTIFIER,
    [Kreiran_datum] DATETIME2 NOT NULL CONSTRAINT [DF_Cas_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    CONSTRAINT [PK_Cas] PRIMARY KEY ([Id]),
    CONSTRAINT [CK_Cas_Status] CHECK ([Status] IN (N'Zakazan', N'Odrzan', N'Otkazan')),
    CONSTRAINT [CK_Cas_Vreme] CHECK ([Kraj] > [Pocetak]),
    CONSTRAINT [CK_Cas_Datum_Pocetak] CHECK (CONVERT(date, [Pocetak]) = [Datum] AND CONVERT(date, [Kraj]) = [Datum]),
    CONSTRAINT [CK_Cas_Tip_Polja] CHECK (
        (
            [Obuka_id] IS NOT NULL
            AND [Vozilo_id] IS NOT NULL
            AND [Grupa_id] IS NULL
        )
        OR
        (
            [Grupa_id] IS NOT NULL
            AND [Obuka_id] IS NULL
            AND [Vozilo_id] IS NULL
        )
    )
);
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'enum: Zakazan, Odrzan, Otkazan',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Cas',
@level2type = N'Column', @level2name = 'Status';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'not null za Prakticni',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Cas',
@level2type = N'Column', @level2name = 'Obuka_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'not null za Prakticni',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Cas',
@level2type = N'Column', @level2name = 'Vozilo_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'not null za Teorijski',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Cas',
@level2type = N'Column', @level2name = 'Grupa_id';
GO

ALTER TABLE [Vozilo]
ADD CONSTRAINT [FK_Vozilo_Kategorija_vozacke]
FOREIGN KEY ([Kategorija_id]) REFERENCES [Kategorija_vozacke] ([Id]);
GO

ALTER TABLE [Cas]
ADD CONSTRAINT [FK_Cas_Zaposleni]
FOREIGN KEY ([Instruktor_id]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Cas]
ADD CONSTRAINT [FK_Cas_Tip_obuke]
FOREIGN KEY ([Tip_id]) REFERENCES [Tip_obuke] ([Id]);
GO

ALTER TABLE [Cas]
ADD CONSTRAINT [FK_Cas_Obuka]
FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id]);
GO

ALTER TABLE [Cas]
ADD CONSTRAINT [FK_Cas_Vozilo]
FOREIGN KEY ([Vozilo_id]) REFERENCES [Vozilo] ([Id]);
GO

ALTER TABLE [Cas]
ADD CONSTRAINT [FK_Cas_Grupa]
FOREIGN KEY ([Grupa_id]) REFERENCES [Grupa] ([Id]);
GO
