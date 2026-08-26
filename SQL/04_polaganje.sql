CREATE TABLE Polaganje (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Tip_id INT NOT NULL CONSTRAINT FK_Polaganje_Tip_Id REFERENCES Tip_obuke (Id),
    Pocetak DATETIME2 NOT NULL,
    Kraj DATETIME2 NOT NULL,
    Kreiran_datum DATETIME2 NOT NULL
        CONSTRAINT DF_Polaganje_Kreiran_datum DEFAULT (getdate()),
    Izmenjen_datum DATETIME2,
    -- Vreme zavrsetka polaganja mora biti posle vremena pocetka.
    CONSTRAINT CK_Polaganje_Vreme CHECK (Kraj > Pocetak)
);
GO

CREATE TABLE Polaganje_kandidat (
    Polaganje_id INT NOT NULL CONSTRAINT FK_Polaganje_kandidat_Polaganje_Id REFERENCES Polaganje (Id),
    Obuka_id INT NOT NULL CONSTRAINT FK_Polaganje_kandidat_Obuka_Id REFERENCES Obuka (Id),
    Uspesno BIT,
    Broj_Poenta TINYINT,
    -- Ista obuka ne moze biti prijavljena na isto polaganje vise puta.
    CONSTRAINT PK_Polaganje_kandidat PRIMARY KEY (Polaganje_id, Obuka_id),
    -- Broj poena, ako je unet, mora biti u opsegu od 0 do 100.
    CONSTRAINT CK_Polaganje_kandidat_Broj_Poenta CHECK (Broj_Poenta IS NULL OR Broj_Poenta BETWEEN 0 AND 100),
    -- Ako rezultat nije evidentiran, poeni su NULL; ako jeste, poeni moraju biti uneti.
    CONSTRAINT CK_Polaganje_kandidat_Uspesno_Poeni CHECK (
        (Uspesno IS NULL AND Broj_Poenta IS NULL)
        OR
        (Uspesno IS NOT NULL AND Broj_Poenta IS NOT NULL)
    )
);
GO

-- CREATE INDEX IX_Polaganje_kandidat_Obuka_INCLUDE ON Polaganje_kandidat (Obuka_id) INCLUDE (Polaganje_id, Uspesno, Broj_Poenta);

CREATE TABLE Nadzornici_polaganja (
    Polaganje_id INT NOT NULL CONSTRAINT FK_Nadzornici_Polaganja_Polaganje_Id REFERENCES Polaganje (Id),
    Nadzornik_id INT NOT NULL CONSTRAINT FK_Nadzornici_Polaganja_Nadzornik_Id REFERENCES Zaposleni (Id),
    -- Isti nadzornik ne moze biti dodat na isto polaganje vise puta.
    CONSTRAINT PK_Nadzornici_polaganja PRIMARY KEY (Polaganje_id, Nadzornik_id)
);
GO
