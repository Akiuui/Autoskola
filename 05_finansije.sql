CREATE TABLE [Cenovnik] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Naziv] NVARCHAR(100) NOT NULL,
    [Opis] NVARCHAR(500),
    [Cena] DECIMAL(10,2) NOT NULL,
    [Datum_od] DATE NOT NULL,
    [Datum_do] DATE
);
GO

CREATE TABLE [Uplata] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Cenovnik_id] UNIQUEIDENTIFIER NOT NULL,
    [Obuka_id] UNIQUEIDENTIFIER NOT NULL,
    [Iznos] DECIMAL(10,2) NOT NULL,
    [Datum] DATE NOT NULL DEFAULT (getdate()),
    [Nacin_placanja] NVARCHAR(20) NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2
);
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'null = trenutno aktivan',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Cenovnik',
@level2type = N'Column', @level2name = 'Datum_do';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'moze biti negativan - korekcija',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Uplata',
@level2type = N'Column', @level2name = 'Iznos';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'enum: Gotovina, Kartica, Prenos',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Uplata',
@level2type = N'Column', @level2name = 'Nacin_placanja';
GO

ALTER TABLE [Uplata] ADD FOREIGN KEY ([Cenovnik_id]) REFERENCES [Cenovnik] ([Id]);
GO

ALTER TABLE [Uplata] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id]);
GO
