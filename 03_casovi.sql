CREATE TABLE [Cas] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Instruktor_id] UNIQUEIDENTIFIER NOT NULL,
    [Tip_id] UNIQUEIDENTIFIER NOT NULL,
    [Lokacija] NVARCHAR(200),
    [Datum] DATE NOT NULL,
    [Pocetak] DATETIME2 NOT NULL,
    [Kraj] DATETIME2 NOT NULL,
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Zakazan',
    [Obuka_id] UNIQUEIDENTIFIER,
    [Vozilo_id] UNIQUEIDENTIFIER,
    [Grupa_id] UNIQUEIDENTIFIER,
    [Kreiran_datum] DATETIME2 NOT NULL DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2
);
GO

CREATE TABLE [Vozilo] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Registracija] NVARCHAR(20) UNIQUE NOT NULL,
    [Marka] NVARCHAR(50) NOT NULL,
    [Model] NVARCHAR(50) NOT NULL,
    [Godiste] INT NOT NULL,
    [Kategorija_id] UNIQUEIDENTIFIER NOT NULL,
    [Kilometraza] INT NOT NULL DEFAULT (0),
    [Datum_registracije] DATE NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2
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

ALTER TABLE [Cas] ADD FOREIGN KEY ([Instruktor_id]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Tip_id]) REFERENCES [Tip_obuke] ([Id]);
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id]);
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Vozilo_id]) REFERENCES [Vozilo] ([Id]);
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Grupa_id]) REFERENCES [Grupa] ([Id]);
GO

ALTER TABLE [Vozilo] ADD FOREIGN KEY ([Kategorija_id]) REFERENCES [Kategorija_vozacke] ([Id]);
GO
