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
)
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
)
GO

CREATE TABLE [Zaposleni_Izostanak] (
  [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
  [Zaposleni_id] UNIQUEIDENTIFIER NOT NULL,
  [Tip] NVARCHAR(20) NOT NULL,
  [Datum_od] DATE NOT NULL,
  [Datum_do] DATE
)
GO

CREATE TABLE [Zaposleni_Funkcija] (
  [Id_zaposlenog] UNIQUEIDENTIFIER NOT NULL,
  [Id_funkcije] UNIQUEIDENTIFIER NOT NULL
)
GO

CREATE TABLE [Funkcije_Zaposlenih] (
  [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
  [Ime_funkcije] NVARCHAR(50) NOT NULL,
  [Minimalna_kvalifikacija] NVARCHAR(50),
  [Opis] NVARCHAR(100)
)
GO

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
)
GO

CREATE TABLE [Tip_obuke] (
  [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
  [Tip] NVARCHAR(30),
  [Opis] NVARCHAR(100)
)
GO

CREATE TABLE [Kategorija_vozacke] (
  [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
  [Oznaka] CHAR(2) NOT NULL,
  [Opis] NVARCHAR(50)
)
GO

CREATE TABLE [Grupa] (
  [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
  [Datum_kreiranja] DATE NOT NULL DEFAULT (getdate()),
  [Datum_zavrsetka] DATE
)
GO

CREATE TABLE [Kandidat_grupa] (
  [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
  [Grupa_id] UNIQUEIDENTIFIER NOT NULL,
  [Obuka_id] UNIQUEIDENTIFIER NOT NULL,
  [Datum_od] DATE NOT NULL,
  [Datum_do] DATE
)
GO

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
)
GO

CREATE TABLE [Polaganje] (
  [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
  [Tip_id] NVARCHAR(20) NOT NULL,
  [Pocetak] DATETIME2 NOT NULL,
  [Kraj] DATETIME2 NOT NULL,
  [Kreiran_datum] DATETIME2 NOT NULL DEFAULT (getdate()),
  [Izmenjen_datum] DATETIME2
)
GO

CREATE TABLE [Polaganje_kandidat] (
  [Polaganje_id] UNIQUEIDENTIFIER NOT NULL,
  [Obuka_id] UNIQUEIDENTIFIER NOT NULL,
  [Uspesno] BIT,
  [Broj_Poenta] TINYINT
)
GO

CREATE TABLE [Nadzornici_polaganja] (
  [Polaganje_id] UNIQUEIDENTIFIER NOT NULL,
  [Nadzornik_id] UNIQUEIDENTIFIER NOT NULL
)
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
)
GO

CREATE TABLE [Cenovnik] (
  [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
  [Naziv] NVARCHAR(100) NOT NULL,
  [Opis] NVARCHAR(500),
  [Cena] DECIMAL(10,2) NOT NULL,
  [Datum_od] DATE NOT NULL,
  [Datum_do] DATE
)
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
)
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'CHECK: BOL, GODISNJI',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Zaposleni_Izostanak',
@level2type = N'Column', @level2name = 'Tip';
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

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'enum: Teorijsko, Prakticno',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Polaganje',
@level2type = N'Column', @level2name = 'Tip_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'null = nije odrzano, 1 = polozio, 0 = nije polozio',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Polaganje_kandidat',
@level2type = N'Column', @level2name = 'Uspesno';
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

ALTER TABLE [Zaposleni_Izostanak] ADD FOREIGN KEY ([Zaposleni_id]) REFERENCES [Zaposleni] ([Id])
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Kandidat_id]) REFERENCES [Kandidat] ([Id])
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Kategorija_id]) REFERENCES [Kategorija_vozacke] ([Id])
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Glavni_Instruktor_id]) REFERENCES [Zaposleni] ([Id])
GO

ALTER TABLE [Kandidat_grupa] ADD FOREIGN KEY ([Grupa_id]) REFERENCES [Grupa] ([Id])
GO

ALTER TABLE [Kandidat_grupa] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id])
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Instruktor_id]) REFERENCES [Zaposleni] ([Id])
GO

ALTER TABLE [Polaganje_kandidat] ADD FOREIGN KEY ([Polaganje_id]) REFERENCES [Polaganje] ([Id])
GO

ALTER TABLE [Polaganje_kandidat] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id])
GO

ALTER TABLE [Nadzornici_polaganja] ADD FOREIGN KEY ([Polaganje_id]) REFERENCES [Polaganje] ([Id])
GO

ALTER TABLE [Nadzornici_polaganja] ADD FOREIGN KEY ([Nadzornik_id]) REFERENCES [Zaposleni] ([Id])
GO

ALTER TABLE [Vozilo] ADD FOREIGN KEY ([Kategorija_id]) REFERENCES [Kategorija_vozacke] ([Id])
GO

ALTER TABLE [Uplata] ADD FOREIGN KEY ([Cenovnik_id]) REFERENCES [Cenovnik] ([Id])
GO

ALTER TABLE [Uplata] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id])
GO

ALTER TABLE [Zaposleni_Funkcija] ADD FOREIGN KEY ([Id_zaposlenog]) REFERENCES [Zaposleni] ([Id])
GO

ALTER TABLE [Zaposleni_Funkcija] ADD FOREIGN KEY ([Id_funkcije]) REFERENCES [Funkcije_Zaposlenih] ([Id])
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Tip_Obuke]) REFERENCES [Tip_obuke] ([Id])
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Tip_id]) REFERENCES [Tip_obuke] ([Id])
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id])
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Vozilo_id]) REFERENCES [Vozilo] ([Id])
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Grupa_id]) REFERENCES [Grupa] ([Id])
GO

ALTER TABLE [Tip_obuke] ADD FOREIGN KEY ([Id]) REFERENCES [Polaganje] ([Tip_id])
GO
