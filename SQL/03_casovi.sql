CREATE TABLE Vozilo (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Registracija NVARCHAR(20) NOT NULL,
    Marka NVARCHAR(50) NOT NULL,
    Model NVARCHAR(50) NOT NULL,
    Godiste INT NOT NULL,
    Kategorija_id INT NOT NULL CONSTRAINT FK_Vozilo_Kategorija_Id REFERENCES Kategorija_vozacke (Id),
    Kilometraza INT NOT NULL
        CONSTRAINT DF_Vozilo_Kilometraza DEFAULT (0),
    Datum_registracije DATE NOT NULL,
    Kreiran_datum DATETIME2 NOT NULL
        CONSTRAINT DF_Vozilo_Kreiran_datum DEFAULT (getdate()),
    Izmenjen_datum DATETIME2,
    -- Registracija vozila ne sme da se ponavlja.
    CONSTRAINT UQ_Vozilo_Registracija UNIQUE (Registracija),
    -- Godiste vozila mora biti u realnom opsegu.
    CONSTRAINT CK_Vozilo_Godiste CHECK (Godiste BETWEEN 1980 AND YEAR(getdate()) + 1),
    -- Kilometraza ne moze biti negativna.
    CONSTRAINT CK_Vozilo_Kilometraza CHECK (Kilometraza >= 0),
    -- Tekstualna polja ne smeju biti prazna.
    CONSTRAINT CK_Vozilo_Tekst CHECK (
        LEN(LTRIM(RTRIM(Registracija))) > 0
        AND LEN(LTRIM(RTRIM(Marka))) > 0
        AND LEN(LTRIM(RTRIM(Model))) > 0
    )
);
GO

CREATE TABLE Cas (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Instruktor_id INT NOT NULL CONSTRAINT FK_Cas_Instruktor_Id REFERENCES Zaposleni (Id),
    Tip_id INT NOT NULL CONSTRAINT FK_Cas_Tip_Id REFERENCES Tip_obuke (Id),
    Lokacija NVARCHAR(200),
    Datum DATE NOT NULL,
    Pocetak TIME NOT NULL,
    Kraj TIME NOT NULL,
    Status NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Cas_Status DEFAULT (N'Zakazan'),
    Obuka_id INT CONSTRAINT FK_Cas_Obuka_Id REFERENCES Obuka (Id),
    Vozilo_id INT CONSTRAINT FK_Cas_Vozilo_Id REFERENCES Vozilo (Id),
    Grupa_id INT CONSTRAINT FK_Cas_Grupa_Id REFERENCES Grupa (Id),
    Kreiran_datum DATETIME2 NOT NULL
        CONSTRAINT DF_Cas_Kreiran_datum DEFAULT (getdate()),
    Izmenjen_datum DATETIME2,
    -- Lokacija, ako je uneta, ne sme biti prazna.
    CONSTRAINT CK_Cas_Lokacija CHECK (Lokacija IS NULL OR LEN(LTRIM(RTRIM(Lokacija))) > 0),
    -- Status casa moze biti samo jedna od dozvoljenih vrednosti.
    CONSTRAINT CK_Cas_Status CHECK (Status IN (N'Zakazan', N'Odrzan', N'Otkazan')),
    -- Vreme zavrsetka casa mora biti posle vremena pocetka.
    CONSTRAINT CK_Cas_Vreme CHECK (Kraj > Pocetak),
    -- Prakticni cas ima obuku i vozilo, a teorijski cas ima samo grupu.
    CONSTRAINT CK_Cas_Tip_Polja CHECK (
        (
            Obuka_id IS NOT NULL
            AND Vozilo_id IS NOT NULL
            AND Grupa_id IS NULL
        )
        OR
        (
            Grupa_id IS NOT NULL
            AND Obuka_id IS NULL
            AND Vozilo_id IS NULL
        )
    )
);
GO

-- CREATE INDEX IX_Cas_Instruktor_Datum_Pocetak ON Cas (Instruktor_id, Datum, Pocetak);

-- CREATE INDEX IX_Cas_Obuka_Datum_Pocetak ON Cas (Obuka_id, Datum, Pocetak)
-- INCLUDE (Kraj, Status, Lokacija, Instruktor_id, Tip_id, Vozilo_id);
