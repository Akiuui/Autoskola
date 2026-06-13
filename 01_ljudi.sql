CREATE TABLE [Kandidat] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY
        CONSTRAINT [DF_Kandidat_Id] DEFAULT (newid()),
    [Istek_lekarskog] DATE,
    [Ime] NVARCHAR(50) NOT NULL,
    [Ime_roditelja] NVARCHAR(50),
    [Prezime] NVARCHAR(50) NOT NULL,
    [JMBG] CHAR(13) NOT NULL,
    [Istek_licne_karte] DATE,
    [Telefon] NVARCHAR(15) NOT NULL,
    [Email] NVARCHAR(100),
    [Datum_rodjenja] DATE NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL
        CONSTRAINT [DF_Kandidat_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    CONSTRAINT [UQ_Kandidat_JMBG] UNIQUE ([JMBG]),
    -- JMBG sme da ima samo cifre.
    CONSTRAINT [CK_Kandidat_JMBG_Format] CHECK ([JMBG] NOT LIKE '%[^0-9]%'),
    -- Datum rodjenja mora biti manji od danasnjeg datuma.
    CONSTRAINT [CK_Kandidat_Datum_rodjenja] CHECK ([Datum_rodjenja] < CONVERT(date, getdate()))
);
GO

CREATE TABLE [Zaposleni] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY
        CONSTRAINT [DF_Zaposleni_Id] DEFAULT (newid()),
    [Kvalifikacija] NVARCHAR(100),
    [Aktivni_ugovor] BIT NOT NULL
        CONSTRAINT [DF_Zaposleni_Aktivni_ugovor] DEFAULT (1),
    [Ime] NVARCHAR(50) NOT NULL,
    [Ime_roditelja] NVARCHAR(50),
    [Prezime] NVARCHAR(50) NOT NULL,
    [JMBG] CHAR(13) NOT NULL,
    [Istek_licne_karte] DATE,
    [Telefon] NVARCHAR(15) NOT NULL,
    [Email] NVARCHAR(100),
    [Datum_rodjenja] DATE NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL
        CONSTRAINT [DF_Zaposleni_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    CONSTRAINT [UQ_Zaposleni_JMBG] UNIQUE ([JMBG]),
    -- JMBG sme da ima samo cifre.
    CONSTRAINT [CK_Zaposleni_JMBG_Format] CHECK ([JMBG] NOT LIKE '%[^0-9]%'),
    -- Datum rodjenja mora biti manji od danasnjeg datuma.
    CONSTRAINT [CK_Zaposleni_Datum_rodjenja] CHECK ([Datum_rodjenja] < CONVERT(date, getdate()))
);
GO

CREATE TABLE [Zaposleni_Izostanak] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY
        CONSTRAINT [DF_Zaposleni_Izostanak_Id] DEFAULT (newid()),
    [Zaposleni_id] UNIQUEIDENTIFIER NOT NULL REFERENCES [Zaposleni] ([Id]),
    [Tip] NVARCHAR(20) NOT NULL,
    [Datum_od] DATE NOT NULL,
    [Datum_do] DATE,
    -- Tip izostanka moze biti samo bolovanje ili godisnji odmor.
    CONSTRAINT [CK_Zaposleni_Izostanak_Tip] CHECK ([Tip] IN (N'BOL', N'GODISNJI')),
    -- Datum zavrsetka izostanka, ako postoji, ne sme biti pre datuma pocetka.
    CONSTRAINT [CK_Zaposleni_Izostanak_Datum] CHECK ([Datum_do] IS NULL OR [Datum_do] >= [Datum_od])
);
GO

CREATE TABLE [Funkcije_Zaposlenih] (
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY
        CONSTRAINT [DF_Funkcije_Zaposlenih_Id] DEFAULT (newid()),
    [Ime_funkcije] NVARCHAR(50) NOT NULL,
    [Minimalna_kvalifikacija] NVARCHAR(50),
    [Opis] NVARCHAR(100)
);
GO

CREATE TABLE [Zaposleni_Funkcija] (
    [Id_zaposlenog] UNIQUEIDENTIFIER NOT NULL REFERENCES [Zaposleni] ([Id]),
    [Id_funkcije] UNIQUEIDENTIFIER NOT NULL REFERENCES [Funkcije_Zaposlenih] ([Id]),
    CONSTRAINT [PK_Zaposleni_Funkcija] PRIMARY KEY ([Id_zaposlenog], [Id_funkcije])
);
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'CHECK: BOL, GODISNJI',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Zaposleni_Izostanak',
@level2type = N'Column', @level2name = 'Tip';
GO
