GO

-- Pogledi.

SELECT TOP (20) *
FROM dbo.vw_Kandidati_Obuke
ORDER BY Datum_pocetka DESC;

SELECT TOP (20) *
FROM dbo.vw_Raspored_Casova
WHERE Datum BETWEEN '2026-06-01' AND '2026-06-15'
ORDER BY Datum, Pocetak;

SELECT TOP (20) *
FROM dbo.vw_Uplate_Po_Obuci
ORDER BY Ukupno_uplaceno DESC;

SELECT TOP (20) *
FROM dbo.vw_Rezultati_Polaganja
ORDER BY Pocetak DESC;

SELECT TOP (20) *
FROM dbo.vw_Zaposleni_Funkcije
ORDER BY Prezime, Ime;

SELECT TOP (20) *
FROM dbo.vw_Stanje_Obuke
ORDER BY Datum_pocetka DESC;

GO

-- Funkcije.

DECLARE @PrimerObukaId UNIQUEIDENTIFIER;
DECLARE @PrimerInstruktorId UNIQUEIDENTIFIER;

SELECT TOP (1) @PrimerObukaId = Id
FROM Obuka
ORDER BY Datum_pocetka DESC;

SELECT TOP (1) @PrimerInstruktorId = Instruktor_id
FROM Cas
WHERE Instruktor_id IS NOT NULL
GROUP BY Instruktor_id
ORDER BY COUNT(*) DESC;

SELECT
    @PrimerObukaId AS Obuka_id,
    dbo.fn_UkupnoUplacenoZaObuku(@PrimerObukaId) AS Ukupno_uplaceno,
    dbo.fn_BrojCasovaZaObuku(@PrimerObukaId, 0) AS Broj_svih_casova,
    dbo.fn_BrojCasovaZaObuku(@PrimerObukaId, 1) AS Broj_odrzanih_casova,
    dbo.fn_BrojPolaganjaZaObuku(@PrimerObukaId) AS Broj_polaganja;

SELECT *
FROM dbo.fn_RasporedInstruktora(
    @PrimerInstruktorId,
    '2026-06-01',
    '2026-06-30'
)
ORDER BY Datum, Pocetak;

GO

-- Procedura.


BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @KandidatId UNIQUEIDENTIFIER;
    DECLARE @KategorijaId UNIQUEIDENTIFIER;
    DECLARE @InstruktorId UNIQUEIDENTIFIER;
    DECLARE @TipObukeId UNIQUEIDENTIFIER;
    DECLARE @GrupaId UNIQUEIDENTIFIER;
    DECLARE @NovaObukaId UNIQUEIDENTIFIER;
    DECLARE @VoziloId UNIQUEIDENTIFIER;
    DECLARE @NoviCasId UNIQUEIDENTIFIER;
    DECLARE @CenovnikId UNIQUEIDENTIFIER;
    DECLARE @NovaUplataId UNIQUEIDENTIFIER;
    DECLARE @PolaganjeId UNIQUEIDENTIFIER;

    SET @KandidatId = newid();

    INSERT INTO Kandidat (
        Id, Istek_lekarskog, Ime, Ime_roditelja, Prezime, JMBG,
        Istek_licne_karte, Telefon, Email, Datum_rodjenja
    )
    VALUES (
        @KandidatId, '2030-01-01', N'Demo', N'Demo', N'Kandidat',
        '9999999999999', '2032-01-01', '0609999999',
        'demo.kandidat@autoskolatest.rs', '2000-01-01'
    );

    SELECT TOP (1) @KategorijaId = kv.Id
    FROM Kategorija_vozacke kv
    WHERE EXISTS (
        SELECT 1
        FROM Vozilo v
        WHERE v.Kategorija_id = kv.Id
    )
    ORDER BY
        CASE WHEN kv.Oznaka = 'D' THEN 0 ELSE 1 END,
        kv.Oznaka;

    IF @KategorijaId IS NULL
        THROW 51301, 'Demo ne moze da se pokrene: ne postoji kategorija sa vozilom.', 1;

    SELECT TOP (1) @InstruktorId = z.Id
    FROM Zaposleni z
    JOIN Zaposleni_Funkcija zf ON zf.Id_zaposlenog = z.Id
    JOIN Funkcije_Zaposlenih f ON f.Id = zf.Id_funkcije
    WHERE f.Ime_funkcije = N'Instruktor'
    ORDER BY z.JMBG;

    IF @InstruktorId IS NULL
        THROW 51302, 'Demo ne moze da se pokrene: ne postoji instruktor.', 1;

    SELECT TOP (1) @TipObukeId = Id
    FROM Tip_obuke
    WHERE Tip = N'Prakticna';

    IF @TipObukeId IS NULL
        THROW 51303, 'Demo ne moze da se pokrene: ne postoji tip obuke Prakticna.', 1;

    SELECT TOP (1) @GrupaId = Id
    FROM Grupa
    ORDER BY Datum_kreiranja DESC;

    IF @GrupaId IS NULL
        THROW 51304, 'Demo ne moze da se pokrene: ne postoji grupa.', 1;

    EXEC dbo.usp_UpisKandidataNaObuku
        @Kandidat_id = @KandidatId,
        @Kategorija_id = @KategorijaId,
        @Glavni_Instruktor_id = @InstruktorId,
        @Tip_Obuke = @TipObukeId,
        @Datum_pocetka = '2029-01-10',
        @Grupa_id = @GrupaId,
        @Nova_Obuka_id = @NovaObukaId OUTPUT;

    SELECT TOP (1) @VoziloId = Id
    FROM Vozilo
    WHERE Kategorija_id = @KategorijaId
    ORDER BY Registracija;

    IF @VoziloId IS NULL
        THROW 51305, 'Demo ne moze da se pokrene: ne postoji vozilo za izabranu kategoriju.', 1;

    EXEC dbo.usp_ZakaziPrakticniCas
        @Obuka_id = @NovaObukaId,
        @Instruktor_id = @InstruktorId,
        @Vozilo_id = @VoziloId,
        @Datum = '2029-01-11',
        @Pocetak = '09:00:00',
        @Kraj = '09:45:00',
        @Lokacija = N'Demo lokacija',
        @Novi_Cas_id = @NoviCasId OUTPUT;

    SELECT TOP (1) @CenovnikId = Id
    FROM Cenovnik
    WHERE Datum_do IS NULL
    ORDER BY Cena;

    IF @CenovnikId IS NULL
        THROW 51306, 'Demo ne moze da se pokrene: ne postoji aktivna stavka cenovnika.', 1;

    EXEC dbo.usp_EvidentirajUplatu
        @Obuka_id = @NovaObukaId,
        @Cenovnik_id = @CenovnikId,
        @Iznos = 2500.00,
        @Datum = '2029-01-10',
        @Nacin_placanja = N'Kartica',
        @Nova_Uplata_id = @NovaUplataId OUTPUT;

    SELECT TOP (1) @PolaganjeId = Id
    FROM Polaganje
    WHERE Tip_id = @TipObukeId
    ORDER BY Pocetak DESC;

    IF @PolaganjeId IS NULL
        THROW 51307, 'Demo ne moze da se pokrene: ne postoji prakticno polaganje.', 1;

    EXEC dbo.usp_PrijaviKandidataNaPolaganje
        @Polaganje_id = @PolaganjeId,
        @Obuka_id = @NovaObukaId;

    EXEC dbo.usp_EvidentirajRezultatPolaganja
        @Polaganje_id = @PolaganjeId,
        @Obuka_id = @NovaObukaId,
        @Uspesno = 1,
        @Broj_Poenta = 88;

    SELECT
        @NovaObukaId AS Demo_obuka_id,
        @NoviCasId AS Demo_cas_id,
        @NovaUplataId AS Demo_uplata_id;

    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
