CREATE TABLE Usluga (
    Id NVARCHAR(50) PRIMARY KEY,
    Naziv NVARCHAR(100) NOT NULL,
    Opis NVARCHAR(255)
);

CREATE TABLE Cenovnik (
    Id NVARCHAR(50) PRIMARY KEY,
    Usluga_id NVARCHAR(50),
    Cena DECIMAL(10,2) NOT NULL,
    Datum_od DATE NOT NULL,
    Datum_do DATE,
    FOREIGN KEY (Usluga_id) REFERENCES Usluga(Id)
);

CREATE TABLE Nacin_placanja (
    Id NVARCHAR(50) PRIMARY KEY,
    Naziv NVARCHAR(50) NOT NULL
);

CREATE TABLE Uplata (
    Id NVARCHAR(50) PRIMARY KEY,
    Kandidat_id NVARCHAR(50),
    Cenovnik_id NVARCHAR(50),
    Obuka_id NVARCHAR(50),
    Iznos DECIMAL(10,2) NOT NULL,
    Datum DATE NOT NULL,
    Nacin_placanja_id NVARCHAR(50),
    FOREIGN KEY (Kandidat_id) REFERENCES Kandidat(Id_osobe),
    FOREIGN KEY (Cenovnik_id) REFERENCES Cenovnik(Id),
    FOREIGN KEY (Obuka_id) REFERENCES Obuka(Id),
    FOREIGN KEY (Nacin_placanja_id) REFERENCES Nacin_placanja(Id)
);