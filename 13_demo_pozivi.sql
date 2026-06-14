-- Demo pozivi za poglede, funkcije i procedure.
--
-- Razlog za ovaj fajl:
-- Ovaj fajl ne definise nove objekte, nego pokazuje kako se napravljeni
-- objekti koriste. Koristan je za proveru rada i za demonstraciju projekta.

GO

-- Primeri koriscenja pogleda.

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

-- Primeri koriscenja funkcija.

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

-- Primeri koriscenja procedura.
-- Svi primeri ispod su u jednoj spoljnoj transakciji koja se na kraju
-- ponistava, da demo ne bi trajno menjao test podatke.

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

    SELECT TOP (1) @KategorijaId = Id
    FROM Kategorija_vozacke
    WHERE Oznaka = 'D';

    SELECT TOP (1) @InstruktorId = z.Id
    FROM Zaposleni z
    JOIN Zaposleni_Funkcija zf ON zf.Id_zaposlenog = z.Id
    JOIN Funkcije_Zaposlenih f ON f.Id = zf.Id_funkcije
    WHERE f.Ime_funkcije = N'Instruktor'
    ORDER BY z.JMBG;

    SELECT TOP (1) @TipObukeId = Id
    FROM Tip_obuke
    WHERE Tip = N'Prakticna';

    SELECT TOP (1) @GrupaId = Id
    FROM Grupa
    ORDER BY Datum_kreiranja DESC;

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

    EXEC dbo.usp_ZakaziPrakticniCas
        @Obuka_id = @NovaObukaId,
        @Instruktor_id = @InstruktorId,
        @Vozilo_id = @VoziloId,
        @Datum = '2029-01-11',
        @Pocetak = '2029-01-11T09:00:00',
        @Kraj = '2029-01-11T09:45:00',
        @Lokacija = N'Demo lokacija',
        @Novi_Cas_id = @NoviCasId OUTPUT;

    SELECT TOP (1) @CenovnikId = Id
    FROM Cenovnik
    WHERE Datum_do IS NULL
    ORDER BY Cena;

    EXEC dbo.usp_EvidentirajUplatu
        @Obuka_id = @NovaObukaId,
        @Cenovnik_id = @CenovnikId,
        @Iznos = 2500.00,
        @Datum = '2029-01-10',
        @Nacin_placanja = N'Kartica',
        @Nova_Uplata_id = @NovaUplataId OUTPUT;

    SELECT TOP (1) @PolaganjeId = Id
    FROM Polaganje
    ORDER BY Pocetak DESC;

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
