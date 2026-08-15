CREATE TABLE Cenovnik (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Naziv NVARCHAR(100) NOT NULL,
    Opis NVARCHAR(500),
    Cena DECIMAL(10,2) NOT NULL,
    Datum_od DATE NOT NULL,
    Datum_do DATE,
    -- Tekstualna polja ne smeju biti prazna.
    CONSTRAINT CK_Cenovnik_Tekst CHECK (
        LEN(LTRIM(RTRIM(Naziv))) > 0
        AND (Opis IS NULL OR LEN(LTRIM(RTRIM(Opis))) > 0)
    ),
    -- Cena mora biti pozitivna.
    CONSTRAINT CK_Cenovnik_Cena CHECK (Cena > 0),
    -- Datum prestanka vazenja, ako postoji, ne sme biti pre datuma pocetka vazenja.
    CONSTRAINT CK_Cenovnik_Datum CHECK (Datum_do IS NULL OR Datum_do >= Datum_od)
);
GO

CREATE TABLE Uplata (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Cenovnik_id INT NOT NULL REFERENCES Cenovnik (Id),
    Obuka_id INT NOT NULL REFERENCES Obuka (Id),
    Iznos DECIMAL(10,2) NOT NULL,
    Datum DATE NOT NULL
        CONSTRAINT DF_Uplata_Datum DEFAULT (getdate()),
    Nacin_placanja NVARCHAR(20) NOT NULL,
    Kreiran_datum DATETIME2 NOT NULL
        CONSTRAINT DF_Uplata_Kreiran_datum DEFAULT (getdate()),
    Izmenjen_datum DATETIME2,
    -- Iznos ne sme biti nula; negativan iznos je dozvoljen kao korekcija.
    CONSTRAINT CK_Uplata_Iznos CHECK (Iznos <> 0),
    -- Nacin placanja moze biti samo jedna od dozvoljenih vrednosti.
    CONSTRAINT CK_Uplata_Nacin_placanja CHECK (Nacin_placanja IN (N'Gotovina', N'Kartica', N'Prenos'))
);
GO

-- CREATE INDEX IX_Uplata_Obuka_INCLUDE ON Uplata (Obuka_id)
-- INCLUDE (Iznos, Datum, Nacin_placanja, Cenovnik_id);

-- CREATE INDEX IX_Uplata_Datum_INCLUDE ON Uplata (Datum, Nacin_placanja)
-- INCLUDE (Iznos);
