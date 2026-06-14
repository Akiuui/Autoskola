GO

-- usp_UpisKandidataNaObuku
-- Upis kandidata na obuku je citava operacija, a ne samo prost INSERT.
-- Mora da proveri da kandidat, kategorija, tip obuke i instruktor postoje,
-- kao i da kandidat nema vec aktivnu obuku za istu kategoriju.
-- Ako se prosledi grupa, kandidat se odmah povezuje i sa grupom.
CREATE OR ALTER PROCEDURE dbo.usp_UpisKandidataNaObuku
    @Kandidat_id UNIQUEIDENTIFIER,
    @Kategorija_id UNIQUEIDENTIFIER,
    @Glavni_Instruktor_id UNIQUEIDENTIFIER = NULL,
    @Tip_Obuke UNIQUEIDENTIFIER,
    @Datum_pocetka DATE,
    @Grupa_id UNIQUEIDENTIFIER = NULL,
    @Nova_Obuka_id UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Kandidat WHERE Id = @Kandidat_id)
            THROW 50001, 'Kandidat ne postoji.', 1;

        IF NOT EXISTS (SELECT 1 FROM Kategorija_vozacke WHERE Id = @Kategorija_id)
            THROW 50002, 'Kategorija ne postoji.', 1;

        IF NOT EXISTS (SELECT 1 FROM Tip_obuke WHERE Id = @Tip_Obuke)
            THROW 50003, 'Tip obuke ne postoji.', 1;

        IF @Glavni_Instruktor_id IS NOT NULL
           AND NOT EXISTS (SELECT 1 FROM Zaposleni WHERE Id = @Glavni_Instruktor_id)
            THROW 50004, 'Glavni instruktor ne postoji.', 1;

        IF @Grupa_id IS NOT NULL
           AND NOT EXISTS (SELECT 1 FROM Grupa WHERE Id = @Grupa_id)
            THROW 50005, 'Grupa ne postoji.', 1;

        IF dbo.fn_KandidatImaAktivnuObuku(@Kandidat_id, @Kategorija_id) = 1
            THROW 50006, 'Kandidat vec ima aktivnu obuku za ovu kategoriju.', 1;

        SET @Nova_Obuka_id = newid();

        INSERT INTO Obuka (
            Id, Kategorija_id, Glavni_Instruktor_id, Kandidat_id, Tip_Obuke,
            Datum_pocetka, Datum_zavrsetka, Status
        )
        VALUES (
            @Nova_Obuka_id, @Kategorija_id, @Glavni_Instruktor_id, @Kandidat_id,
            @Tip_Obuke, @Datum_pocetka, NULL, N'Aktivan'
        );

        IF @Grupa_id IS NOT NULL
        BEGIN
            INSERT INTO Kandidat_grupa (Grupa_id, Obuka_id, Datum_od, Datum_do)
            VALUES (@Grupa_id, @Nova_Obuka_id, @Datum_pocetka, NULL);
        END;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- usp_ZakaziPrakticniCas
-- Zakazivanje prakticnog casa mora da proveri da obuka, instruktor i vozilo
-- postoje, da vreme ima smisla i da instruktor ili vozilo nisu zauzeti.
-- Zato se koristi transakcija i poslovne provere pre unosa casa.
CREATE OR ALTER PROCEDURE dbo.usp_ZakaziPrakticniCas
    @Obuka_id UNIQUEIDENTIFIER,
    @Instruktor_id UNIQUEIDENTIFIER,
    @Vozilo_id UNIQUEIDENTIFIER,
    @Datum DATE,
    @Pocetak DATETIME2,
    @Kraj DATETIME2,
    @Lokacija NVARCHAR(200) = NULL,
    @Novi_Cas_id UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET XACT_ABORT ON;

    DECLARE @Tip_id UNIQUEIDENTIFIER;

    BEGIN TRY
        BEGIN TRANSACTION;

        SELECT @Tip_id = Id
        FROM Tip_obuke
        WHERE Tip = N'Prakticna';

        IF @Tip_id IS NULL
            THROW 50101, 'Tip obuke Prakticna ne postoji.', 1;

        IF NOT EXISTS (SELECT 1 FROM Obuka WHERE Id = @Obuka_id)
            THROW 50102, 'Obuka ne postoji.', 1;

        IF NOT EXISTS (SELECT 1 FROM Zaposleni WHERE Id = @Instruktor_id)
            THROW 50103, 'Instruktor ne postoji.', 1;

        IF NOT EXISTS (SELECT 1 FROM Vozilo WHERE Id = @Vozilo_id)
            THROW 50104, 'Vozilo ne postoji.', 1;

        IF @Kraj <= @Pocetak
            THROW 50105, 'Kraj casa mora biti posle pocetka.', 1;

        IF CONVERT(date, @Pocetak) <> @Datum OR CONVERT(date, @Kraj) <> @Datum
            THROW 50106, 'Datum casa mora odgovarati pocetku i kraju casa.', 1;

        IF EXISTS (
            SELECT 1
            FROM Cas c
            WHERE c.Instruktor_id = @Instruktor_id
              AND c.Status <> N'Otkazan'
              AND @Pocetak < c.Kraj
              AND @Kraj > c.Pocetak
        )
            THROW 50107, 'Instruktor vec ima cas u tom terminu.', 1;

        IF EXISTS (
            SELECT 1
            FROM Cas c
            WHERE c.Vozilo_id = @Vozilo_id
              AND c.Status <> N'Otkazan'
              AND @Pocetak < c.Kraj
              AND @Kraj > c.Pocetak
        )
            THROW 50108, 'Vozilo je vec zauzeto u tom terminu.', 1;

        SET @Novi_Cas_id = newid();

        INSERT INTO Cas (
            Id, Instruktor_id, Tip_id, Lokacija, Datum, Pocetak, Kraj,
            Status, Obuka_id, Vozilo_id, Grupa_id
        )
        VALUES (
            @Novi_Cas_id, @Instruktor_id, @Tip_id, @Lokacija, @Datum, @Pocetak,
            @Kraj, N'Zakazan', @Obuka_id, @Vozilo_id, NULL
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- usp_EvidentirajUplatu
-- Evidentiranje uplate je finansijska operacija. Procedura proverava
-- da obuka i cenovnik postoje i da je nacin placanja dozvoljen.
CREATE OR ALTER PROCEDURE dbo.usp_EvidentirajUplatu
    @Obuka_id UNIQUEIDENTIFIER,
    @Cenovnik_id UNIQUEIDENTIFIER,
    @Iznos DECIMAL(10, 2),
    @Datum DATE,
    @Nacin_placanja NVARCHAR(20),
    @Nova_Uplata_id UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Obuka WHERE Id = @Obuka_id)
            THROW 50201, 'Obuka ne postoji.', 1;

        IF NOT EXISTS (SELECT 1 FROM Cenovnik WHERE Id = @Cenovnik_id)
            THROW 50202, 'Stavka cenovnika ne postoji.', 1;

        IF @Iznos = 0
            THROW 50203, 'Iznos uplate ne sme biti nula.', 1;

        IF @Nacin_placanja NOT IN (N'Gotovina', N'Kartica', N'Prenos')
            THROW 50204, 'Nacin placanja nije dozvoljen.', 1;

        SET @Nova_Uplata_id = newid();

        INSERT INTO Uplata (
            Id, Cenovnik_id, Obuka_id, Iznos, Datum, Nacin_placanja
        )
        VALUES (
            @Nova_Uplata_id, @Cenovnik_id, @Obuka_id, @Iznos, @Datum,
            @Nacin_placanja
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- usp_PrijaviKandidataNaPolaganje
-- Prijava kandidata na polaganje se cuva u tabeli Polaganje_kandidat.
-- Procedura proverava da polaganje i obuka postoje i sprecava duplu prijavu.
CREATE OR ALTER PROCEDURE dbo.usp_PrijaviKandidataNaPolaganje
    @Polaganje_id UNIQUEIDENTIFIER,
    @Obuka_id UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM Polaganje WHERE Id = @Polaganje_id)
            THROW 50301, 'Polaganje ne postoji.', 1;

        IF NOT EXISTS (SELECT 1 FROM Obuka WHERE Id = @Obuka_id)
            THROW 50302, 'Obuka ne postoji.', 1;

        IF EXISTS (
            SELECT 1
            FROM Polaganje_kandidat
            WHERE Polaganje_id = @Polaganje_id
              AND Obuka_id = @Obuka_id
        )
            THROW 50303, 'Kandidat je vec prijavljen na ovo polaganje.', 1;

        INSERT INTO Polaganje_kandidat (
            Polaganje_id, Obuka_id, Uspesno, Broj_Poenta
        )
        VALUES (
            @Polaganje_id, @Obuka_id, NULL, NULL
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- usp_EvidentirajRezultatPolaganja
-- Rezultat polaganja mora da azurira postojecu prijavu kandidata.
-- Procedura proverava opseg poena i cuva rezultat kao jednu transakciju.
CREATE OR ALTER PROCEDURE dbo.usp_EvidentirajRezultatPolaganja
    @Polaganje_id UNIQUEIDENTIFIER,
    @Obuka_id UNIQUEIDENTIFIER,
    @Uspesno BIT,
    @Broj_Poenta TINYINT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1
            FROM Polaganje_kandidat
            WHERE Polaganje_id = @Polaganje_id
              AND Obuka_id = @Obuka_id
        )
            THROW 50401, 'Prijava kandidata na polaganje ne postoji.', 1;

        IF @Broj_Poenta NOT BETWEEN 0 AND 100
            THROW 50402, 'Broj poena mora biti izmedju 0 i 100.', 1;

        UPDATE Polaganje_kandidat
        SET
            Uspesno = @Uspesno,
            Broj_Poenta = @Broj_Poenta
        WHERE Polaganje_id = @Polaganje_id
          AND Obuka_id = @Obuka_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
