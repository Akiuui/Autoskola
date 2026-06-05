CREATE TABLE [Obuka] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Kategorija_id] UNIQUEIDENTIFIER NOT NULL,
    [Glavni_Instruktor_id] UNIQUEIDENTIFIER,
    [Kandidat_id] UNIQUEIDENTIFIER NOT NULL,
    [Tip_Obuke] UNIQUEIDENTIFIER NOT NULL,
    [Datum_pocetka] DATE NOT NULL,
    [Datum_zavrsetka] DATE,
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'Aktivan',
    [Kreiran_datum] DATETIME2 NOT NULL DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2
);
GO

CREATE TABLE [Tip_obuke] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Tip] NVARCHAR(30),
    [Opis] NVARCHAR(100)
);
GO

CREATE TABLE [Kategorija_vozacke] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Oznaka] CHAR(2) NOT NULL,
    [Opis] NVARCHAR(50)
);
GO

CREATE TABLE [Grupa] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Datum_kreiranja] DATE NOT NULL DEFAULT (getdate()),
    [Datum_zavrsetka] DATE
);
GO

CREATE TABLE [Kandidat_grupa] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Grupa_id] UNIQUEIDENTIFIER NOT NULL,
    [Obuka_id] UNIQUEIDENTIFIER NOT NULL,
    [Datum_od] DATE NOT NULL,
    [Datum_do] DATE
);
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'enum: Aktivan, Zavrsen, Prekinut',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Obuka',
@level2type = N'Column', @level2name = 'Status';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'CHECK: Teorijska, Prakticna, Prva Pomoc',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Tip_obuke',
@level2type = N'Column', @level2name = 'Tip';
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Kandidat_id]) REFERENCES [Kandidat] ([Id]);
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Kategorija_id]) REFERENCES [Kategorija_vozacke] ([Id]);
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Glavni_Instruktor_id]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Tip_Obuke]) REFERENCES [Tip_obuke] ([Id]);
GO

ALTER TABLE [Kandidat_grupa] ADD FOREIGN KEY ([Grupa_id]) REFERENCES [Grupa] ([Id]);
GO

ALTER TABLE [Kandidat_grupa] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id]);
GO
