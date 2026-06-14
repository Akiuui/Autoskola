-- Triggeri za bazu Auto skola.
--
-- Razlog za ovaj fajl:
-- Triggeri se koriste za automatske reakcije baze na promene podataka.
-- Ovde su izabrani triggeri koji imaju jasnu i ogranicenu svrhu:
-- automatsko azuriranje kolone Izmenjen_datum.
--
-- Zasto bas ovi triggeri:
-- Vise tabela vec ima kolonu Izmenjen_datum. Bez triggera bi svaka aplikacija
-- ili svaki rucni UPDATE morao sam da postavlja datum izmene.
-- Trigger centralizuje to pravilo u bazi.

GO

-- trg_Kandidat_SetIzmenjenDatum
-- Razlog postojanja:
-- Kada se promene podaci kandidata, baza sama pamti vreme poslednje izmene.
CREATE OR ALTER TRIGGER dbo.trg_Kandidat_SetIzmenjenDatum
ON dbo.Kandidat
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE k
    SET Izmenjen_datum = sysdatetime()
    FROM Kandidat k
    JOIN inserted i ON i.Id = k.Id;
END;
GO

-- trg_Zaposleni_SetIzmenjenDatum
-- Razlog postojanja:
-- Kada se promene podaci zaposlenog, baza sama pamti vreme poslednje izmene.
CREATE OR ALTER TRIGGER dbo.trg_Zaposleni_SetIzmenjenDatum
ON dbo.Zaposleni
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE z
    SET Izmenjen_datum = sysdatetime()
    FROM Zaposleni z
    JOIN inserted i ON i.Id = z.Id;
END;
GO

-- trg_Obuka_SetIzmenjenDatum
-- Razlog postojanja:
-- Obuka se menja tokom vremena: status, instruktor ili datum zavrsetka.
-- Trigger automatski belezi kada je obuka poslednji put izmenjena.
CREATE OR ALTER TRIGGER dbo.trg_Obuka_SetIzmenjenDatum
ON dbo.Obuka
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE o
    SET Izmenjen_datum = sysdatetime()
    FROM Obuka o
    JOIN inserted i ON i.Id = o.Id;
END;
GO

-- trg_Vozilo_SetIzmenjenDatum
-- Razlog postojanja:
-- Za vozila je korisno znati kada su poslednji put promenjeni podaci,
-- na primer kilometraza ili datum registracije.
CREATE OR ALTER TRIGGER dbo.trg_Vozilo_SetIzmenjenDatum
ON dbo.Vozilo
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE v
    SET Izmenjen_datum = sysdatetime()
    FROM Vozilo v
    JOIN inserted i ON i.Id = v.Id;
END;
GO

-- trg_Cas_SetIzmenjenDatum
-- Razlog postojanja:
-- Casovi se mogu pomerati, otkazivati ili oznacavati kao odrzani.
-- Trigger automatski belezi poslednju izmenu casa.
CREATE OR ALTER TRIGGER dbo.trg_Cas_SetIzmenjenDatum
ON dbo.Cas
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE c
    SET Izmenjen_datum = sysdatetime()
    FROM Cas c
    JOIN inserted i ON i.Id = c.Id;
END;
GO

-- trg_Polaganje_SetIzmenjenDatum
-- Razlog postojanja:
-- Ako se promeni termin polaganja, baza automatski cuva vreme izmene.
CREATE OR ALTER TRIGGER dbo.trg_Polaganje_SetIzmenjenDatum
ON dbo.Polaganje
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE p
    SET Izmenjen_datum = sysdatetime()
    FROM Polaganje p
    JOIN inserted i ON i.Id = p.Id;
END;
GO

-- trg_Uplata_SetIzmenjenDatum
-- Razlog postojanja:
-- Finansijski podaci su osetljivi. Ako se uplata ispravi, baza pamti
-- kada je poslednji put menjana.
CREATE OR ALTER TRIGGER dbo.trg_Uplata_SetIzmenjenDatum
ON dbo.Uplata
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE u
    SET Izmenjen_datum = sysdatetime()
    FROM Uplata u
    JOIN inserted i ON i.Id = u.Id;
END;
GO

-- trg_Uplata_ZabraniBrisanje
-- Razlog postojanja:
-- U finansijama se uplate obicno ne brisu fizicki, jer je potreban trag.
-- Ako je napravljena greska, unosi se korektivna negativna uplata,
-- sto je vec dozvoljeno CHECK constraintom nad kolonom Iznos.
CREATE OR ALTER TRIGGER dbo.trg_Uplata_ZabraniBrisanje
ON dbo.Uplata
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    THROW 51001, 'Uplate se ne brisu. Za ispravku unesite korektivnu negativnu uplatu.', 1;
END;
GO
