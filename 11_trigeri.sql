GO
-- Sledecih 7 trigera se bave poljima: Izmenjen_datum. Ovo polje 
-- postoji na vaznijim tabelama radi bolje evidencije.
-- trg_Kandidat_SetIzmenjenDatum
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

-- trg_Zaposleni_SetIzmenjenDatum
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

-- trg_Obuka_SetIzmenjenDatum
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

-- trg_Vozilo_SetIzmenjenDatum
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

-- trg_Cas_SetIzmenjenDatum
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

-- trg_Polaganje_SetIzmenjenDatum
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

-- trg_Uplata_SetIzmenjenDatum
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

-- trg_Uplata_ZabraniBrisanje
-- U finansijama se uplate ne brisu fizicki, jer je potreban trag.
CREATE OR ALTER TRIGGER dbo.trg_Uplata_ZabraniBrisanje
ON dbo.Uplata
INSTEAD OF DELETE
AS
BEGIN
    THROW 51001, 'Uplate se ne brisu. Za ispravku unesite korektivnu negativnu uplatu.', 1;
END;
GO
