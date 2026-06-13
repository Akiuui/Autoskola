CREATE TABLE [Vozilo] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY
        CONSTRAINT [DF_Vozilo_Id] DEFAULT (newid()),
    [Registracija] NVARCHAR(20) NOT NULL,
    [Marka] NVARCHAR(50) NOT NULL,
    [Model] NVARCHAR(50) NOT NULL,
    [Godiste] INT NOT NULL,
    [Kategorija_id] UNIQUEIDENTIFIER NOT NULL REFERENCES [Kategorija_vozacke] ([Id]),
    [Kilometraza] INT NOT NULL
        CONSTRAINT [DF_Vozilo_Kilometraza] DEFAULT (0),
    [Datum_registracije] DATE NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL
        CONSTRAINT [DF_Vozilo_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    -- Registracija vozila ne sme da se ponavlja.
    CONSTRAINT [UQ_Vozilo_Registracija] UNIQUE ([Registracija]),
    -- Godiste vozila mora biti u realnom opsegu.
    CONSTRAINT [CK_Vozilo_Godiste] CHECK ([Godiste] BETWEEN 1980 AND YEAR(getdate()) + 1),
    -- Kilometraza ne moze biti negativna.
    CONSTRAINT [CK_Vozilo_Kilometraza] CHECK ([Kilometraza] >= 0)
);
GO

CREATE TABLE [Cas] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY
        CONSTRAINT [DF_Cas_Id] DEFAULT (newid()),
    [Instruktor_id] UNIQUEIDENTIFIER NOT NULL REFERENCES [Zaposleni] ([Id]),
    [Tip_id] UNIQUEIDENTIFIER NOT NULL REFERENCES [Tip_obuke] ([Id]),
    [Lokacija] NVARCHAR(200),
    [Datum] DATE NOT NULL,
    [Pocetak] DATETIME2 NOT NULL,
    [Kraj] DATETIME2 NOT NULL,
    [Status] NVARCHAR(20) NOT NULL
        CONSTRAINT [DF_Cas_Status] DEFAULT (N'Zakazan'),
    [Obuka_id] UNIQUEIDENTIFIER REFERENCES [Obuka] ([Id]),
    [Vozilo_id] UNIQUEIDENTIFIER REFERENCES [Vozilo] ([Id]),
    [Grupa_id] UNIQUEIDENTIFIER REFERENCES [Grupa] ([Id]),
    [Kreiran_datum] DATETIME2 NOT NULL
        CONSTRAINT [DF_Cas_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    -- Status casa moze biti samo jedna od dozvoljenih vrednosti.
    CONSTRAINT [CK_Cas_Status] CHECK ([Status] IN (N'Zakazan', N'Odrzan', N'Otkazan')),
    -- Vreme zavrsetka casa mora biti posle vremena pocetka.
    CONSTRAINT [CK_Cas_Vreme] CHECK ([Kraj] > [Pocetak]),
    -- Datum casa mora odgovarati datumima pocetka i kraja casa.
    CONSTRAINT [CK_Cas_Datum_Pocetak] CHECK (CONVERT(date, [Pocetak]) = [Datum] AND CONVERT(date, [Kraj]) = [Datum]),
    -- Prakticni cas ima obuku i vozilo, a teorijski cas ima samo grupu.
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
