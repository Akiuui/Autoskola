GO

-- 1. Casovi po instruktoru i datumu
SELECT
    c.Id,
    c.Datum,
    c.Pocetak,
    c.Kraj,
    c.Status,
    c.Lokacija,
    t.Tip AS Tip_casa,
    z.Ime + N' ' + z.Prezime AS Instruktor
FROM Cas c
JOIN Tip_obuke t ON t.Id = c.Tip_id
JOIN Zaposleni z ON z.Id = c.Instruktor_id
WHERE z.JMBG = '0404000710008'
  AND c.Datum BETWEEN '2026-06-01' AND '2026-07-31'
ORDER BY c.Datum, c.Pocetak;
-- CREATE INDEX IX_Cas_Instruktor_Datum_Pocetak ON Cas (Instruktor_id, Datum, Pocetak);
-- DROP INDEX IF EXISTS IX_Cas_Instruktor_Datum_Pocetak ON Cas;

-- 2. Casovi po kandidatu
SELECT
    c.Id,
    c.Datum,
    c.Pocetak,
    c.Kraj,
    c.Status,
    c.Lokacija,
    t.Tip AS Tip_casa,
    z.Ime + N' ' + z.Prezime AS Instruktor,
    v.Registracija,
    v.Marka,
    v.Model
FROM Cas c
JOIN Obuka o ON o.Id = c.Obuka_id
JOIN Kandidat k ON k.Id = o.Kandidat_id
JOIN Tip_obuke t ON t.Id = c.Tip_id
JOIN Zaposleni z ON z.Id = c.Instruktor_id
LEFT JOIN Vozilo v ON v.Id = c.Vozilo_id
WHERE k.JMBG = '1502002715002'
ORDER BY c.Datum, c.Pocetak;
-- CREATE INDEX IX_Cas_Obuka_Datum_Pocetak ON Cas (Obuka_id, Datum, Pocetak);
-- Posto radi keylookup mozemo da dodamo i ovo da bi ga izbacili:
-- INCLUDE (Kraj, Status, Lokacija, Instruktor_id, Tip_id, Vozilo_id);
-- DROP INDEX IF EXISTS IX_Cas_Obuka_Datum_Pocetak ON Cas;

-- 3. Obuka po kandidatu i kategoriji
SELECT
    o.Id,
    o.Datum_pocetka,
    o.Datum_zavrsetka,
    o.Status,
    k.Ime,
    k.Prezime,
    kv.Oznaka AS Kategorija,
    t.Tip AS Tip_obuke,
    z.Ime + N' ' + z.Prezime AS Glavni_instruktor
FROM Obuka o
JOIN Kandidat k ON k.Id = o.Kandidat_id
JOIN Kategorija_vozacke kv ON kv.Id = o.Kategorija_id
JOIN Tip_obuke t ON t.Id = o.Tip_Obuke
LEFT JOIN Zaposleni z ON z.Id = o.Glavni_Instruktor_id
WHERE k.JMBG = '0101000710001'
  AND kv.Oznaka = 'B'
ORDER BY o.Datum_pocetka DESC;
-- CREATE INDEX IX_Obuka_Kandidat_Kategorija_Datum ON Obuka (Kandidat_id, Kategorija_id, Datum_pocetka);
-- Posto radi keylookup mozemo da dodamo i ovo da bi ga izbacili:
-- INCLUDE (Datum_zavrsetka, Status, Tip_Obuke, Glavni_Instruktor_id);
-- DROP INDEX IF EXISTS IX_Obuka_Kandidat_Kategorija_Datum ON Obuka;

-- 4. Uplate po obuci
SELECT
    u.Id,
    u.Datum,
    u.Iznos,
    u.Nacin_placanja,
    c.Naziv AS Stavka_cenovnika
FROM Uplata u
JOIN Obuka o ON o.Id = u.Obuka_id
JOIN Kandidat k ON k.Id = o.Kandidat_id
JOIN Cenovnik c ON c.Id = u.Cenovnik_id
WHERE k.JMBG = '0101000710001'
ORDER BY u.Datum;
-- CREATE INDEX IX_Uplata_Obuka_INCLUDE ON Uplata (Obuka_id) 
-- INCLUDE (Iznos, Datum, Nacin_placanja, Cenovnik_id);
-- DROP INDEX IF EXISTS IX_Uplata_Obuka_INCLUDE ON Uplata;

-- 5. Uplate po datumu
SELECT
    u.Datum,
    u.Nacin_placanja,
    COUNT(*) AS Broj_uplata,
    SUM(u.Iznos) AS Ukupno
FROM Uplata u
WHERE u.Datum BETWEEN '2026-06-01' AND '2026-08-31'
GROUP BY u.Datum, u.Nacin_placanja
ORDER BY u.Datum, u.Nacin_placanja;
-- CREATE INDEX IX_Uplata_Datum_INCLUDE ON Uplata (Datum, Nacin_placanja)
-- INCLUDE (Iznos);
-- DROP INDEX IF EXISTS IX_Uplata_Datum_INCLUDE ON Uplata;

-- 6. Polaganja po kandidatu
SELECT
    p.Id AS Polaganje_id,
    p.Pocetak,
    p.Kraj,
    t.Tip AS Tip_polaganja,
    pk.Uspesno,
    pk.Broj_Poenta
FROM Polaganje_kandidat pk
JOIN Polaganje p ON p.Id = pk.Polaganje_id
JOIN Obuka o ON o.Id = pk.Obuka_id
JOIN Kandidat k ON k.Id = o.Kandidat_id
JOIN Tip_obuke t ON t.Id = p.Tip_id
WHERE k.JMBG = '1204004715004'
-- CREATE INDEX IX_Polaganje_kandidat_Obuka_INCLUDE ON Polaganje_kandidat (Obuka_id) INCLUDE (Polaganje_id, Uspesno, Broj_Poenta);
-- DROP INDEX IF EXISTS IX_Polaganje_kandidat_Obuka_INCLUDE ON Polaganje_kandidat;


-- 7. Kandidati po grupi
SELECT
    k.Ime,
    k.Prezime,
    k.Telefon,
    k.Email,
    kg.Datum_od,
    kg.Datum_do,
    o.Status,
    kv.Oznaka AS Kategorija
FROM Kandidat_grupa kg
JOIN Grupa g ON g.Id = kg.Grupa_id
JOIN Obuka o ON o.Id = kg.Obuka_id
JOIN Kandidat k ON k.Id = o.Kandidat_id
JOIN Kategorija_vozacke kv ON kv.Id = o.Kategorija_id
WHERE g.Datum_kreiranja = '2026-04-01'
ORDER BY k.Prezime, k.Ime;
-- CREATE INDEX IX_Kandidat_grupa_Grupa_INCLUDE ON Kandidat_grupa (Grupa_id) INCLUDE (Obuka_id, Datum_od, Datum_do);
-- DROP INDEX IF EXISTS IX_Kandidat_grupa_Grupa_INCLUDE ON Kandidat_grupa;


-- 8. Zaposleni po funkciji
SELECT
    z.Ime,
    z.Prezime,
    z.Telefon,
    z.Email,
    z.Aktivni_ugovor,
    f.Ime_funkcije,
    f.Minimalna_kvalifikacija
FROM Zaposleni_Funkcija zf
JOIN Zaposleni z ON z.Id = zf.Id_zaposlenog
JOIN Funkcije_Zaposlenih f ON f.Id = zf.Id_funkcije
WHERE f.Ime_funkcije = N'Instruktor'
-- CREATE INDEX IX_Zaposleni_Funkcija_Funkcija_Zaposleni ON Zaposleni_Funkcija (Id_funkcije, Id_zaposlenog);
-- DROP INDEX IF EXISTS IX_Zaposleni_Funkcija_Funkcija_Zaposleni ON Zaposleni_Funkcija;

GO
