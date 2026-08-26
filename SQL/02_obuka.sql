CREATE TABLE Tip_obuke (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Tip NVARCHAR(30) NOT NULL,
    Opis NVARCHAR(100),
    -- Naziv tipa obuke ne sme da se ponavlja.
    CONSTRAINT UQ_Tip_obuke_Tip UNIQUE (Tip),
    -- Opis, ako je unet, ne sme biti prazan.
    CONSTRAINT CK_Tip_obuke_Opis CHECK (Opis IS NULL OR LEN(LTRIM(RTRIM(Opis))) > 0),
    -- Tip obuke moze biti samo jedna od dozvoljenih vrednosti.
    CONSTRAINT CK_Tip_obuke_Tip CHECK (Tip IN (N'Teorijska', N'Prakticna', N'Prva Pomoc'))
);
GO

CREATE TABLE Kategorija_vozacke (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Oznaka CHAR(2) NOT NULL,
    Opis NVARCHAR(50),
    -- Oznaka kategorije ne sme da se ponavlja.
    CONSTRAINT UQ_Kategorija_vozacke_Oznaka UNIQUE (Oznaka),
    -- Tekstualna polja ne smeju biti prazna.
    CONSTRAINT CK_Kategorija_vozacke_Tekst CHECK (
        LEN(LTRIM(RTRIM(Oznaka))) > 0
        AND (Opis IS NULL OR LEN(LTRIM(RTRIM(Opis))) > 0)
    )
);
GO

CREATE TABLE Grupa (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Datum_kreiranja DATE NOT NULL
        CONSTRAINT DF_Grupa_Datum_kreiranja DEFAULT (getdate()),
    Datum_zavrsetka DATE,
    -- Datum zavrsetka grupe, ako postoji, ne sme biti pre datuma kreiranja.
    CONSTRAINT CK_Grupa_Datum CHECK (Datum_zavrsetka IS NULL OR Datum_zavrsetka >= Datum_kreiranja)
);
GO

CREATE TABLE Obuka (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Kategorija_id INT NOT NULL CONSTRAINT FK_Obuka_Kategorija_Id REFERENCES Kategorija_vozacke (Id),
    Glavni_Instruktor_id INT CONSTRAINT FK_Obuka_Instruktor REFERENCES Zaposleni (Id),
    Kandidat_id INT NOT NULL CONSTRAINT FK_Obuka_Kandidat_Id REFERENCES Kandidat (Id),
    Tip_Obuke INT NOT NULL CONSTRAINT FK_Obuka_Tip_Id REFERENCES Tip_obuke (Id),
    Datum_pocetka DATE NOT NULL,
    Datum_zavrsetka DATE,
    Status NVARCHAR(20) NOT NULL
        CONSTRAINT DF_Obuka_Status DEFAULT (N'Aktivan'),
    Kreiran_datum DATETIME2 NOT NULL
        CONSTRAINT DF_Obuka_Kreiran_datum DEFAULT (getdate()),
    Izmenjen_datum DATETIME2,
    -- Status obuke moze biti samo jedna od dozvoljenih vrednosti.
    CONSTRAINT CK_Obuka_Status CHECK (Status IN (N'Aktivan', N'Zavrsen', N'Prekinut')),
    -- Datum zavrsetka obuke, ako postoji, ne sme biti pre datuma pocetka.
    CONSTRAINT CK_Obuka_Datum CHECK (Datum_zavrsetka IS NULL OR Datum_zavrsetka >= Datum_pocetka)
);
GO

-- CREATE INDEX IX_Obuka_Kandidat_Kategorija_Datum ON Obuka (Kandidat_id, Kategorija_id, Datum_pocetka)
-- INCLUDE (Datum_zavrsetka, Status, Tip_Obuke, Glavni_Instruktor_id);

CREATE TABLE Kandidat_grupa (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Grupa_id INT NOT NULL CONSTRAINT FK_Kandidat_grupa_Grupa_Id REFERENCES Grupa (Id),
    Obuka_id INT NOT NULL CONSTRAINT FK_Kandidat_grupa_Obuka_Id REFERENCES Obuka (Id),
    Datum_od DATE NOT NULL,
    Datum_do DATE,
    -- Ista obuka ne moze biti dodata u istu grupu vise puta.
    CONSTRAINT UQ_Kandidat_grupa_Obuka_Grupa UNIQUE (Obuka_id, Grupa_id),
    -- Datum izlaska iz grupe, ako postoji, ne sme biti pre datuma ulaska.
    CONSTRAINT CK_Kandidat_grupa_Datum CHECK (Datum_do IS NULL OR Datum_do >= Datum_od)
);
GO

-- CREATE INDEX IX_Kandidat_grupa_Grupa_INCLUDE ON Kandidat_grupa (Grupa_id) INCLUDE (Obuka_id, Datum_od, Datum_do);
