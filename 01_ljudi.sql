CREATE TABLE [Kandidat] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Istek_lekarskog] DATE,
    [Ime] NVARCHAR(50) NOT NULL,
    [Ime_roditelja] NVARCHAR(50),
    [Prezime] NVARCHAR(50) NOT NULL,
    [JMBG] CHAR(13) NOT NULL,
    [Istek_licne_karte] DATE,
    [Telefon] NVARCHAR(15) NOT NULL,
    [Email] NVARCHAR(100),
    [Datum_rodjenja] DATE NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL CONSTRAINT [DF_Kandidat_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    CONSTRAINT [PK_Kandidat] PRIMARY KEY ([Id]),
    CONSTRAINT [UQ_Kandidat_JMBG] UNIQUE ([JMBG]),
    CONSTRAINT [CK_Kandidat_JMBG_Format] CHECK ([JMBG] NOT LIKE '%[^0-9]%'),
    CONSTRAINT [CK_Kandidat_Datum_rodjenja] CHECK ([Datum_rodjenja] < CONVERT(date, getdate())),
    CONSTRAINT [CK_Kandidat_Istek_lekarskog] CHECK ([Istek_lekarskog] IS NULL OR [Istek_lekarskog] >= [Datum_rodjenja]),
    CONSTRAINT [CK_Kandidat_Istek_licne_karte] CHECK ([Istek_licne_karte] IS NULL OR [Istek_licne_karte] >= [Datum_rodjenja])
);
GO

CREATE TABLE [Zaposleni] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Kvalifikacija] NVARCHAR(100),
    [Aktivni_ugovor] BIT NOT NULL CONSTRAINT [DF_Zaposleni_Aktivni_ugovor] DEFAULT (1),
    [Ime] NVARCHAR(50) NOT NULL,
    [Ime_roditelja] NVARCHAR(50),
    [Prezime] NVARCHAR(50) NOT NULL,
    [JMBG] CHAR(13) NOT NULL,
    [Istek_licne_karte] DATE,
    [Telefon] NVARCHAR(15) NOT NULL,
    [Email] NVARCHAR(100),
    [Datum_rodjenja] DATE NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL CONSTRAINT [DF_Zaposleni_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    CONSTRAINT [PK_Zaposleni] PRIMARY KEY ([Id]),
    CONSTRAINT [UQ_Zaposleni_JMBG] UNIQUE ([JMBG]),
    CONSTRAINT [CK_Zaposleni_JMBG_Format] CHECK ([JMBG] NOT LIKE '%[^0-9]%'),
    CONSTRAINT [CK_Zaposleni_Datum_rodjenja] CHECK ([Datum_rodjenja] < CONVERT(date, getdate())),
    CONSTRAINT [CK_Zaposleni_Istek_licne_karte] CHECK ([Istek_licne_karte] IS NULL OR [Istek_licne_karte] >= [Datum_rodjenja])
);
GO

CREATE TABLE [Zaposleni_Izostanak] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Zaposleni_Izostanak_Id] DEFAULT (newid()),
    [Zaposleni_id] UNIQUEIDENTIFIER NOT NULL,
    [Tip] NVARCHAR(20) NOT NULL,
    [Datum_od] DATE NOT NULL,
    [Datum_do] DATE,
    CONSTRAINT [PK_Zaposleni_Izostanak] PRIMARY KEY ([Id]),
    CONSTRAINT [CK_Zaposleni_Izostanak_Tip] CHECK ([Tip] IN (N'BOL', N'GODISNJI')),
    CONSTRAINT [CK_Zaposleni_Izostanak_Datum] CHECK ([Datum_do] IS NULL OR [Datum_do] >= [Datum_od])
);
GO

CREATE TABLE [Zaposleni_Funkcija] (
    [Id_zaposlenog] UNIQUEIDENTIFIER NOT NULL,
    [Id_funkcije] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_Zaposleni_Funkcija] PRIMARY KEY ([Id_zaposlenog], [Id_funkcije])
);
GO

CREATE TABLE [Funkcije_Zaposlenih] (
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Funkcije_Zaposlenih_Id] DEFAULT (newid()),
    [Ime_funkcije] NVARCHAR(50) NOT NULL,
    [Minimalna_kvalifikacija] NVARCHAR(50),
    [Opis] NVARCHAR(100),
    CONSTRAINT [PK_Funkcije_Zaposlenih] PRIMARY KEY ([Id]),
    CONSTRAINT [UQ_Funkcije_Zaposlenih_Ime_funkcije] UNIQUE ([Ime_funkcije])
);
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'CHECK: BOL, GODISNJI',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Zaposleni_Izostanak',
@level2type = N'Column', @level2name = 'Tip';
GO

ALTER TABLE [Zaposleni_Izostanak]
ADD CONSTRAINT [FK_Zaposleni_Izostanak_Zaposleni]
FOREIGN KEY ([Zaposleni_id]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Zaposleni_Funkcija]
ADD CONSTRAINT [FK_Zaposleni_Funkcija_Zaposleni]
FOREIGN KEY ([Id_zaposlenog]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Zaposleni_Funkcija]
ADD CONSTRAINT [FK_Zaposleni_Funkcija_Funkcije_Zaposlenih]
FOREIGN KEY ([Id_funkcije]) REFERENCES [Funkcije_Zaposlenih] ([Id]);
GO
