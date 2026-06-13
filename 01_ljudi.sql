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
    -- Datum kreiranja kandidata se automatski postavlja pri unosu.
    [Kreiran_datum] DATETIME2 NOT NULL CONSTRAINT [DF_Kandidat_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    -- Svaki kandidat mora imati jedinstven identifikator.
    CONSTRAINT [PK_Kandidat] PRIMARY KEY ([Id]),
    -- JMBG kandidata ne sme da se ponavlja u sistemu.
    CONSTRAINT [UQ_Kandidat_JMBG] UNIQUE ([JMBG]),
    -- JMBG sme da ima samo cifre.
    CONSTRAINT [CK_Kandidat_JMBG_Format] CHECK ([JMBG] NOT LIKE '%[^0-9]%'),
    -- Datum rodjenja mora biti manji od danasnjeg datuma.
    CONSTRAINT [CK_Kandidat_Datum_rodjenja] CHECK ([Datum_rodjenja] < CONVERT(date, getdate())),
    -- Datum isteka lekarskog, ako je unet, ne sme biti pre datuma rodjenja.
    CONSTRAINT [CK_Kandidat_Istek_lekarskog] CHECK ([Istek_lekarskog] IS NULL OR [Istek_lekarskog] >= [Datum_rodjenja]),
    -- Datum isteka licne karte, ako je unet, ne sme biti pre datuma rodjenja.
    CONSTRAINT [CK_Kandidat_Istek_licne_karte] CHECK ([Istek_licne_karte] IS NULL OR [Istek_licne_karte] >= [Datum_rodjenja])
);
GO

CREATE TABLE [Zaposleni] (
    [Id] UNIQUEIDENTIFIER NOT NULL,
    [Kvalifikacija] NVARCHAR(100),
    -- Novi zaposleni je podrazumevano aktivan.
    [Aktivni_ugovor] BIT NOT NULL CONSTRAINT [DF_Zaposleni_Aktivni_ugovor] DEFAULT (1),
    [Ime] NVARCHAR(50) NOT NULL,
    [Ime_roditelja] NVARCHAR(50),
    [Prezime] NVARCHAR(50) NOT NULL,
    [JMBG] CHAR(13) NOT NULL,
    [Istek_licne_karte] DATE,
    [Telefon] NVARCHAR(15) NOT NULL,
    [Email] NVARCHAR(100),
    [Datum_rodjenja] DATE NOT NULL,
    -- Datum kreiranja zaposlenog se automatski postavlja pri unosu.
    [Kreiran_datum] DATETIME2 NOT NULL CONSTRAINT [DF_Zaposleni_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    -- Svaki zaposleni mora imati jedinstven identifikator.
    CONSTRAINT [PK_Zaposleni] PRIMARY KEY ([Id]),
    -- JMBG zaposlenog ne sme da se ponavlja u sistemu.
    CONSTRAINT [UQ_Zaposleni_JMBG] UNIQUE ([JMBG]),
    -- JMBG sme da ima samo cifre.
    CONSTRAINT [CK_Zaposleni_JMBG_Format] CHECK ([JMBG] NOT LIKE '%[^0-9]%'),
    -- Datum rodjenja mora biti manji od danasnjeg datuma.
    CONSTRAINT [CK_Zaposleni_Datum_rodjenja] CHECK ([Datum_rodjenja] < CONVERT(date, getdate())),
    -- Datum isteka licne karte, ako je unet, ne sme biti pre datuma rodjenja.
    CONSTRAINT [CK_Zaposleni_Istek_licne_karte] CHECK ([Istek_licne_karte] IS NULL OR [Istek_licne_karte] >= [Datum_rodjenja])
);
GO

CREATE TABLE [Zaposleni_Izostanak] (
    -- Identifikator izostanka se automatski generise.
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Zaposleni_Izostanak_Id] DEFAULT (newid()),
    [Zaposleni_id] UNIQUEIDENTIFIER NOT NULL,
    [Tip] NVARCHAR(20) NOT NULL,
    [Datum_od] DATE NOT NULL,
    [Datum_do] DATE,
    -- Svaki izostanak mora imati jedinstven identifikator.
    CONSTRAINT [PK_Zaposleni_Izostanak] PRIMARY KEY ([Id]),
    -- Tip izostanka moze biti samo bolovanje ili godisnji odmor.
    CONSTRAINT [CK_Zaposleni_Izostanak_Tip] CHECK ([Tip] IN (N'BOL', N'GODISNJI')),
    -- Datum zavrsetka izostanka, ako postoji, ne sme biti pre datuma pocetka.
    CONSTRAINT [CK_Zaposleni_Izostanak_Datum] CHECK ([Datum_do] IS NULL OR [Datum_do] >= [Datum_od])
);
GO

CREATE TABLE [Zaposleni_Funkcija] (
    [Id_zaposlenog] UNIQUEIDENTIFIER NOT NULL,
    [Id_funkcije] UNIQUEIDENTIFIER NOT NULL,
    -- Isti zaposleni ne moze imati istu funkciju upisanu vise puta.
    CONSTRAINT [PK_Zaposleni_Funkcija] PRIMARY KEY ([Id_zaposlenog], [Id_funkcije])
);
GO

CREATE TABLE [Funkcije_Zaposlenih] (
    -- Identifikator funkcije se automatski generise.
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Funkcije_Zaposlenih_Id] DEFAULT (newid()),
    [Ime_funkcije] NVARCHAR(50) NOT NULL,
    [Minimalna_kvalifikacija] NVARCHAR(50),
    [Opis] NVARCHAR(100),
    -- Svaka funkcija mora imati jedinstven identifikator.
    CONSTRAINT [PK_Funkcije_Zaposlenih] PRIMARY KEY ([Id]),
    -- Naziv funkcije ne sme da se ponavlja.
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
-- Izostanak mora pripadati postojecem zaposlenom.
FOREIGN KEY ([Zaposleni_id]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Zaposleni_Funkcija]
ADD CONSTRAINT [FK_Zaposleni_Funkcija_Zaposleni]
-- Veza funkcije mora pokazivati na postojeceg zaposlenog.
FOREIGN KEY ([Id_zaposlenog]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Zaposleni_Funkcija]
ADD CONSTRAINT [FK_Zaposleni_Funkcija_Funkcije_Zaposlenih]
-- Veza funkcije mora pokazivati na postojecu funkciju.
FOREIGN KEY ([Id_funkcije]) REFERENCES [Funkcije_Zaposlenih] ([Id]);
GO
