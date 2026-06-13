CREATE TABLE [Tip_obuke] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Tip_obuke_Id] DEFAULT (newid()),
    [Tip] NVARCHAR(30) NOT NULL,
    [Opis] NVARCHAR(100),
    CONSTRAINT [PK_Tip_obuke] PRIMARY KEY ([Id]),
    CONSTRAINT [UQ_Tip_obuke_Tip] UNIQUE ([Tip]),
    CONSTRAINT [CK_Tip_obuke_Tip] CHECK ([Tip] IN (N'Teorijska', N'Prakticna', N'Prva Pomoc'))
);
GO

CREATE TABLE [Kategorija_vozacke] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Kategorija_vozacke_Id] DEFAULT (newid()),
    [Oznaka] CHAR(2) NOT NULL,
    [Opis] NVARCHAR(50),
    CONSTRAINT [PK_Kategorija_vozacke] PRIMARY KEY ([Id]),
    CONSTRAINT [UQ_Kategorija_vozacke_Oznaka] UNIQUE ([Oznaka])
);
GO

CREATE TABLE [Grupa] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Grupa_Id] DEFAULT (newid()),
    [Datum_kreiranja] DATE NOT NULL CONSTRAINT [DF_Grupa_Datum_kreiranja] DEFAULT (getdate()),
    [Datum_zavrsetka] DATE,
    CONSTRAINT [PK_Grupa] PRIMARY KEY ([Id]),
    CONSTRAINT [CK_Grupa_Datum] CHECK ([Datum_zavrsetka] IS NULL OR [Datum_zavrsetka] >= [Datum_kreiranja])
);
GO

CREATE TABLE [Obuka] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Obuka_Id] DEFAULT (newid()),
    [Kategorija_id] UNIQUEIDENTIFIER NOT NULL,
    [Glavni_Instruktor_id] UNIQUEIDENTIFIER,
    [Kandidat_id] UNIQUEIDENTIFIER NOT NULL,
    [Tip_Obuke] UNIQUEIDENTIFIER NOT NULL,
    [Datum_pocetka] DATE NOT NULL,
    [Datum_zavrsetka] DATE,
    [Status] NVARCHAR(20) NOT NULL CONSTRAINT [DF_Obuka_Status] DEFAULT (N'Aktivan'),
    [Kreiran_datum] DATETIME2 NOT NULL CONSTRAINT [DF_Obuka_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    CONSTRAINT [PK_Obuka] PRIMARY KEY ([Id]),
    CONSTRAINT [CK_Obuka_Status] CHECK ([Status] IN (N'Aktivan', N'Zavrsen', N'Prekinut')),
    CONSTRAINT [CK_Obuka_Datum] CHECK ([Datum_zavrsetka] IS NULL OR [Datum_zavrsetka] >= [Datum_pocetka])
);
GO

CREATE TABLE [Kandidat_grupa] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Kandidat_grupa_Id] DEFAULT (newid()),
    [Grupa_id] UNIQUEIDENTIFIER NOT NULL,
    [Obuka_id] UNIQUEIDENTIFIER NOT NULL,
    [Datum_od] DATE NOT NULL,
    [Datum_do] DATE,
    CONSTRAINT [PK_Kandidat_grupa] PRIMARY KEY ([Id]),
    CONSTRAINT [UQ_Kandidat_grupa_Obuka_Grupa] UNIQUE ([Obuka_id], [Grupa_id]),
    CONSTRAINT [CK_Kandidat_grupa_Datum] CHECK ([Datum_do] IS NULL OR [Datum_do] >= [Datum_od])
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

ALTER TABLE [Obuka]
ADD CONSTRAINT [FK_Obuka_Kandidat]
FOREIGN KEY ([Kandidat_id]) REFERENCES [Kandidat] ([Id]);
GO

ALTER TABLE [Obuka]
ADD CONSTRAINT [FK_Obuka_Kategorija_vozacke]
FOREIGN KEY ([Kategorija_id]) REFERENCES [Kategorija_vozacke] ([Id]);
GO

ALTER TABLE [Obuka]
ADD CONSTRAINT [FK_Obuka_Glavni_Instruktor]
FOREIGN KEY ([Glavni_Instruktor_id]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Obuka]
ADD CONSTRAINT [FK_Obuka_Tip_obuke]
FOREIGN KEY ([Tip_Obuke]) REFERENCES [Tip_obuke] ([Id]);
GO

ALTER TABLE [Kandidat_grupa]
ADD CONSTRAINT [FK_Kandidat_grupa_Grupa]
FOREIGN KEY ([Grupa_id]) REFERENCES [Grupa] ([Id]);
GO

ALTER TABLE [Kandidat_grupa]
ADD CONSTRAINT [FK_Kandidat_grupa_Obuka]
FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id]);
GO
