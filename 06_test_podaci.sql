-- Test podaci za bazu Auto skola.
-- Pokrenuti nakon kreiranja svih tabela.

INSERT INTO [Kandidat] (
    [Id], [Istek_lekarskog], [Ime], [Ime_roditelja], [Prezime], [JMBG],
    [Istek_licne_karte], [Telefon], [Email], [Datum_rodjenja]
)
SELECT *
FROM (VALUES
    ('11111111-1111-1111-1111-111111111111', '2026-12-15', N'Marko', N'Petar', N'Markovic', '0101000710001', '2030-05-20', '0601234567', 'marko.markovic@example.com', '2000-01-01'),
    ('11111111-1111-1111-1111-111111111112', '2027-02-10', N'Jelena', N'Milan', N'Jovanovic', '1502002715002', '2031-04-11', '0602345678', 'jelena.jovanovic@example.com', '2002-02-15'),
    ('11111111-1111-1111-1111-111111111113', '2026-09-01', N'Nikola', N'Dragan', N'Petrovic', '2303003710003', '2029-12-01', '0603456789', 'nikola.petrovic@example.com', '2003-03-23'),
    ('11111111-1111-1111-1111-111111111114', '2026-11-30', N'Ana', N'Goran', N'Ilic', '1204004715004', '2032-07-19', '0604567890', 'ana.ilic@example.com', '2004-04-12'),
    ('11111111-1111-1111-1111-111111111115', '2027-01-20', N'Luka', N'Zoran', N'Nikolic', '0505005710005', '2030-10-25', '0605678901', 'luka.nikolic@example.com', '2005-05-05')
) AS v([Id], [Istek_lekarskog], [Ime], [Ime_roditelja], [Prezime], [JMBG], [Istek_licne_karte], [Telefon], [Email], [Datum_rodjenja])
WHERE NOT EXISTS (SELECT 1 FROM [Kandidat] k WHERE k.[Id] = v.[Id]);
GO

INSERT INTO [Zaposleni] (
    [Id], [Kvalifikacija], [Aktivni_ugovor], [Ime], [Ime_roditelja], [Prezime],
    [JMBG], [Istek_licne_karte], [Telefon], [Email], [Datum_rodjenja]
)
SELECT *
FROM (VALUES
    ('22222222-2222-2222-2222-222222222221', N'Diplomirani inzenjer saobracaja', 1, N'Milos', N'Radovan', N'Savic', '0202000710006', '2030-03-10', '0611111111', 'milos.savic@autoskolatest.rs', '1985-02-02'),
    ('22222222-2222-2222-2222-222222222222', N'Instruktor B kategorije', 1, N'Dejan', N'Branko', N'Kostic', '0303000710007', '2029-08-17', '0612222222', 'dejan.kostic@autoskolatest.rs', '1988-03-03'),
    ('22222222-2222-2222-2222-222222222223', N'Instruktor A i B kategorije', 1, N'Ivan', N'Zeljko', N'Pavlovic', '0404000710008', '2031-11-05', '0613333333', 'ivan.pavlovic@autoskolatest.rs', '1990-04-04'),
    ('22222222-2222-2222-2222-222222222224', N'Administrativni radnik', 1, N'Marija', N'Dusan', N'Ristic', '0505000715009', '2032-01-22', '0614444444', 'marija.ristic@autoskolatest.rs', '1992-05-05'),
    ('22222222-2222-2222-2222-222222222225', N'Ispitivac teorije', 1, N'Stefan', N'Mirko', N'Lazic', '0606000710010', '2028-06-14', '0615555555', 'stefan.lazic@autoskolatest.rs', '1982-06-06')
) AS v([Id], [Kvalifikacija], [Aktivni_ugovor], [Ime], [Ime_roditelja], [Prezime], [JMBG], [Istek_licne_karte], [Telefon], [Email], [Datum_rodjenja])
WHERE NOT EXISTS (SELECT 1 FROM [Zaposleni] z WHERE z.[Id] = v.[Id]);
GO

INSERT INTO [Funkcije_Zaposlenih] ([Id], [Ime_funkcije], [Minimalna_kvalifikacija], [Opis])
SELECT *
FROM (VALUES
    ('33333333-3333-3333-3333-333333333331', N'Direktor', N'VII stepen', N'Organizacija rada auto skole'),
    ('33333333-3333-3333-3333-333333333332', N'Instruktor', N'Instruktor voznje', N'Izvodi prakticne casove'),
    ('33333333-3333-3333-3333-333333333333', N'Predavac teorije', N'Licenca za teorijsku nastavu', N'Izvodi teorijsku nastavu'),
    ('33333333-3333-3333-3333-333333333334', N'Administrator', N'SSS', N'Vodi evidenciju kandidata i uplata'),
    ('33333333-3333-3333-3333-333333333335', N'Nadzornik polaganja', N'Licenca ispitivaca', N'Nadzire polaganja kandidata')
) AS v([Id], [Ime_funkcije], [Minimalna_kvalifikacija], [Opis])
WHERE NOT EXISTS (SELECT 1 FROM [Funkcije_Zaposlenih] f WHERE f.[Id] = v.[Id]);
GO

INSERT INTO [Zaposleni_Funkcija] ([Id_zaposlenog], [Id_funkcije])
SELECT *
FROM (VALUES
    ('22222222-2222-2222-2222-222222222221', '33333333-3333-3333-3333-333333333331'),
    ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333332'),
    ('22222222-2222-2222-2222-222222222223', '33333333-3333-3333-3333-333333333332'),
    ('22222222-2222-2222-2222-222222222224', '33333333-3333-3333-3333-333333333334'),
    ('22222222-2222-2222-2222-222222222225', '33333333-3333-3333-3333-333333333333'),
    ('22222222-2222-2222-2222-222222222225', '33333333-3333-3333-3333-333333333335')
) AS v([Id_zaposlenog], [Id_funkcije])
WHERE NOT EXISTS (
    SELECT 1
    FROM [Zaposleni_Funkcija] zf
    WHERE zf.[Id_zaposlenog] = v.[Id_zaposlenog]
      AND zf.[Id_funkcije] = v.[Id_funkcije]
);
GO

INSERT INTO [Zaposleni_Izostanak] ([Id], [Zaposleni_id], [Tip], [Datum_od], [Datum_do])
SELECT *
FROM (VALUES
    ('44444444-4444-4444-4444-444444444441', '22222222-2222-2222-2222-222222222223', N'GODISNJI', '2026-07-01', '2026-07-10'),
    ('44444444-4444-4444-4444-444444444442', '22222222-2222-2222-2222-222222222224', N'BOL', '2026-04-15', '2026-04-19')
) AS v([Id], [Zaposleni_id], [Tip], [Datum_od], [Datum_do])
WHERE NOT EXISTS (SELECT 1 FROM [Zaposleni_Izostanak] zi WHERE zi.[Id] = v.[Id]);
GO

INSERT INTO [Tip_obuke] ([Id], [Tip], [Opis])
SELECT *
FROM (VALUES
    ('55555555-5555-5555-5555-555555555551', N'Teorijska', N'Teorijska nastava i propisi'),
    ('55555555-5555-5555-5555-555555555552', N'Prakticna', N'Prakticna obuka voznje'),
    ('55555555-5555-5555-5555-555555555553', N'Prva Pomoc', N'Obuka iz prve pomoci')
) AS v([Id], [Tip], [Opis])
WHERE NOT EXISTS (SELECT 1 FROM [Tip_obuke] t WHERE t.[Id] = v.[Id]);
GO

INSERT INTO [Kategorija_vozacke] ([Id], [Oznaka], [Opis])
SELECT *
FROM (VALUES
    ('66666666-6666-6666-6666-666666666661', 'A', N'Motocikli'),
    ('66666666-6666-6666-6666-666666666662', 'B', N'Putnicka vozila'),
    ('66666666-6666-6666-6666-666666666663', 'C', N'Teretna vozila'),
    ('66666666-6666-6666-6666-666666666664', 'D', N'Autobusi')
) AS v([Id], [Oznaka], [Opis])
WHERE NOT EXISTS (SELECT 1 FROM [Kategorija_vozacke] k WHERE k.[Id] = v.[Id]);
GO

INSERT INTO [Grupa] ([Id], [Datum_kreiranja], [Datum_zavrsetka])
SELECT *
FROM (VALUES
    ('77777777-7777-7777-7777-777777777771', '2026-04-01', NULL),
    ('77777777-7777-7777-7777-777777777772', '2026-05-01', NULL),
    ('77777777-7777-7777-7777-777777777773', '2026-03-01', '2026-04-20')
) AS v([Id], [Datum_kreiranja], [Datum_zavrsetka])
WHERE NOT EXISTS (SELECT 1 FROM [Grupa] g WHERE g.[Id] = v.[Id]);
GO

INSERT INTO [Obuka] (
    [Id], [Kategorija_id], [Glavni_Instruktor_id], [Kandidat_id], [Tip_Obuke],
    [Datum_pocetka], [Datum_zavrsetka], [Status]
)
SELECT *
FROM (VALUES
    ('88888888-8888-8888-8888-888888888881', '66666666-6666-6666-6666-666666666662', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', '55555555-5555-5555-5555-555555555552', '2026-04-05', NULL, N'Aktivan'),
    ('88888888-8888-8888-8888-888888888882', '66666666-6666-6666-6666-666666666662', '22222222-2222-2222-2222-222222222223', '11111111-1111-1111-1111-111111111112', '55555555-5555-5555-5555-555555555552', '2026-04-10', NULL, N'Aktivan'),
    ('88888888-8888-8888-8888-888888888883', '66666666-6666-6666-6666-666666666661', '22222222-2222-2222-2222-222222222223', '11111111-1111-1111-1111-111111111113', '55555555-5555-5555-5555-555555555552', '2026-03-15', '2026-05-20', N'Zavrsen'),
    ('88888888-8888-8888-8888-888888888884', '66666666-6666-6666-6666-666666666662', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111114', '55555555-5555-5555-5555-555555555551', '2026-05-05', NULL, N'Aktivan'),
    ('88888888-8888-8888-8888-888888888885', '66666666-6666-6666-6666-666666666663', '22222222-2222-2222-2222-222222222221', '11111111-1111-1111-1111-111111111115', '55555555-5555-5555-5555-555555555552', '2026-02-01', '2026-03-05', N'Prekinut')
) AS v([Id], [Kategorija_id], [Glavni_Instruktor_id], [Kandidat_id], [Tip_Obuke], [Datum_pocetka], [Datum_zavrsetka], [Status])
WHERE NOT EXISTS (SELECT 1 FROM [Obuka] o WHERE o.[Id] = v.[Id]);
GO

INSERT INTO [Kandidat_grupa] ([Id], [Grupa_id], [Obuka_id], [Datum_od], [Datum_do])
SELECT *
FROM (VALUES
    ('99999999-9999-9999-9999-999999999991', '77777777-7777-7777-7777-777777777771', '88888888-8888-8888-8888-888888888881', '2026-04-05', NULL),
    ('99999999-9999-9999-9999-999999999992', '77777777-7777-7777-7777-777777777771', '88888888-8888-8888-8888-888888888882', '2026-04-10', NULL),
    ('99999999-9999-9999-9999-999999999993', '77777777-7777-7777-7777-777777777773', '88888888-8888-8888-8888-888888888883', '2026-03-15', '2026-04-20'),
    ('99999999-9999-9999-9999-999999999994', '77777777-7777-7777-7777-777777777772', '88888888-8888-8888-8888-888888888884', '2026-05-05', NULL)
) AS v([Id], [Grupa_id], [Obuka_id], [Datum_od], [Datum_do])
WHERE NOT EXISTS (SELECT 1 FROM [Kandidat_grupa] kg WHERE kg.[Id] = v.[Id]);
GO

INSERT INTO [Vozilo] (
    [Id], [Registracija], [Marka], [Model], [Godiste], [Kategorija_id],
    [Kilometraza], [Datum_registracije]
)
SELECT *
FROM (VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', 'BG-123-AA', N'Toyota', N'Yaris', 2020, '66666666-6666-6666-6666-666666666662', 45200, '2026-01-15'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', 'NS-456-BB', N'Volkswagen', N'Golf', 2019, '66666666-6666-6666-6666-666666666662', 68800, '2026-02-20'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3', 'BG-789-CC', N'Yamaha', N'MT-07', 2021, '66666666-6666-6666-6666-666666666661', 18300, '2026-03-01'),
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa4', 'KG-321-DD', N'Mercedes', N'Actros', 2018, '66666666-6666-6666-6666-666666666663', 142500, '2026-01-30')
) AS v([Id], [Registracija], [Marka], [Model], [Godiste], [Kategorija_id], [Kilometraza], [Datum_registracije])
WHERE NOT EXISTS (SELECT 1 FROM [Vozilo] voz WHERE voz.[Id] = v.[Id]);
GO

INSERT INTO [Cas] (
    [Id], [Instruktor_id], [Tip_id], [Lokacija], [Datum], [Pocetak], [Kraj],
    [Status], [Obuka_id], [Vozilo_id], [Grupa_id]
)
SELECT *
FROM (VALUES
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1', '22222222-2222-2222-2222-222222222225', '55555555-5555-5555-5555-555555555551', N'Ucionica 1', '2026-05-06', '2026-05-06T17:00:00', '2026-05-06T18:30:00', N'Odrzan', NULL, NULL, '77777777-7777-7777-7777-777777777772'),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2', '22222222-2222-2222-2222-222222222222', '55555555-5555-5555-5555-555555555552', N'Poligon Novi Beograd', '2026-05-07', '2026-05-07T09:00:00', '2026-05-07T10:30:00', N'Odrzan', '88888888-8888-8888-8888-888888888881', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1', NULL),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3', '22222222-2222-2222-2222-222222222223', '55555555-5555-5555-5555-555555555552', N'Gradska voznja', '2026-05-08', '2026-05-08T11:00:00', '2026-05-08T12:30:00', N'Odrzan', '88888888-8888-8888-8888-888888888882', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2', NULL),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4', '22222222-2222-2222-2222-222222222223', '55555555-5555-5555-5555-555555555552', N'Poligon', '2026-05-09', '2026-05-09T13:00:00', '2026-05-09T14:30:00', N'Otkazan', '88888888-8888-8888-8888-888888888883', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3', NULL),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb5', '22222222-2222-2222-2222-222222222225', '55555555-5555-5555-5555-555555555553', N'Ucionica prve pomoci', '2026-05-10', '2026-05-10T16:00:00', '2026-05-10T18:00:00', N'Zakazan', NULL, NULL, '77777777-7777-7777-7777-777777777771')
) AS v([Id], [Instruktor_id], [Tip_id], [Lokacija], [Datum], [Pocetak], [Kraj], [Status], [Obuka_id], [Vozilo_id], [Grupa_id])
WHERE NOT EXISTS (SELECT 1 FROM [Cas] c WHERE c.[Id] = v.[Id]);
GO

INSERT INTO [Polaganje] ([Id], [Tip_id], [Pocetak], [Kraj])
SELECT *
FROM (VALUES
    ('cccccccc-cccc-cccc-cccc-ccccccccccc1', '55555555-5555-5555-5555-555555555551', '2026-05-20T09:00:00', '2026-05-20T10:00:00'),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc2', '55555555-5555-5555-5555-555555555552', '2026-05-25T08:00:00', '2026-05-25T12:00:00'),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc3', '55555555-5555-5555-5555-555555555551', '2026-06-01T10:00:00', '2026-06-01T11:00:00')
) AS v([Id], [Tip_id], [Pocetak], [Kraj])
WHERE NOT EXISTS (SELECT 1 FROM [Polaganje] p WHERE p.[Id] = v.[Id]);
GO

INSERT INTO [Polaganje_kandidat] ([Polaganje_id], [Obuka_id], [Uspesno], [Broj_Poenta])
SELECT *
FROM (VALUES
    ('cccccccc-cccc-cccc-cccc-ccccccccccc1', '88888888-8888-8888-8888-888888888881', 1, 92),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc1', '88888888-8888-8888-8888-888888888882', 0, 63),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc2', '88888888-8888-8888-8888-888888888883', 1, 95),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc3', '88888888-8888-8888-8888-888888888884', NULL, NULL)
) AS v([Polaganje_id], [Obuka_id], [Uspesno], [Broj_Poenta])
WHERE NOT EXISTS (
    SELECT 1
    FROM [Polaganje_kandidat] pk
    WHERE pk.[Polaganje_id] = v.[Polaganje_id]
      AND pk.[Obuka_id] = v.[Obuka_id]
);
GO

INSERT INTO [Nadzornici_polaganja] ([Polaganje_id], [Nadzornik_id])
SELECT *
FROM (VALUES
    ('cccccccc-cccc-cccc-cccc-ccccccccccc1', '22222222-2222-2222-2222-222222222225'),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc1', '22222222-2222-2222-2222-222222222221'),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc2', '22222222-2222-2222-2222-222222222225'),
    ('cccccccc-cccc-cccc-cccc-ccccccccccc3', '22222222-2222-2222-2222-222222222221')
) AS v([Polaganje_id], [Nadzornik_id])
WHERE NOT EXISTS (
    SELECT 1
    FROM [Nadzornici_polaganja] np
    WHERE np.[Polaganje_id] = v.[Polaganje_id]
      AND np.[Nadzornik_id] = v.[Nadzornik_id]
);
GO

INSERT INTO [Cenovnik] ([Id], [Naziv], [Opis], [Cena], [Datum_od], [Datum_do])
SELECT *
FROM (VALUES
    ('dddddddd-dddd-dddd-dddd-ddddddddddd1', N'Kompletna obuka B kategorija', N'Teorija, prakticna nastava i prijava ispita', 85000.00, '2026-01-01', NULL),
    ('dddddddd-dddd-dddd-dddd-ddddddddddd2', N'Dodatni cas voznje', N'Jedan dodatni prakticni cas', 2500.00, '2026-01-01', NULL),
    ('dddddddd-dddd-dddd-dddd-ddddddddddd3', N'Obuka A kategorija', N'Kompletna obuka za motocikle', 70000.00, '2026-01-01', NULL),
    ('dddddddd-dddd-dddd-dddd-ddddddddddd4', N'Obuka C kategorija', N'Kompletna obuka za teretna vozila', 120000.00, '2026-01-01', NULL)
) AS v([Id], [Naziv], [Opis], [Cena], [Datum_od], [Datum_do])
WHERE NOT EXISTS (SELECT 1 FROM [Cenovnik] c WHERE c.[Id] = v.[Id]);
GO

INSERT INTO [Uplata] ([Id], [Cenovnik_id], [Obuka_id], [Iznos], [Datum], [Nacin_placanja])
SELECT *
FROM (VALUES
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee1', 'dddddddd-dddd-dddd-dddd-ddddddddddd1', '88888888-8888-8888-8888-888888888881', 30000.00, '2026-04-05', N'Gotovina'),
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee2', 'dddddddd-dddd-dddd-dddd-ddddddddddd1', '88888888-8888-8888-8888-888888888881', 25000.00, '2026-05-05', N'Kartica'),
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee3', 'dddddddd-dddd-dddd-dddd-ddddddddddd1', '88888888-8888-8888-8888-888888888882', 85000.00, '2026-04-10', N'Prenos'),
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee4', 'dddddddd-dddd-dddd-dddd-ddddddddddd3', '88888888-8888-8888-8888-888888888883', 70000.00, '2026-03-15', N'Gotovina'),
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee5', 'dddddddd-dddd-dddd-dddd-ddddddddddd1', '88888888-8888-8888-8888-888888888884', 20000.00, '2026-05-06', N'Kartica'),
    ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee6', 'dddddddd-dddd-dddd-dddd-ddddddddddd4', '88888888-8888-8888-8888-888888888885', 40000.00, '2026-02-01', N'Prenos')
) AS v([Id], [Cenovnik_id], [Obuka_id], [Iznos], [Datum], [Nacin_placanja])
WHERE NOT EXISTS (SELECT 1 FROM [Uplata] u WHERE u.[Id] = v.[Id]);
GO
