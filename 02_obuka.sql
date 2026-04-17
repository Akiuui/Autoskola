CREATE TABLE Kategorija_vozacke (
    Id NVARCHAR(50) PRIMARY KEY,
    Oznaka CHAR(5) NOT NULL,
    Opis NVARCHAR(255)
);

CREATE TABLE Obuka (
    Id NVARCHAR(50) PRIMARY KEY,
    Kandidat_id NVARCHAR(50),
    Kategorija_id NVARCHAR(50),
    Teorijski_instruktor_id NVARCHAR(50),
    Prakticni_instruktor_id NVARCHAR(50),
    Datum_pocetka DATE,
    Datum_zavrsetka DATE,
    Status NVARCHAR(50),
    FOREIGN KEY (Kandidat_id) REFERENCES Kandidat(Id_osobe),
    FOREIGN KEY (Kategorija_id) REFERENCES Kategorija_vozacke(Id),
    FOREIGN KEY (Teorijski_instruktor_id) REFERENCES Zaposleni(Id_osobe),
    FOREIGN KEY (Prakticni_instruktor_id) REFERENCES Zaposleni(Id_osobe)
);

CREATE TABLE Grupa (
    Id NVARCHAR(50) PRIMARY KEY,
    Tip NVARCHAR(50),
    Datum_kreiranja DATE,
    Datum_zavrsetka DATE
);

CREATE TABLE Grupa_kandidat (
    Grupa_id NVARCHAR(50),
    Kandidat_id NVARCHAR(50),
    PRIMARY KEY (Grupa_id, Kandidat_id),
    FOREIGN KEY (Grupa_id) REFERENCES Grupa(Id),
    FOREIGN KEY (Kandidat_id) REFERENCES Kandidat(Id_osobe)
);