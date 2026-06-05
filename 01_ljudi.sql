CREATE TABLE [Kandidat] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY,
    [Istek_lekarskog] DATE,
    [Ime] NVARCHAR(50) NOT NULL,
    [Ime_roditelja] NVARCHAR(50),
    [Prezime] NVARCHAR(50) NOT NULL,
    [JMBG] CHAR(13) UNIQUE NOT NULL,
    [Istek_licne_karte] DATE,
    [Telefon] NVARCHAR(15) NOT NULL,
    [Email] NVARCHAR(100),
    [Datum_rodjenja] DATE NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2
);
GO

CREATE TABLE [Zaposleni] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY,
    [Kvalifikacija] NVARCHAR(100),
    [Aktivni_ugovor] BIT NOT NULL DEFAULT (1),
    [Ime] NVARCHAR(50) NOT NULL,
    [Ime_roditelja] NVARCHAR(50),
    [Prezime] NVARCHAR(50) NOT NULL,
    [JMBG] CHAR(13) UNIQUE NOT NULL,
    [Istek_licne_karte] DATE,
    [Telefon] NVARCHAR(15) NOT NULL,
    [Email] NVARCHAR(100),
    [Datum_rodjenja] DATE NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2
);
GO

CREATE TABLE [Zaposleni_Izostanak] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Zaposleni_id] UNIQUEIDENTIFIER NOT NULL,
    [Tip] NVARCHAR(20) NOT NULL,
    [Datum_od] DATE NOT NULL,
    [Datum_do] DATE
);
GO

CREATE TABLE [Zaposleni_Funkcija] (
    [Id_zaposlenog] UNIQUEIDENTIFIER NOT NULL,
    [Id_funkcije] UNIQUEIDENTIFIER NOT NULL
);
GO

CREATE TABLE [Funkcije_Zaposlenih] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Ime_funkcije] NVARCHAR(50) NOT NULL,
    [Minimalna_kvalifikacija] NVARCHAR(50),
    [Opis] NVARCHAR(100)
);
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'CHECK: BOL, GODISNJI',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Zaposleni_Izostanak',
@level2type = N'Column', @level2name = 'Tip';
GO

ALTER TABLE [Zaposleni_Izostanak] ADD FOREIGN KEY ([Zaposleni_id]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Zaposleni_Funkcija] ADD FOREIGN KEY ([Id_zaposlenog]) REFERENCES [Zaposleni] ([Id]);
GO

ALTER TABLE [Zaposleni_Funkcija] ADD FOREIGN KEY ([Id_funkcije]) REFERENCES [Funkcije_Zaposlenih] ([Id]);
GO
