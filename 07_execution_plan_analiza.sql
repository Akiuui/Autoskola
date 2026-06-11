-- Analiza najcescih read upita i izbor indeksa.
--
-- Nacin koriscenja u SSMS-u:
-- 1. Pokrenuti 00_master.sql i 06_test_podaci.sql.
-- 2. Ukljuciti Actual Execution Plan: Ctrl + M.
-- 3. Pokrenuti ovaj fajl PRE kreiranja dodatnih indeksa.
-- 4. Zapisati operacije iz plana izvrsavanja i vrednosti logical reads / CPU time.
-- 5. Kreirati predlozene indekse.
-- 6. Ponovo pokrenuti iste upite i uporediti rezultate.

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

DECLARE @InstruktorId UNIQUEIDENTIFIER = (
    SELECT TOP (1) [Instruktor_id]
    FROM [Cas]
    WHERE [Instruktor_id] IS NOT NULL
    GROUP BY [Instruktor_id]
    ORDER BY COUNT(*) DESC
);

DECLARE @DatumOd DATE = '2026-05-01';
DECLARE @DatumDo DATE = '2026-05-31';

DECLARE @ObukaId UNIQUEIDENTIFIER = (
    SELECT TOP (1) [Id]
    FROM [Obuka]
    ORDER BY [Datum_pocetka] DESC
);

DECLARE @KandidatId UNIQUEIDENTIFIER = (
    SELECT TOP (1) [Kandidat_id]
    FROM [Obuka]
    GROUP BY [Kandidat_id]
    ORDER BY COUNT(*) DESC
);

DECLARE @KategorijaId UNIQUEIDENTIFIER = (
    SELECT TOP (1) [Kategorija_id]
    FROM [Obuka]
    GROUP BY [Kategorija_id]
    ORDER BY COUNT(*) DESC
);

DECLARE @GrupaId UNIQUEIDENTIFIER = (
    SELECT TOP (1) [Grupa_id]
    FROM [Kandidat_grupa]
    GROUP BY [Grupa_id]
    ORDER BY COUNT(*) DESC
);

DECLARE @FunkcijaId UNIQUEIDENTIFIER = (
    SELECT TOP (1) [Id_funkcije]
    FROM [Zaposleni_Funkcija]
    GROUP BY [Id_funkcije]
    ORDER BY COUNT(*) DESC
);

-- 1. Casovi po instruktoru i datumu
-- Poslovno pitanje: koji raspored ima instruktor u zadatom periodu?
-- Kolone za indeks: Cas(Instruktor_id, Datum), jer su obe u WHERE uslovu.
-- Predlog indeksa:
-- CREATE INDEX IX_Cas_Instruktor_Datum ON [Cas] ([Instruktor_id], [Datum]);
SELECT
    c.[Id],
    c.[Datum],
    c.[Pocetak],
    c.[Kraj],
    c.[Status],
    c.[Lokacija],
    tob.[Tip] AS [Tip_casa],
    z.[Ime] + N' ' + z.[Prezime] AS [Instruktor]
FROM [Cas] c
JOIN [Tip_obuke] tob ON tob.[Id] = c.[Tip_id]
JOIN [Zaposleni] z ON z.[Id] = c.[Instruktor_id]
WHERE c.[Instruktor_id] = @InstruktorId
  AND c.[Datum] BETWEEN @DatumOd AND @DatumDo
ORDER BY c.[Datum], c.[Pocetak];

-- 2. Casovi po obuci
-- Poslovno pitanje: koje casove je kandidat imao u okviru konkretne obuke?
-- Kolone za indeks: Cas(Obuka_id, Datum), jer se filtrira po obuci i sortira po datumu.
-- Predlog indeksa:
-- CREATE INDEX IX_Cas_Obuka_Datum ON [Cas] ([Obuka_id], [Datum]);
SELECT
    c.[Id],
    c.[Datum],
    c.[Pocetak],
    c.[Kraj],
    c.[Status],
    c.[Lokacija],
    tob.[Tip] AS [Tip_casa],
    z.[Ime] + N' ' + z.[Prezime] AS [Instruktor],
    v.[Registracija],
    v.[Marka],
    v.[Model]
FROM [Cas] c
JOIN [Tip_obuke] tob ON tob.[Id] = c.[Tip_id]
JOIN [Zaposleni] z ON z.[Id] = c.[Instruktor_id]
LEFT JOIN [Vozilo] v ON v.[Id] = c.[Vozilo_id]
WHERE c.[Obuka_id] = @ObukaId
ORDER BY c.[Datum], c.[Pocetak];

-- 3. Obuka po kandidatu i kategoriji
-- Poslovno pitanje: koje obuke ima kandidat za izabranu kategoriju?
-- Kolone za indeks: Obuka(Kandidat_id, Kategorija_id, Datum_pocetka).
-- Predlog indeksa:
-- CREATE INDEX IX_Obuka_Kandidat_Kategorija_Datum ON [Obuka] ([Kandidat_id], [Kategorija_id], [Datum_pocetka]);
SELECT
    o.[Id],
    o.[Datum_pocetka],
    o.[Datum_zavrsetka],
    o.[Status],
    k.[Ime],
    k.[Prezime],
    kv.[Oznaka] AS [Kategorija],
    tob.[Tip] AS [Tip_obuke],
    z.[Ime] + N' ' + z.[Prezime] AS [Glavni_instruktor]
FROM [Obuka] o
JOIN [Kandidat] k ON k.[Id] = o.[Kandidat_id]
JOIN [Kategorija_vozacke] kv ON kv.[Id] = o.[Kategorija_id]
JOIN [Tip_obuke] tob ON tob.[Id] = o.[Tip_Obuke]
LEFT JOIN [Zaposleni] z ON z.[Id] = o.[Glavni_Instruktor_id]
WHERE o.[Kandidat_id] = @KandidatId
  AND o.[Kategorija_id] = @KategorijaId
ORDER BY o.[Datum_pocetka] DESC;

-- 4. Uplate po obuci
-- Poslovno pitanje: koliko je placeno za konkretnu obuku i koje uplate postoje?
-- Kolone za indeks: Uplata(Obuka_id), uz INCLUDE za iznos, datum i nacin placanja.
-- Predlog indeksa:
-- CREATE INDEX IX_Uplata_Obuka_INCLUDE ON [Uplata] ([Obuka_id]) INCLUDE ([Iznos], [Datum], [Nacin_placanja], [Cenovnik_id]);
SELECT
    u.[Id],
    u.[Datum],
    u.[Iznos],
    u.[Nacin_placanja],
    c.[Naziv] AS [Stavka_cenovnika],
    SUM(u.[Iznos]) OVER (PARTITION BY u.[Obuka_id]) AS [Ukupno_uplaceno_za_obuku]
FROM [Uplata] u
JOIN [Cenovnik] c ON c.[Id] = u.[Cenovnik_id]
WHERE u.[Obuka_id] = @ObukaId
ORDER BY u.[Datum];

-- 5. Uplate po datumu
-- Poslovno pitanje: koliki je prihod u zadatom periodu, po danu i nacinu placanja?
-- Kolone za indeks: Uplata(Datum), uz INCLUDE za nacin placanja i iznos.
-- Predlog indeksa:
-- CREATE INDEX IX_Uplata_Datum_INCLUDE ON [Uplata] ([Datum]) INCLUDE ([Nacin_placanja], [Iznos]);
SELECT
    u.[Datum],
    u.[Nacin_placanja],
    COUNT(*) AS [Broj_uplata],
    SUM(u.[Iznos]) AS [Ukupno]
FROM [Uplata] u
WHERE u.[Datum] BETWEEN @DatumOd AND @DatumDo
GROUP BY u.[Datum], u.[Nacin_placanja]
ORDER BY u.[Datum], u.[Nacin_placanja];

-- 6. Polaganja po obuci
-- Poslovno pitanje: kakve rezultate polaganja ima kandidat u okviru obuke?
-- Kolone za indeks: Polaganje_kandidat(Obuka_id), uz INCLUDE za podatke rezultata.
-- Predlog indeksa:
-- CREATE INDEX IX_Polaganje_kandidat_Obuka_INCLUDE ON [Polaganje_kandidat] ([Obuka_id]) INCLUDE ([Polaganje_id], [Uspesno], [Broj_Poenta]);
SELECT
    p.[Id] AS [Polaganje_id],
    p.[Pocetak],
    p.[Kraj],
    tob.[Tip] AS [Tip_polaganja],
    pk.[Uspesno],
    pk.[Broj_Poenta]
FROM [Polaganje_kandidat] pk
JOIN [Polaganje] p ON p.[Id] = pk.[Polaganje_id]
JOIN [Tip_obuke] tob ON tob.[Id] = p.[Tip_id]
WHERE pk.[Obuka_id] = @ObukaId
ORDER BY p.[Pocetak] DESC;

-- 7. Kandidati po grupi
-- Poslovno pitanje: koji kandidati pripadaju izabranoj grupi?
-- Kolone za indeks: Kandidat_grupa(Grupa_id), uz INCLUDE za obuku i datume clanstva.
-- Predlog indeksa:
-- CREATE INDEX IX_Kandidat_grupa_Grupa_INCLUDE ON [Kandidat_grupa] ([Grupa_id]) INCLUDE ([Obuka_id], [Datum_od], [Datum_do]);
SELECT
    k.[Ime],
    k.[Prezime],
    k.[Telefon],
    k.[Email],
    kg.[Datum_od],
    kg.[Datum_do],
    o.[Status],
    kv.[Oznaka] AS [Kategorija]
FROM [Kandidat_grupa] kg
JOIN [Obuka] o ON o.[Id] = kg.[Obuka_id]
JOIN [Kandidat] k ON k.[Id] = o.[Kandidat_id]
JOIN [Kategorija_vozacke] kv ON kv.[Id] = o.[Kategorija_id]
WHERE kg.[Grupa_id] = @GrupaId
ORDER BY k.[Prezime], k.[Ime];

-- 8. Zaposleni po funkciji
-- Poslovno pitanje: koji zaposleni imaju izabranu funkciju, npr. instruktor ili nadzornik?
-- Kolone za indeks: Zaposleni_Funkcija(Id_funkcije, Id_zaposlenog).
-- Predlog indeksa:
-- CREATE INDEX IX_Zaposleni_Funkcija_Funkcija_Zaposleni ON [Zaposleni_Funkcija] ([Id_funkcije], [Id_zaposlenog]);
SELECT
    z.[Ime],
    z.[Prezime],
    z.[Telefon],
    z.[Email],
    z.[Aktivni_ugovor],
    f.[Ime_funkcije],
    f.[Minimalna_kvalifikacija]
FROM [Zaposleni_Funkcija] zf
JOIN [Zaposleni] z ON z.[Id] = zf.[Id_zaposlenog]
JOIN [Funkcije_Zaposlenih] f ON f.[Id] = zf.[Id_funkcije]
WHERE zf.[Id_funkcije] = @FunkcijaId
ORDER BY z.[Prezime], z.[Ime];

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
