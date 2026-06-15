GO

-- Cesto je potrebno znati koliko je ukupno placeno za jednu obuku.
-- Ova funkcija sabira sve uplate za zadatu obuku.
CREATE OR ALTER FUNCTION dbo.fn_UkupnoUplacenoZaObuku
(
    @Obuka_id UNIQUEIDENTIFIER
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @Ukupno DECIMAL(10, 2);

    SELECT @Ukupno = COALESCE(SUM(u.Iznos), 0)
    FROM Uplata u
    WHERE u.Obuka_id = @Obuka_id;

    RETURN COALESCE(@Ukupno, 0);
END;
GO

-- Za pracenje napretka kandidata vazno je znati koliko je casova ima obuka.
-- Parametar @Samo_odrzani omogucava da se broje svi casovi ili samo odrzani.
CREATE OR ALTER FUNCTION dbo.fn_BrojCasovaZaObuku
(
    @Obuka_id UNIQUEIDENTIFIER,
    @Samo_odrzani BIT
)
RETURNS INT
AS
BEGIN
    DECLARE @Broj INT;

    SELECT @Broj = COUNT(*)
    FROM Cas c
    WHERE c.Obuka_id = @Obuka_id
      AND (@Samo_odrzani = 0 OR c.Status = N'Odrzan');

    RETURN COALESCE(@Broj, 0);
END;
GO

-- Obuka moze imati vise pokusaja polaganja. Ova funkcija vraca koliko puta
-- je konkretna obuka prijavljena na polaganje.
CREATE OR ALTER FUNCTION dbo.fn_BrojPolaganjaZaObuku
(
    @Obuka_id UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    DECLARE @Broj INT;

    SELECT @Broj = COUNT(*)
    FROM Polaganje_kandidat pk
    WHERE pk.Obuka_id = @Obuka_id;

    RETURN COALESCE(@Broj, 0);
END;
GO

-- Koristi se kao provera pre upisa kandidata na novu obuku.
-- Za istog kandidata i kategoriju ne zelimo paralelnu aktivnu obuku.
CREATE OR ALTER FUNCTION dbo.fn_KandidatImaAktivnuObuku
(
    @Kandidat_id UNIQUEIDENTIFIER,
    @Kategorija_id UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    DECLARE @Postoji BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM Obuka o
        WHERE o.Kandidat_id = @Kandidat_id
          AND o.Kategorija_id = @Kategorija_id
          AND o.Status = N'Aktivan'
    )
    BEGIN
        SET @Postoji = 1;
    END;

    RETURN @Postoji;
END;
GO

-- Ovo je tabelarna funkcija za prikaz rasporeda jednog instruktora
-- u zadatom periodu.
CREATE OR ALTER FUNCTION dbo.fn_RasporedInstruktora
(
    @Instruktor_id UNIQUEIDENTIFIER,
    @Datum_od DATE,
    @Datum_do DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        c.Id AS Cas_id,
        c.Datum,
        c.Pocetak,
        c.Kraj,
        c.Status,
        c.Lokacija,
        t.Tip AS Tip_casa,
        o.Id AS Obuka_id,
        k.Ime + N' ' + k.Prezime AS Kandidat,
        v.Registracija
    FROM Cas c
    JOIN Tip_obuke t ON t.Id = c.Tip_id
    LEFT JOIN Obuka o ON o.Id = c.Obuka_id
    LEFT JOIN Kandidat k ON k.Id = o.Kandidat_id
    LEFT JOIN Vozilo v ON v.Id = c.Vozilo_id
    WHERE c.Instruktor_id = @Instruktor_id
      AND c.Datum BETWEEN @Datum_od AND @Datum_do
);
GO
