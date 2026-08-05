GO

-- Pregled kandidata i njihovih obuka.
CREATE OR ALTER VIEW dbo.vw_Kandidati_Obuke
AS
SELECT
    o.Id AS Obuka_id,
    k.Id AS Kandidat_id,
    k.Ime AS Kandidat_ime,
    k.Prezime AS Kandidat_prezime,
    k.JMBG AS Kandidat_JMBG,
    k.Telefon AS Kandidat_telefon,
    k.Email AS Kandidat_email,
    kv.Oznaka AS Kategorija,
    kv.Opis AS Kategorija_opis,
    t.Tip AS Tip_obuke,
    o.Datum_pocetka,
    o.Datum_zavrsetka,
    o.Status,
    z.Id AS Instruktor_id,
    z.Ime + N' ' + z.Prezime AS Glavni_instruktor
FROM Obuka o
JOIN Kandidat k ON k.Id = o.Kandidat_id
JOIN Kategorija_vozacke kv ON kv.Id = o.Kategorija_id
JOIN Tip_obuke t ON t.Id = o.Tip_Obuke
LEFT JOIN Zaposleni z ON z.Id = o.Glavni_Instruktor_id;
GO

-- Pregled rasporeda casova.
CREATE OR ALTER VIEW dbo.vw_Raspored_Casova
AS
SELECT
    c.Id AS Cas_id,
    c.Datum,
    c.Pocetak,
    c.Kraj,
    c.Status AS Status_casa,
    c.Lokacija,
    t.Tip AS Tip_casa,
    z.Id AS Instruktor_id,
    z.Ime + N' ' + z.Prezime AS Instruktor,
    o.Id AS Obuka_id,
    k.Id AS Kandidat_id,
    k.Ime + N' ' + k.Prezime AS Kandidat,
    kv.Oznaka AS Kategorija,
    v.Registracija,
    v.Marka,
    v.Model,
    g.Id AS Grupa_id,
    g.Datum_kreiranja AS Datum_kreiranja_grupe
FROM Cas c
JOIN Tip_obuke t ON t.Id = c.Tip_id
JOIN Zaposleni z ON z.Id = c.Instruktor_id
LEFT JOIN Obuka o ON o.Id = c.Obuka_id
LEFT JOIN Kandidat k ON k.Id = o.Kandidat_id
LEFT JOIN Kategorija_vozacke kv ON kv.Id = o.Kategorija_id
LEFT JOIN Vozilo v ON v.Id = c.Vozilo_id
LEFT JOIN Grupa g ON g.Id = c.Grupa_id;
GO

-- Pregled uplata po obuci.
CREATE OR ALTER VIEW dbo.vw_Uplate_Po_Obuci
AS
SELECT
    o.Id AS Obuka_id,
    k.Id AS Kandidat_id,
    k.Ime + N' ' + k.Prezime AS Kandidat,
    k.JMBG,
    kv.Oznaka AS Kategorija,
    o.Status AS Status_obuke,
    COUNT(u.Id) AS Broj_uplata,
    COALESCE(SUM(u.Iznos), 0) AS Ukupno_uplaceno,
    MIN(u.Datum) AS Prva_uplata,
    MAX(u.Datum) AS Poslednja_uplata
FROM Obuka o
JOIN Kandidat k ON k.Id = o.Kandidat_id
JOIN Kategorija_vozacke kv ON kv.Id = o.Kategorija_id
LEFT JOIN Uplata u ON u.Obuka_id = o.Id
GROUP BY
    o.Id,
    k.Id,
    k.Ime,
    k.Prezime,
    k.JMBG,
    kv.Oznaka,
    o.Status;
GO

-- Pregled rezultata polaganja.
CREATE OR ALTER VIEW dbo.vw_Rezultati_Polaganja
AS
SELECT
    p.Id AS Polaganje_id,
    p.Pocetak,
    p.Kraj,
    t.Tip AS Tip_polaganja,
    o.Id AS Obuka_id,
    k.Id AS Kandidat_id,
    k.Ime + N' ' + k.Prezime AS Kandidat,
    k.JMBG,
    kv.Oznaka AS Kategorija,
    pk.Uspesno,
    pk.Broj_Poenta,
    CASE
        WHEN pk.Uspesno IS NULL THEN N'Nije evidentirano'
        WHEN pk.Uspesno = 1 THEN N'Polozio'
        ELSE N'Nije polozio'
    END AS Rezultat
FROM Polaganje_kandidat pk
JOIN Polaganje p ON p.Id = pk.Polaganje_id
JOIN Tip_obuke t ON t.Id = p.Tip_id
JOIN Obuka o ON o.Id = pk.Obuka_id
JOIN Kandidat k ON k.Id = o.Kandidat_id
JOIN Kategorija_vozacke kv ON kv.Id = o.Kategorija_id;
GO

-- Pregled zaposlenih i njihovih funkcija.
CREATE OR ALTER VIEW dbo.vw_Zaposleni_Funkcije
AS
SELECT
    z.Id AS Zaposleni_id,
    z.Ime,
    z.Prezime,
    z.JMBG,
    z.Telefon,
    z.Email,
    z.Kvalifikacija,
    z.Aktivni_ugovor,
    f.Id AS Funkcija_id,
    f.Ime_funkcije,
    f.Minimalna_kvalifikacija,
    f.Opis AS Opis_funkcije
FROM Zaposleni_Funkcija zf
JOIN Zaposleni z ON z.Id = zf.Id_zaposlenog
JOIN Funkcije_Zaposlenih f ON f.Id = zf.Id_funkcije;
GO

-- Pregled stanja obuke kroz casove, polaganja i uplate.
CREATE OR ALTER VIEW dbo.vw_Stanje_Obuke
AS
WITH Casovi AS (
    SELECT Obuka_id, COUNT(*) AS Broj_casova
    FROM Cas
    WHERE Obuka_id IS NOT NULL
    GROUP BY Obuka_id
),
Polaganja AS (
    SELECT Obuka_id, COUNT(*) AS Broj_polaganja
    FROM Polaganje_kandidat
    GROUP BY Obuka_id
),
Uplate AS (
    SELECT Obuka_id, SUM(Iznos) AS Ukupno_uplaceno
    FROM Uplata
    GROUP BY Obuka_id
)
SELECT
    o.Id AS Obuka_id,
    k.Ime + N' ' + k.Prezime AS Kandidat,
    k.JMBG,
    kv.Oznaka AS Kategorija,
    t.Tip AS Tip_obuke,
    o.Status,
    o.Datum_pocetka,
    o.Datum_zavrsetka,
    COALESCE(c.Broj_casova, 0) AS Broj_casova,
    COALESCE(p.Broj_polaganja, 0) AS Broj_polaganja,
    COALESCE(u.Ukupno_uplaceno, 0) AS Ukupno_uplaceno
FROM Obuka o
JOIN Kandidat k ON k.Id = o.Kandidat_id
JOIN Kategorija_vozacke kv ON kv.Id = o.Kategorija_id
JOIN Tip_obuke t ON t.Id = o.Tip_Obuke
LEFT JOIN Casovi c ON c.Obuka_id = o.Id
LEFT JOIN Polaganja p ON p.Obuka_id = o.Id
LEFT JOIN Uplate u ON u.Obuka_id = o.Id;
GO
