GO
-- Triggeri za automatsko azuriranje Izmenjen_datum.
CREATE OR ALTER TRIGGER dbo.trg_Kandidat_SetIzmenjenDatum
ON dbo.Kandidat
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE k
    SET Izmenjen_datum = sysdatetime()
    FROM Kandidat k
    JOIN inserted i ON i.Id = k.Id;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_Zaposleni_SetIzmenjenDatum
ON dbo.Zaposleni
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE z
    SET Izmenjen_datum = sysdatetime()
    FROM Zaposleni z
    JOIN inserted i ON i.Id = z.Id;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_Obuka_SetIzmenjenDatum
ON dbo.Obuka
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE o
    SET Izmenjen_datum = sysdatetime()
    FROM Obuka o
    JOIN inserted i ON i.Id = o.Id;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_Vozilo_SetIzmenjenDatum
ON dbo.Vozilo
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE v
    SET Izmenjen_datum = sysdatetime()
    FROM Vozilo v
    JOIN inserted i ON i.Id = v.Id;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_Cas_SetIzmenjenDatum
ON dbo.Cas
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE c
    SET Izmenjen_datum = sysdatetime()
    FROM Cas c
    JOIN inserted i ON i.Id = c.Id;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_Polaganje_SetIzmenjenDatum
ON dbo.Polaganje
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE p
    SET Izmenjen_datum = sysdatetime()
    FROM Polaganje p
    JOIN inserted i ON i.Id = p.Id;
END;
GO

CREATE OR ALTER TRIGGER dbo.trg_Uplata_SetIzmenjenDatum
ON dbo.Uplata
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Izmenjen_datum)
        RETURN;

    UPDATE u
    SET Izmenjen_datum = sysdatetime()
    FROM Uplata u
    JOIN inserted i ON i.Id = u.Id;
END;
GO

-- Zabrana fizickog brisanja uplata.
CREATE OR ALTER TRIGGER dbo.trg_Uplata_ZabraniBrisanje
ON dbo.Uplata
INSTEAD OF DELETE
AS
BEGIN
    THROW 51001, 'Uplate se ne brisu. Za ispravku unesite korektivnu negativnu uplatu.', 1;
END;

GO

-- Zabrana smanjenja kilometraze vozila.
CREATE OR ALTER TRIGGER dbo.trg_Vozilo_Kilometraza_NeSmanjuje
ON dbo.Vozilo
AFTER UPDATE
AS
BEGIN
    IF NOT UPDATE(Kilometraza)
        RETURN;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN deleted d ON d.Id = i.Id
        WHERE i.Kilometraza < d.Kilometraza
    )
        THROW 51002, 'Kilometraza vozila ne sme da se smanji.', 1;
END;
GO

-- Povecanje kilometraze posle odrzanog casa.
CREATE OR ALTER TRIGGER dbo.trg_Cas_Odrzan_PovecajKilometrazu
ON dbo.Cas
AFTER UPDATE
AS
BEGIN
    IF NOT UPDATE(Status)
        RETURN;

    UPDATE v
    SET Kilometraza = v.Kilometraza + 10
    FROM Vozilo v
    JOIN inserted i ON i.Vozilo_id = v.Id
    JOIN deleted d ON d.Id = i.Id
    WHERE i.Status = N'Odrzan'
      AND d.Status <> N'Odrzan'
      AND i.Vozilo_id IS NOT NULL;
END;
GO