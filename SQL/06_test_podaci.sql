-- Test podaci za bazu Auto skola.
-- Pokrenuti nakon kreiranja svih tabela.
-- Id kolone se ne unose rucno; baza ih generise preko IDENTITY svojstva.

INSERT INTO Kandidat (
    Istek_lekarskog, Ime, Ime_roditelja, Prezime, JMBG,
    Istek_licne_karte, Telefon, Email, Datum_rodjenja
)
SELECT v.Istek_lekarskog, v.Ime, v.Ime_roditelja, v.Prezime, v.JMBG,
       v.Istek_licne_karte, v.Telefon, v.Email, v.Datum_rodjenja
FROM (VALUES
    ('2026-12-15', N'Marko', N'Petar', N'Markovic', '0101000710001', '2030-05-20', '0601234567', 'marko.markovic@example.com', '2000-01-01'),
    ('2027-02-10', N'Jelena', N'Milan', N'Jovanovic', '1502002715002', '2031-04-11', '0602345678', 'jelena.jovanovic@example.com', '2002-02-15'),
    ('2026-09-01', N'Nikola', N'Dragan', N'Petrovic', '2303003710003', '2029-12-01', '0603456789', 'nikola.petrovic@example.com', '2003-03-23'),
    ('2026-11-30', N'Ana', N'Goran', N'Ilic', '1204004715004', '2032-07-19', '0604567890', 'ana.ilic@example.com', '2004-04-12'),
    ('2027-01-20', N'Luka', N'Zoran', N'Nikolic', '0505005710005', '2030-10-25', '0605678901', 'luka.nikolic@example.com', '2005-05-05')
) AS v(Istek_lekarskog, Ime, Ime_roditelja, Prezime, JMBG, Istek_licne_karte, Telefon, Email, Datum_rodjenja)
WHERE NOT EXISTS (SELECT 1 FROM Kandidat k WHERE k.JMBG = v.JMBG);

INSERT INTO Zaposleni (
    Kvalifikacija, Aktivni_ugovor, Ime, Ime_roditelja, Prezime,
    JMBG, Istek_licne_karte, Telefon, Email, Datum_rodjenja
)
SELECT v.Kvalifikacija, v.Aktivni_ugovor, v.Ime, v.Ime_roditelja, v.Prezime,
       v.JMBG, v.Istek_licne_karte, v.Telefon, v.Email, v.Datum_rodjenja
FROM (VALUES
    (N'Diplomirani inzenjer saobracaja', 1, N'Milos', N'Radovan', N'Savic', '0202000710006', '2030-03-10', '0611111111', 'milos.savic@autoskolatest.rs', '1985-02-02'),
    (N'Instruktor B kategorije', 1, N'Dejan', N'Branko', N'Kostic', '0303000710007', '2029-08-17', '0612222222', 'dejan.kostic@autoskolatest.rs', '1988-03-03'),
    (N'Instruktor A i B kategorije', 1, N'Ivan', N'Zeljko', N'Pavlovic', '0404000710008', '2031-11-05', '0613333333', 'ivan.pavlovic@autoskolatest.rs', '1990-04-04'),
    (N'Administrativni radnik', 1, N'Marija', N'Dusan', N'Ristic', '0505000715009', '2032-01-22', '0614444444', 'marija.ristic@autoskolatest.rs', '1992-05-05'),
    (N'Ispitivac teorije', 1, N'Stefan', N'Mirko', N'Lazic', '0606000710010', '2028-06-14', '0615555555', 'stefan.lazic@autoskolatest.rs', '1982-06-06')
) AS v(Kvalifikacija, Aktivni_ugovor, Ime, Ime_roditelja, Prezime, JMBG, Istek_licne_karte, Telefon, Email, Datum_rodjenja)
WHERE NOT EXISTS (SELECT 1 FROM Zaposleni z WHERE z.JMBG = v.JMBG);

INSERT INTO Funkcije_Zaposlenih (Ime_funkcije, Minimalna_kvalifikacija, Opis)
SELECT v.Ime_funkcije, v.Minimalna_kvalifikacija, v.Opis
FROM (VALUES
    (N'Direktor', N'VII stepen', N'Organizacija rada auto skole'),
    (N'Instruktor', N'Instruktor voznje', N'Izvodi prakticne casove'),
    (N'Predavac teorije', N'Licenca za teorijsku nastavu', N'Izvodi teorijsku nastavu'),
    (N'Administrator', N'SSS', N'Vodi evidenciju kandidata i uplata'),
    (N'Nadzornik polaganja', N'Licenca ispitivaca', N'Nadzire polaganja kandidata')
) AS v(Ime_funkcije, Minimalna_kvalifikacija, Opis)
WHERE NOT EXISTS (SELECT 1 FROM Funkcije_Zaposlenih f WHERE f.Ime_funkcije = v.Ime_funkcije);

INSERT INTO Zaposleni_Funkcija (Id_zaposlenog, Id_funkcije)
SELECT z.Id, f.Id
FROM (VALUES
    ('0202000710006', N'Direktor'),
    ('0303000710007', N'Instruktor'),
    ('0404000710008', N'Instruktor'),
    ('0505000715009', N'Administrator'),
    ('0606000710010', N'Predavac teorije'),
    ('0606000710010', N'Nadzornik polaganja')
) AS v(JMBG, Ime_funkcije)
JOIN Zaposleni z ON z.JMBG = v.JMBG
JOIN Funkcije_Zaposlenih f ON f.Ime_funkcije = v.Ime_funkcije
WHERE NOT EXISTS (
    SELECT 1
    FROM Zaposleni_Funkcija zf
    WHERE zf.Id_zaposlenog = z.Id
      AND zf.Id_funkcije = f.Id
);

INSERT INTO Zaposleni_Izostanak (Zaposleni_id, Tip, Datum_od, Datum_do)
SELECT z.Id, v.Tip, v.Datum_od, v.Datum_do
FROM (VALUES
    ('0404000710008', N'GODISNJI', '2026-07-01', '2026-07-10'),
    ('0505000715009', N'BOL', '2026-04-15', '2026-04-19')
) AS v(JMBG, Tip, Datum_od, Datum_do)
JOIN Zaposleni z ON z.JMBG = v.JMBG
WHERE NOT EXISTS (
    SELECT 1
    FROM Zaposleni_Izostanak zi
    WHERE zi.Zaposleni_id = z.Id
      AND zi.Tip = v.Tip
      AND zi.Datum_od = v.Datum_od
);

INSERT INTO Tip_obuke (Tip, Opis)
SELECT v.Tip, v.Opis
FROM (VALUES
    (N'Teorijska', N'Teorijska nastava i propisi'),
    (N'Prakticna', N'Prakticna obuka voznje'),
    (N'Prva Pomoc', N'Obuka iz prve pomoci')
) AS v(Tip, Opis)
WHERE NOT EXISTS (SELECT 1 FROM Tip_obuke t WHERE t.Tip = v.Tip);

INSERT INTO Kategorija_vozacke (Oznaka, Opis)
SELECT v.Oznaka, v.Opis
FROM (VALUES
    ('A', N'Motocikli'),
    ('B', N'Putnicka vozila'),
    ('C', N'Teretna vozila'),
    ('D', N'Autobusi')
) AS v(Oznaka, Opis)
WHERE NOT EXISTS (SELECT 1 FROM Kategorija_vozacke k WHERE k.Oznaka = v.Oznaka);

INSERT INTO Grupa (Datum_kreiranja, Datum_zavrsetka)
SELECT v.Datum_kreiranja, v.Datum_zavrsetka
FROM (VALUES
    ('2026-04-01', NULL),
    ('2026-05-01', NULL),
    ('2026-03-01', '2026-04-20')
) AS v(Datum_kreiranja, Datum_zavrsetka)
WHERE NOT EXISTS (SELECT 1 FROM Grupa g WHERE g.Datum_kreiranja = v.Datum_kreiranja);

INSERT INTO Obuka (
    Kategorija_id, Glavni_Instruktor_id, Kandidat_id, Tip_Obuke,
    Datum_pocetka, Datum_zavrsetka, Status
)
SELECT kv.Id, z.Id, k.Id, t.Id, v.Datum_pocetka, v.Datum_zavrsetka, v.Status
FROM (VALUES
    ('0101000710001', 'B', '0303000710007', N'Prakticna', '2026-04-05', NULL, N'Aktivan'),
    ('1502002715002', 'B', '0404000710008', N'Prakticna', '2026-04-10', NULL, N'Aktivan'),
    ('2303003710003', 'A', '0404000710008', N'Prakticna', '2026-03-15', '2026-05-20', N'Zavrsen'),
    ('1204004715004', 'B', '0303000710007', N'Teorijska', '2026-05-05', NULL, N'Aktivan'),
    ('0505005710005', 'C', '0202000710006', N'Prakticna', '2026-02-01', '2026-03-05', N'Prekinut')
) AS v(Kandidat_JMBG, Oznaka, Instruktor_JMBG, Tip, Datum_pocetka, Datum_zavrsetka, Status)
JOIN Kandidat k ON k.JMBG = v.Kandidat_JMBG
JOIN Kategorija_vozacke kv ON kv.Oznaka = v.Oznaka
JOIN Zaposleni z ON z.JMBG = v.Instruktor_JMBG
JOIN Tip_obuke t ON t.Tip = v.Tip
WHERE NOT EXISTS (
    SELECT 1
    FROM Obuka o
    WHERE o.Kandidat_id = k.Id
      AND o.Kategorija_id = kv.Id
      AND o.Datum_pocetka = v.Datum_pocetka
);

INSERT INTO Kandidat_grupa (Grupa_id, Obuka_id, Datum_od, Datum_do)
SELECT g.Id, o.Id, v.Datum_od, v.Datum_do
FROM (VALUES
    ('2026-04-01', '0101000710001', '2026-04-05', NULL),
    ('2026-04-01', '1502002715002', '2026-04-10', NULL),
    ('2026-03-01', '2303003710003', '2026-03-15', '2026-04-20'),
    ('2026-05-01', '1204004715004', '2026-05-05', NULL)
) AS v(Datum_kreiranja_grupe, Kandidat_JMBG, Datum_od, Datum_do)
JOIN Grupa g ON g.Datum_kreiranja = v.Datum_kreiranja_grupe
JOIN Kandidat k ON k.JMBG = v.Kandidat_JMBG
JOIN Obuka o ON o.Kandidat_id = k.Id AND o.Datum_pocetka = v.Datum_od
WHERE NOT EXISTS (
    SELECT 1
    FROM Kandidat_grupa kg
    WHERE kg.Grupa_id = g.Id
      AND kg.Obuka_id = o.Id
);

INSERT INTO Vozilo (
    Registracija, Marka, Model, Godiste, Kategorija_id,
    Kilometraza, Datum_registracije
)
SELECT v.Registracija, v.Marka, v.Model, v.Godiste, kv.Id,
       v.Kilometraza, v.Datum_registracije
FROM (VALUES
    ('BG-123-AA', N'Toyota', N'Yaris', 2020, 'B', 45200, '2026-01-15'),
    ('NS-456-BB', N'Volkswagen', N'Golf', 2019, 'B', 68800, '2026-02-20'),
    ('BG-789-CC', N'Yamaha', N'MT-07', 2021, 'A', 18300, '2026-03-01'),
    ('KG-321-DD', N'Mercedes', N'Actros', 2018, 'C', 142500, '2026-01-30')
) AS v(Registracija, Marka, Model, Godiste, Oznaka, Kilometraza, Datum_registracije)
JOIN Kategorija_vozacke kv ON kv.Oznaka = v.Oznaka
WHERE NOT EXISTS (SELECT 1 FROM Vozilo voz WHERE voz.Registracija = v.Registracija);

INSERT INTO Cas (
    Instruktor_id, Tip_id, Lokacija, Datum, Pocetak, Kraj,
    Status, Obuka_id, Vozilo_id, Grupa_id
)
SELECT z.Id, t.Id, v.Lokacija, v.Datum, v.Pocetak, v.Kraj, v.Status,
       o.Id, voz.Id, g.Id
FROM (VALUES
    ('0606000710010', N'Teorijska', N'Ucionica 1', '2026-05-06', '17:00:00', '18:30:00', N'Odrzan', NULL, NULL, '2026-05-01'),
    ('0303000710007', N'Prakticna', N'Poligon Novi Beograd', '2026-05-07', '09:00:00', '10:30:00', N'Odrzan', '0101000710001', 'BG-123-AA', NULL),
    ('0404000710008', N'Prakticna', N'Gradska voznja', '2026-05-08', '11:00:00', '12:30:00', N'Odrzan', '1502002715002', 'NS-456-BB', NULL),
    ('0404000710008', N'Prakticna', N'Poligon', '2026-05-09', '13:00:00', '14:30:00', N'Otkazan', '2303003710003', 'BG-789-CC', NULL),
    ('0606000710010', N'Prva Pomoc', N'Ucionica prve pomoci', '2026-05-10', '16:00:00', '18:00:00', N'Zakazan', NULL, NULL, '2026-04-01')
) AS v(Instruktor_JMBG, Tip, Lokacija, Datum, Pocetak, Kraj, Status, Kandidat_JMBG, Registracija, Datum_kreiranja_grupe)
JOIN Zaposleni z ON z.JMBG = v.Instruktor_JMBG
JOIN Tip_obuke t ON t.Tip = v.Tip
LEFT JOIN Kandidat k ON k.JMBG = v.Kandidat_JMBG
LEFT JOIN Obuka o ON o.Kandidat_id = k.Id
LEFT JOIN Vozilo voz ON voz.Registracija = v.Registracija
LEFT JOIN Grupa g ON g.Datum_kreiranja = v.Datum_kreiranja_grupe
WHERE NOT EXISTS (
    SELECT 1
    FROM Cas c
    WHERE c.Instruktor_id = z.Id
      AND c.Datum = v.Datum
      AND c.Pocetak = v.Pocetak
      AND c.Kraj = v.Kraj
);

INSERT INTO Polaganje (Tip_id, Pocetak, Kraj)
SELECT t.Id, v.Pocetak, v.Kraj
FROM (VALUES
    (N'Teorijska', '2026-05-20T09:00:00', '2026-05-20T10:00:00'),
    (N'Prakticna', '2026-05-25T08:00:00', '2026-05-25T12:00:00'),
    (N'Teorijska', '2026-06-01T10:00:00', '2026-06-01T11:00:00')
) AS v(Tip, Pocetak, Kraj)
JOIN Tip_obuke t ON t.Tip = v.Tip
WHERE NOT EXISTS (SELECT 1 FROM Polaganje p WHERE p.Pocetak = v.Pocetak AND p.Kraj = v.Kraj);

INSERT INTO Polaganje_kandidat (Polaganje_id, Obuka_id, Uspesno, Broj_Poenta)
SELECT p.Id, o.Id, v.Uspesno, v.Broj_Poenta
FROM (VALUES
    ('2026-05-20T09:00:00', '0101000710001', 1, 92),
    ('2026-05-20T09:00:00', '1502002715002', 0, 63),
    ('2026-05-25T08:00:00', '2303003710003', 1, 95),
    ('2026-06-01T10:00:00', '1204004715004', NULL, NULL)
) AS v(Pocetak_polaganja, Kandidat_JMBG, Uspesno, Broj_Poenta)
JOIN Polaganje p ON p.Pocetak = v.Pocetak_polaganja
JOIN Kandidat k ON k.JMBG = v.Kandidat_JMBG
JOIN Obuka o ON o.Kandidat_id = k.Id
WHERE NOT EXISTS (
    SELECT 1
    FROM Polaganje_kandidat pk
    WHERE pk.Polaganje_id = p.Id
      AND pk.Obuka_id = o.Id
);

INSERT INTO Nadzornici_polaganja (Polaganje_id, Nadzornik_id)
SELECT p.Id, z.Id
FROM (VALUES
    ('2026-05-20T09:00:00', '0606000710010'),
    ('2026-05-20T09:00:00', '0202000710006'),
    ('2026-05-25T08:00:00', '0606000710010'),
    ('2026-06-01T10:00:00', '0202000710006')
) AS v(Pocetak_polaganja, Nadzornik_JMBG)
JOIN Polaganje p ON p.Pocetak = v.Pocetak_polaganja
JOIN Zaposleni z ON z.JMBG = v.Nadzornik_JMBG
WHERE NOT EXISTS (
    SELECT 1
    FROM Nadzornici_polaganja np
    WHERE np.Polaganje_id = p.Id
      AND np.Nadzornik_id = z.Id
);

INSERT INTO Cenovnik (Naziv, Opis, Cena, Datum_od, Datum_do)
SELECT v.Naziv, v.Opis, v.Cena, v.Datum_od, v.Datum_do
FROM (VALUES
    (N'Kompletna obuka B kategorija', N'Teorija, prakticna nastava i prijava ispita', 85000.00, '2026-01-01', NULL),
    (N'Dodatni cas voznje', N'Jedan dodatni prakticni cas', 2500.00, '2026-01-01', NULL),
    (N'Obuka A kategorija', N'Kompletna obuka za motocikle', 70000.00, '2026-01-01', NULL),
    (N'Obuka C kategorija', N'Kompletna obuka za teretna vozila', 120000.00, '2026-01-01', NULL)
) AS v(Naziv, Opis, Cena, Datum_od, Datum_do)
WHERE NOT EXISTS (SELECT 1 FROM Cenovnik c WHERE c.Naziv = v.Naziv AND c.Datum_od = v.Datum_od);

INSERT INTO Uplata (Cenovnik_id, Obuka_id, Iznos, Datum, Nacin_placanja)
SELECT c.Id, o.Id, v.Iznos, v.Datum, v.Nacin_placanja
FROM (VALUES
    (N'Kompletna obuka B kategorija', '0101000710001', 30000.00, '2026-04-05', N'Gotovina'),
    (N'Kompletna obuka B kategorija', '0101000710001', 25000.00, '2026-05-05', N'Kartica'),
    (N'Kompletna obuka B kategorija', '1502002715002', 85000.00, '2026-04-10', N'Prenos'),
    (N'Obuka A kategorija', '2303003710003', 70000.00, '2026-03-15', N'Gotovina'),
    (N'Kompletna obuka B kategorija', '1204004715004', 20000.00, '2026-05-06', N'Kartica'),
    (N'Obuka C kategorija', '0505005710005', 40000.00, '2026-02-01', N'Prenos')
) AS v(Naziv_cenovnika, Kandidat_JMBG, Iznos, Datum, Nacin_placanja)
JOIN Cenovnik c ON c.Naziv = v.Naziv_cenovnika AND c.Datum_do IS NULL
JOIN Kandidat k ON k.JMBG = v.Kandidat_JMBG
JOIN Obuka o ON o.Kandidat_id = k.Id
WHERE NOT EXISTS (
    SELECT 1
    FROM Uplata u
    WHERE u.Cenovnik_id = c.Id
      AND u.Obuka_id = o.Id
      AND u.Iznos = v.Iznos
      AND u.Datum = v.Datum
      AND u.Nacin_placanja = v.Nacin_placanja
);

;WITH Brojevi AS (
    SELECT TOP (100)
        ROW_NUMBER() OVER (ORDER BY object_id) AS n
    FROM sys.all_objects
)
INSERT INTO Kandidat (
    Istek_lekarskog, Ime, Ime_roditelja, Prezime, JMBG,
    Istek_licne_karte, Telefon, Email, Datum_rodjenja
)
SELECT
    DATEADD(day, n % 365, CONVERT(date, '2027-01-01')),
    N'Kandidat' + CAST(n AS NVARCHAR(10)),
    N'Roditelj' + CAST(n AS NVARCHAR(10)),
    N'Test' + CAST(n AS NVARCHAR(10)),
    RIGHT('0000000000000' + CAST(1000000000000 + n AS VARCHAR(13)), 13),
    DATEADD(day, n % 900, CONVERT(date, '2030-01-01')),
    '060' + RIGHT('0000000' + CAST(7000000 + n AS VARCHAR(7)), 7),
    'kandidat' + CAST(n AS VARCHAR(10)) + '@autoskolatest.rs',
    DATEADD(day, n % 3650, CONVERT(date, '1995-01-01'))
FROM Brojevi b
WHERE NOT EXISTS (
    SELECT 1
    FROM Kandidat k
    WHERE k.JMBG = RIGHT('0000000000000' + CAST(1000000000000 + b.n AS VARCHAR(13)), 13)
);

;WITH Brojevi AS (
    SELECT TOP (30)
        ROW_NUMBER() OVER (ORDER BY object_id) AS n
    FROM sys.all_objects
)
INSERT INTO Zaposleni (
    Kvalifikacija, Aktivni_ugovor, Ime, Ime_roditelja, Prezime,
    JMBG, Istek_licne_karte, Telefon, Email, Datum_rodjenja
)
SELECT
    CASE
        WHEN n % 6 = 0 THEN N'Administrativni radnik'
        WHEN n % 5 = 0 THEN N'Ispitivac teorije'
        ELSE N'Instruktor B kategorije'
    END,
    CASE WHEN n % 10 = 0 THEN 0 ELSE 1 END,
    N'Zaposleni' + CAST(n AS NVARCHAR(10)),
    N'Roditelj' + CAST(n AS NVARCHAR(10)),
    N'Test' + CAST(n AS NVARCHAR(10)),
    RIGHT('0000000000000' + CAST(2000000000000 + n AS VARCHAR(13)), 13),
    DATEADD(day, n % 900, CONVERT(date, '2030-01-01')),
    '061' + RIGHT('0000000' + CAST(8000000 + n AS VARCHAR(7)), 7),
    'zaposleni' + CAST(n AS VARCHAR(10)) + '@autoskolatest.rs',
    DATEADD(day, n % 6000, CONVERT(date, '1980-01-01'))
FROM Brojevi b
WHERE NOT EXISTS (
    SELECT 1
    FROM Zaposleni z
    WHERE z.JMBG = RIGHT('0000000000000' + CAST(2000000000000 + b.n AS VARCHAR(13)), 13)
);

INSERT INTO Zaposleni_Funkcija (Id_zaposlenog, Id_funkcije)
SELECT z.Id, f.Id
FROM Zaposleni z
JOIN Funkcije_Zaposlenih f
    ON f.Ime_funkcije =
        CASE
            WHEN TRY_CONVERT(INT, RIGHT(z.JMBG, 2)) % 6 = 0 THEN N'Administrator'
            WHEN TRY_CONVERT(INT, RIGHT(z.JMBG, 2)) % 5 = 0 THEN N'Nadzornik polaganja'
            ELSE N'Instruktor'
        END
WHERE z.JMBG BETWEEN '2000000000001' AND '2000000000030'
  AND NOT EXISTS (
      SELECT 1
      FROM Zaposleni_Funkcija zf
      WHERE zf.Id_zaposlenog = z.Id
        AND zf.Id_funkcije = f.Id
  );

;WITH Brojevi AS (
    SELECT TOP (40)
        ROW_NUMBER() OVER (ORDER BY object_id) AS n
    FROM sys.all_objects
)
INSERT INTO Grupa (Datum_kreiranja, Datum_zavrsetka)
SELECT
    DATEADD(day, n * 7, CONVERT(date, '2026-06-01')),
    CASE WHEN n % 4 = 0 THEN DATEADD(day, n * 7 + 45, CONVERT(date, '2026-06-01')) ELSE NULL END
FROM Brojevi b
WHERE NOT EXISTS (
    SELECT 1
    FROM Grupa g
    WHERE g.Datum_kreiranja = DATEADD(day, b.n * 7, CONVERT(date, '2026-06-01'))
);

;WITH Brojevi AS (
    SELECT TOP (40)
        ROW_NUMBER() OVER (ORDER BY object_id) AS n
    FROM sys.all_objects
),
Kategorije AS (
    SELECT
        Id,
        Oznaka,
        ROW_NUMBER() OVER (ORDER BY Oznaka) AS rn,
        COUNT(*) OVER () AS ukupno
    FROM Kategorija_vozacke
)
INSERT INTO Vozilo (
    Registracija, Marka, Model, Godiste, Kategorija_id,
    Kilometraza, Datum_registracije
)
SELECT
    'TS-' + RIGHT('0000' + CAST(b.n AS VARCHAR(4)), 4),
    CASE b.n % 4
        WHEN 0 THEN N'Toyota'
        WHEN 1 THEN N'Skoda'
        WHEN 2 THEN N'Volkswagen'
        ELSE N'Fiat'
    END,
    CASE b.n % 4
        WHEN 0 THEN N'Corolla'
        WHEN 1 THEN N'Fabia'
        WHEN 2 THEN N'Polo'
        ELSE N'Tipo'
    END,
    2015 + (b.n % 10),
    k.Id,
    10000 + (b.n * 1250),
    DATEADD(day, b.n % 365, CONVERT(date, '2026-01-01'))
FROM Brojevi b
JOIN Kategorije k ON k.rn = ((b.n - 1) % k.ukupno) + 1
WHERE NOT EXISTS (
    SELECT 1
    FROM Vozilo v
    WHERE v.Registracija = 'TS-' + RIGHT('0000' + CAST(b.n AS VARCHAR(4)), 4)
);

;WITH Kandidati AS (
    SELECT
        Id,
        JMBG,
        ROW_NUMBER() OVER (ORDER BY JMBG) AS rn
    FROM Kandidat
    WHERE JMBG BETWEEN '1000000000001' AND '1000000000100'
),
RedniBrojevi AS (
    SELECT 1 AS rb
    UNION ALL
    SELECT 2
),
Kategorije AS (
    SELECT
        Id,
        Oznaka,
        ROW_NUMBER() OVER (ORDER BY Oznaka) AS rn,
        COUNT(*) OVER () AS ukupno
    FROM Kategorija_vozacke
),
Instruktori AS (
    SELECT
        z.Id,
        ROW_NUMBER() OVER (ORDER BY z.JMBG) AS rn,
        COUNT(*) OVER () AS ukupno
    FROM Zaposleni z
    JOIN Zaposleni_Funkcija zf ON zf.Id_zaposlenog = z.Id
    JOIN Funkcije_Zaposlenih f ON f.Id = zf.Id_funkcije
    WHERE f.Ime_funkcije = N'Instruktor'
),
Tipovi AS (
    SELECT Id, Tip
    FROM Tip_obuke
    WHERE Tip IN (N'Prakticna', N'Teorijska')
),
DodatneObuke AS (
    SELECT
        k.Id AS Kandidat_id,
        kv.Id AS Kategorija_id,
        i.Id AS Instruktor_id,
        t.Id AS Tip_Obuke,
        DATEADD(day, k.rn + (rb.rb * 3), CONVERT(date, '2026-06-01')) AS Datum_pocetka,
        CASE WHEN (k.rn + rb.rb) % 6 = 0 THEN DATEADD(day, k.rn + (rb.rb * 3) + 40, CONVERT(date, '2026-06-01')) ELSE NULL END AS Datum_zavrsetka,
        CASE
            WHEN (k.rn + rb.rb) % 6 = 0 THEN N'Zavrsen'
            WHEN (k.rn + rb.rb) % 11 = 0 THEN N'Prekinut'
            ELSE N'Aktivan'
        END AS Status
    FROM Kandidati k
    CROSS JOIN RedniBrojevi rb
    JOIN Kategorije kv ON kv.rn = ((k.rn + rb.rb - 1) % kv.ukupno) + 1
    JOIN Instruktori i ON i.rn = ((k.rn + rb.rb - 1) % i.ukupno) + 1
    JOIN Tipovi t ON t.Tip = CASE WHEN rb.rb = 1 THEN N'Prakticna' ELSE N'Teorijska' END
)
INSERT INTO Obuka (
    Kategorija_id, Glavni_Instruktor_id, Kandidat_id, Tip_Obuke,
    Datum_pocetka, Datum_zavrsetka, Status
)
SELECT
    Kategorija_id,
    Instruktor_id,
    Kandidat_id,
    Tip_Obuke,
    Datum_pocetka,
    Datum_zavrsetka,
    Status
FROM DodatneObuke do
WHERE NOT EXISTS (
    SELECT 1
    FROM Obuka o
    WHERE o.Kandidat_id = do.Kandidat_id
      AND o.Kategorija_id = do.Kategorija_id
      AND o.Datum_pocetka = do.Datum_pocetka
);

;WITH Grupe AS (
    SELECT
        Id,
        ROW_NUMBER() OVER (ORDER BY Datum_kreiranja) AS rn,
        COUNT(*) OVER () AS ukupno
    FROM Grupa
),
Obuke AS (
    SELECT
        Id,
        Datum_pocetka,
        ROW_NUMBER() OVER (ORDER BY Datum_pocetka, Id) AS rn
    FROM Obuka
    WHERE Datum_pocetka >= '2026-06-01'
)
INSERT INTO Kandidat_grupa (Grupa_id, Obuka_id, Datum_od, Datum_do)
SELECT
    g.Id,
    o.Id,
    o.Datum_pocetka,
    NULL
FROM Obuke o
JOIN Grupe g ON g.rn = ((o.rn - 1) % g.ukupno) + 1
WHERE NOT EXISTS (
    SELECT 1
    FROM Kandidat_grupa kg
    WHERE kg.Grupa_id = g.Id
      AND kg.Obuka_id = o.Id
);

;WITH Brojevi AS (
    SELECT TOP (80)
        ROW_NUMBER() OVER (ORDER BY object_id) AS n
    FROM sys.all_objects
),
Tipovi AS (
    SELECT Id, Tip
    FROM Tip_obuke
    WHERE Tip IN (N'Teorijska', N'Prakticna')
)
INSERT INTO Polaganje (Tip_id, Pocetak, Kraj)
SELECT
    t.Id,
    DATEADD(hour, 9 + (b.n % 5), CONVERT(datetime2, DATEADD(day, b.n * 5, CONVERT(date, '2026-07-01')))),
    DATEADD(hour, 10 + (b.n % 5), CONVERT(datetime2, DATEADD(day, b.n * 5, CONVERT(date, '2026-07-01'))))
FROM Brojevi b
JOIN Tipovi t ON t.Tip = CASE WHEN b.n % 2 = 0 THEN N'Teorijska' ELSE N'Prakticna' END
WHERE NOT EXISTS (
    SELECT 1
    FROM Polaganje p
    WHERE p.Pocetak = DATEADD(hour, 9 + (b.n % 5), CONVERT(datetime2, DATEADD(day, b.n * 5, CONVERT(date, '2026-07-01'))))
);

;WITH Polaganja AS (
    SELECT
        Id,
        ROW_NUMBER() OVER (ORDER BY Pocetak) AS rn,
        COUNT(*) OVER () AS ukupno
    FROM Polaganje
    WHERE Pocetak >= '2026-07-01'
),
Obuke AS (
    SELECT
        Id,
        ROW_NUMBER() OVER (ORDER BY Datum_pocetka, Id) AS rn
    FROM Obuka
    WHERE Datum_pocetka >= '2026-06-01'
)
INSERT INTO Polaganje_kandidat (Polaganje_id, Obuka_id, Uspesno, Broj_Poenta)
SELECT
    p.Id,
    o.Id,
    CASE
        WHEN o.rn % 9 = 0 THEN NULL
        WHEN o.rn % 4 = 0 THEN 0
        ELSE 1
    END,
    CASE
        WHEN o.rn % 9 = 0 THEN NULL
        WHEN o.rn % 4 = 0 THEN 55 + (o.rn % 10)
        ELSE 75 + (o.rn % 25)
    END
FROM Obuke o
JOIN Polaganja p ON p.rn = ((o.rn - 1) % p.ukupno) + 1
WHERE NOT EXISTS (
    SELECT 1
    FROM Polaganje_kandidat pk
    WHERE pk.Polaganje_id = p.Id
      AND pk.Obuka_id = o.Id
);

;WITH Polaganja AS (
    SELECT
        Id,
        ROW_NUMBER() OVER (ORDER BY Pocetak) AS rn
    FROM Polaganje
    WHERE Pocetak >= '2026-07-01'
),
Nadzornici AS (
    SELECT
        z.Id,
        ROW_NUMBER() OVER (ORDER BY z.JMBG) AS rn,
        COUNT(*) OVER () AS ukupno
    FROM Zaposleni z
    JOIN Zaposleni_Funkcija zf ON zf.Id_zaposlenog = z.Id
    JOIN Funkcije_Zaposlenih f ON f.Id = zf.Id_funkcije
    WHERE f.Ime_funkcije IN (N'Nadzornik polaganja', N'Predavac teorije', N'Direktor')
)
INSERT INTO Nadzornici_polaganja (Polaganje_id, Nadzornik_id)
SELECT
    p.Id,
    n.Id
FROM Polaganja p
JOIN Nadzornici n ON n.rn = ((p.rn - 1) % n.ukupno) + 1
WHERE NOT EXISTS (
    SELECT 1
    FROM Nadzornici_polaganja np
    WHERE np.Polaganje_id = p.Id
      AND np.Nadzornik_id = n.Id
);

;WITH Brojevi AS (
    SELECT TOP (600)
        ROW_NUMBER() OVER (ORDER BY object_id) AS n
    FROM sys.all_objects
),
DodatniCasovi AS (
    SELECT
        o.Id AS Obuka_id,
        o.Glavni_Instruktor_id AS Instruktor_id,
        t.Id AS Tip_id,
        voz.Id AS Vozilo_id,
        b.n,
        DATEADD(day, b.n, CONVERT(date, '2026-06-01')) AS Datum,
        CONVERT(time, DATEADD(hour, 8 + (b.n % 8), CONVERT(time, '00:00:00'))) AS Pocetak
    FROM Obuka o
    CROSS JOIN Brojevi b
    JOIN Tip_obuke t ON t.Tip = N'Prakticna'
    CROSS APPLY (
        SELECT TOP (1) v.Id
        FROM Vozilo v
        WHERE v.Kategorija_id = o.Kategorija_id
        ORDER BY v.Registracija
    ) voz
    WHERE o.Glavni_Instruktor_id IS NOT NULL
)
INSERT INTO Cas (
    Instruktor_id, Tip_id, Lokacija, Datum, Pocetak, Kraj,
    Status, Obuka_id, Vozilo_id, Grupa_id
)
SELECT
    dc.Instruktor_id,
    dc.Tip_id,
    N'Dodatni prakticni cas',
    dc.Datum,
    dc.Pocetak,
    DATEADD(minute, 45, dc.Pocetak),
    CASE WHEN dc.n % 10 = 0 THEN N'Otkazan' ELSE N'Odrzan' END,
    dc.Obuka_id,
    dc.Vozilo_id,
    NULL
FROM DodatniCasovi dc
WHERE NOT EXISTS (
    SELECT 1
    FROM Cas c
    WHERE c.Obuka_id = dc.Obuka_id
      AND c.Datum = dc.Datum
      AND c.Pocetak = dc.Pocetak
      AND c.Kraj = DATEADD(minute, 45, dc.Pocetak)
);

;WITH Brojevi AS (
    SELECT TOP (200)
        ROW_NUMBER() OVER (ORDER BY object_id) AS n
    FROM sys.all_objects
),
DodatneUplate AS (
    SELECT
        o.Id AS Obuka_id,
        c.Id AS Cenovnik_id,
        b.n,
        DATEADD(day, b.n * 3, CONVERT(date, '2026-06-01')) AS Datum,
        CAST(2500.00 AS DECIMAL(10, 2)) AS Iznos
    FROM Obuka o
    CROSS JOIN Brojevi b
    JOIN Cenovnik c ON c.Naziv = N'Dodatni cas voznje' AND c.Datum_do IS NULL
)
INSERT INTO Uplata (Cenovnik_id, Obuka_id, Iznos, Datum, Nacin_placanja)
SELECT
    du.Cenovnik_id,
    du.Obuka_id,
    du.Iznos,
    du.Datum,
    CASE du.n % 3
        WHEN 0 THEN N'Gotovina'
        WHEN 1 THEN N'Kartica'
        ELSE N'Prenos'
    END
FROM DodatneUplate du
WHERE NOT EXISTS (
    SELECT 1
    FROM Uplata u
    WHERE u.Cenovnik_id = du.Cenovnik_id
      AND u.Obuka_id = du.Obuka_id
      AND u.Iznos = du.Iznos
      AND u.Datum = du.Datum
);
