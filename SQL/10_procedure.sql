GO

-- Upis kandidata na obuku.
CREATE OR ALTER PROCEDURE dbo.usp_UpisKandidataNaObuku
    @Kandidat_id INT,
    @Kategorija_id INT,
    @Glavni_Instruktor_id INT = NULL,
    @Tip_Obuke INT,
    @Datum_pocetka DATE,
    @Grupa_id INT = NULL,
    @Nova_Obuka_id INT OUTPUT
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

        INSERT INTO Obuka (
            Kategorija_id, Glavni_Instruktor_id, Kandidat_id, Tip_Obuke,
            Datum_pocetka, Datum_zavrsetka, Status
        )
        VALUES (
            @Kategorija_id, @Glavni_Instruktor_id, @Kandidat_id,
            @Tip_Obuke, @Datum_pocetka, NULL, N'Aktivan'
        );

        SET @Nova_Obuka_id = CONVERT(INT, SCOPE_IDENTITY());

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

-- Zakazivanje prakticnog casa.
CREATE OR ALTER PROCEDURE dbo.usp_ZakaziPrakticniCas
    @Obuka_id INT,
    @Instruktor_id INT,
    @Vozilo_id INT,
    @Datum DATE,
    @Pocetak TIME,
    @Kraj TIME,
    @Lokacija NVARCHAR(200) = NULL,
    @Novi_Cas_id INT OUTPUT
AS
BEGIN
    SET XACT_ABORT ON;

    DECLARE @Tip_id INT;

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

        IF EXISTS (
            SELECT 1
            FROM Cas c
            WHERE c.Instruktor_id = @Instruktor_id
              AND c.Datum = @Datum
              AND c.Status <> N'Otkazan'
              AND @Pocetak < c.Kraj
              AND @Kraj > c.Pocetak
        )
            THROW 50107, 'Instruktor vec ima cas u tom terminu.', 1;

        IF EXISTS (
            SELECT 1
            FROM Cas c
            WHERE c.Vozilo_id = @Vozilo_id
              AND c.Datum = @Datum
              AND c.Status <> N'Otkazan'
              AND @Pocetak < c.Kraj
              AND @Kraj > c.Pocetak
        )
            THROW 50108, 'Vozilo je vec zauzeto u tom terminu.', 1;

        INSERT INTO Cas (
            Instruktor_id, Tip_id, Lokacija, Datum, Pocetak, Kraj,
            Status, Obuka_id, Vozilo_id, Grupa_id
        )
        VALUES (
            @Instruktor_id, @Tip_id, @Lokacija, @Datum, @Pocetak,
            @Kraj, N'Zakazan', @Obuka_id, @Vozilo_id, NULL
        );

        SET @Novi_Cas_id = CONVERT(INT, SCOPE_IDENTITY());

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- Evidentiranje uplate.
CREATE OR ALTER PROCEDURE dbo.usp_EvidentirajUplatu
    @Obuka_id INT,
    @Cenovnik_id INT,
    @Iznos DECIMAL(10, 2),
    @Datum DATE,
    @Nacin_placanja NVARCHAR(20),
    @Nova_Uplata_id INT OUTPUT
AS
BEGIN
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

        INSERT INTO Uplata (
            Cenovnik_id, Obuka_id, Iznos, Datum, Nacin_placanja
        )
        VALUES (
            @Cenovnik_id, @Obuka_id, @Iznos, @Datum,
            @Nacin_placanja
        );

        SET @Nova_Uplata_id = CONVERT(INT, SCOPE_IDENTITY());

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO

-- Prijava kandidata na polaganje.
CREATE OR ALTER PROCEDURE dbo.usp_PrijaviKandidataNaPolaganje
    @Polaganje_id INT,
    @Obuka_id INT
AS
BEGIN
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

-- Evidentiranje rezultata polaganja.
CREATE OR ALTER PROCEDURE dbo.usp_EvidentirajRezultatPolaganja
    @Polaganje_id INT,
    @Obuka_id INT,
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
