CREATE TABLE [Cenovnik] (
    -- Identifikator stavke cenovnika se automatski generise.
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Cenovnik_Id] DEFAULT (newid()),
    [Naziv] NVARCHAR(100) NOT NULL,
    [Opis] NVARCHAR(500),
    [Cena] DECIMAL(10,2) NOT NULL,
    [Datum_od] DATE NOT NULL,
    [Datum_do] DATE,
    -- Svaka stavka cenovnika mora imati jedinstven identifikator.
    CONSTRAINT [PK_Cenovnik] PRIMARY KEY ([Id]),
    -- Cena mora biti pozitivna.
    CONSTRAINT [CK_Cenovnik_Cena] CHECK ([Cena] > 0),
    -- Datum prestanka vazenja, ako postoji, ne sme biti pre datuma pocetka vazenja.
    CONSTRAINT [CK_Cenovnik_Datum] CHECK ([Datum_do] IS NULL OR [Datum_do] >= [Datum_od])
);
GO

CREATE TABLE [Uplata] (
    -- Identifikator uplate se automatski generise.
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Uplata_Id] DEFAULT (newid()),
    [Cenovnik_id] UNIQUEIDENTIFIER NOT NULL,
    [Obuka_id] UNIQUEIDENTIFIER NOT NULL,
    [Iznos] DECIMAL(10,2) NOT NULL,
    -- Datum uplate se podrazumevano postavlja na danasnji datum.
    [Datum] DATE NOT NULL CONSTRAINT [DF_Uplata_Datum] DEFAULT (getdate()),
    [Nacin_placanja] NVARCHAR(20) NOT NULL,
    -- Datum kreiranja uplate se automatski postavlja pri unosu.
    [Kreiran_datum] DATETIME2 NOT NULL CONSTRAINT [DF_Uplata_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    -- Svaka uplata mora imati jedinstven identifikator.
    CONSTRAINT [PK_Uplata] PRIMARY KEY ([Id]),
    -- Iznos ne sme biti nula; negativan iznos je dozvoljen kao korekcija.
    CONSTRAINT [CK_Uplata_Iznos] CHECK ([Iznos] <> 0),
    -- Nacin placanja moze biti samo jedna od dozvoljenih vrednosti.
    CONSTRAINT [CK_Uplata_Nacin_placanja] CHECK ([Nacin_placanja] IN (N'Gotovina', N'Kartica', N'Prenos'))
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

ALTER TABLE [Uplata]
ADD CONSTRAINT [FK_Uplata_Cenovnik]
-- Uplata mora biti vezana za postojecu stavku cenovnika.
FOREIGN KEY ([Cenovnik_id]) REFERENCES [Cenovnik] ([Id]);
GO

ALTER TABLE [Uplata]
ADD CONSTRAINT [FK_Uplata_Obuka]
-- Uplata mora biti vezana za postojecu obuku.
FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id]);
GO
