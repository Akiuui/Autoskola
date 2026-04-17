CREATE TABLE [Osoba] (
  [Id] string PRIMARY KEY,
  [Ime] string,
  [Ime_roditelja] string,
  [Prezime] string,
  [JMBG] string UNIQUE,
  [Telefon] string,
  [Email] string,
  [Datum_rodjenja] date
)
GO

CREATE TABLE [Kandidat] (
  [Id_osobe] string PRIMARY KEY,
  [Istek_lekarskog] date,
  [Datum_prve_pomoci] date
)
GO

CREATE TABLE [Zaposleni] (
  [Id_osobe] string PRIMARY KEY,
  [Kvalifikacija] string,
  [Aktivni_ugovor] boolean,
  [Tip_zaposlenog_id] string
)
GO

CREATE TABLE [Tip_zaposlenih] (
  [Id] string PRIMARY KEY,
  [Tip] string,
  [Opis] string
)
GO

CREATE TABLE [Kategorija_vozacke] (
  [Id] string PRIMARY KEY,
  [Oznaka] char,
  [Opis] string
)
GO

CREATE TABLE [Obuka] (
  [Id] string PRIMARY KEY,
  [Kandidat_id] string,
  [Kategorija_id] string,
  [Teorijski_instruktor_id] string,
  [Prakticni_instruktor_id] string,
  [Datum_pocetka] date,
  [Datum_zavrsetka] date,
  [Status] string
)
GO

CREATE TABLE [Grupa] (
  [Id] string PRIMARY KEY,
  [Tip] string,
  [Datum_kreiranja] date,
  [Datum_zavrsetka] date
)
GO

CREATE TABLE [Grupa_kandidat] (
  [Grupa_id] string,
  [Kandidat_id] string,
  PRIMARY KEY ([Grupa_id], [Kandidat_id])
)
GO

CREATE TABLE [Cas] (
  [Id] string PRIMARY KEY,
  [Instruktor_id] string,
  [Datum] date,
  [Pocetak] timestamp,
  [Kraj] timestamp,
  [Trajanje] time
)
GO

CREATE TABLE [Prakticni_cas] (
  [Cas_id] string PRIMARY KEY,
  [Kandidat_id] string,
  [Vozilo_id] string
)
GO

CREATE TABLE [Teorijski_cas] (
  [Cas_id] string PRIMARY KEY,
  [Grupa_id] string
)
GO

CREATE TABLE [Tip_Polaganja] (
  [Id] string PRIMARY KEY,
  [Tip] string,
  [Opis] string
)
GO

CREATE TABLE [Polaganje] (
  [Id] string PRIMARY KEY,
  [Obuka_id] string,
  [Grupa_id] string,
  [Tip_polaganja_id] string,
  [Uspesno] boolean,
  [Pocetak] date,
  [Kraj] date
)
GO

CREATE TABLE [Nadzornici_polaganja] (
  [Polaganje_id] string,
  [Nadzornik_id] string,
  PRIMARY KEY ([Polaganje_id], [Nadzornik_id])
)
GO

CREATE TABLE [Zaposleni_status] (
  [Id] string PRIMARY KEY,
  [Zaposleni_id] string,
  [Tip] string,
  [Datum_od] date,
  [Datum_do] date
)
GO

CREATE TABLE [Vozilo] (
  [Id] string PRIMARY KEY,
  [Registracija] string UNIQUE,
  [Marka] string,
  [Model] string,
  [Godiste] integer,
  [Kategorija_id] string,
  [Kilometraza] integer,
  [Datum_registracije] date
)
GO

CREATE TABLE [Usluga] (
  [Id] string PRIMARY KEY,
  [Naziv] string,
  [Opis] string
)
GO

CREATE TABLE [Uplata] (
  [Id] string PRIMARY KEY,
  [Kandidat_id] string,
  [Cenovnik_id] string,
  [Obuka_id] string,
  [Iznos] decimal,
  [Datum] date,
  [Nacin_placanja_id] string
)
GO

CREATE TABLE [Cenovnik] (
  [Id] string PRIMARY KEY,
  [Usluga_id] string,
  [Cena] decimal,
  [Datum_od] date,
  [Datum_do] date
)
GO

CREATE TABLE [Nacin_placanja] (
  [Id] string PRIMARY KEY,
  [Naziv] string
)
GO

ALTER TABLE [Kandidat] ADD FOREIGN KEY ([Id_osobe]) REFERENCES [Osoba] ([Id])
GO

ALTER TABLE [Zaposleni] ADD FOREIGN KEY ([Id_osobe]) REFERENCES [Osoba] ([Id])
GO

ALTER TABLE [Zaposleni] ADD FOREIGN KEY ([Tip_zaposlenog_id]) REFERENCES [Tip_zaposlenih] ([Id])
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Kandidat_id]) REFERENCES [Kandidat] ([Id_osobe])
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Kategorija_id]) REFERENCES [Kategorija_vozacke] ([Id])
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Teorijski_instruktor_id]) REFERENCES [Zaposleni] ([Id_osobe])
GO

ALTER TABLE [Obuka] ADD FOREIGN KEY ([Prakticni_instruktor_id]) REFERENCES [Zaposleni] ([Id_osobe])
GO

ALTER TABLE [Grupa_kandidat] ADD FOREIGN KEY ([Grupa_id]) REFERENCES [Grupa] ([Id])
GO

ALTER TABLE [Grupa_kandidat] ADD FOREIGN KEY ([Kandidat_id]) REFERENCES [Kandidat] ([Id_osobe])
GO

ALTER TABLE [Cas] ADD FOREIGN KEY ([Instruktor_id]) REFERENCES [Zaposleni] ([Id_osobe])
GO

ALTER TABLE [Prakticni_cas] ADD FOREIGN KEY ([Cas_id]) REFERENCES [Cas] ([Id])
GO

ALTER TABLE [Prakticni_cas] ADD FOREIGN KEY ([Kandidat_id]) REFERENCES [Kandidat] ([Id_osobe])
GO

ALTER TABLE [Prakticni_cas] ADD FOREIGN KEY ([Vozilo_id]) REFERENCES [Vozilo] ([Id])
GO

ALTER TABLE [Teorijski_cas] ADD FOREIGN KEY ([Cas_id]) REFERENCES [Cas] ([Id])
GO

ALTER TABLE [Teorijski_cas] ADD FOREIGN KEY ([Grupa_id]) REFERENCES [Grupa] ([Id])
GO

ALTER TABLE [Polaganje] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id])
GO

ALTER TABLE [Polaganje] ADD FOREIGN KEY ([Grupa_id]) REFERENCES [Grupa] ([Id])
GO

ALTER TABLE [Polaganje] ADD FOREIGN KEY ([Tip_polaganja_id]) REFERENCES [Tip_Polaganja] ([Id])
GO

ALTER TABLE [Nadzornici_polaganja] ADD FOREIGN KEY ([Polaganje_id]) REFERENCES [Polaganje] ([Id])
GO

ALTER TABLE [Nadzornici_polaganja] ADD FOREIGN KEY ([Nadzornik_id]) REFERENCES [Zaposleni] ([Id_osobe])
GO

ALTER TABLE [Zaposleni_status] ADD FOREIGN KEY ([Zaposleni_id]) REFERENCES [Zaposleni] ([Id_osobe])
GO

ALTER TABLE [Vozilo] ADD FOREIGN KEY ([Kategorija_id]) REFERENCES [Kategorija_vozacke] ([Id])
GO

ALTER TABLE [Cenovnik] ADD FOREIGN KEY ([Usluga_id]) REFERENCES [Usluga] ([Id])
GO

ALTER TABLE [Uplata] ADD FOREIGN KEY ([Kandidat_id]) REFERENCES [Kandidat] ([Id_osobe])
GO

ALTER TABLE [Uplata] ADD FOREIGN KEY ([Cenovnik_id]) REFERENCES [Cenovnik] ([Id])
GO

ALTER TABLE [Uplata] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id])
GO

ALTER TABLE [Uplata] ADD FOREIGN KEY ([Nacin_placanja_id]) REFERENCES [Nacin_placanja] ([Id])
GO
