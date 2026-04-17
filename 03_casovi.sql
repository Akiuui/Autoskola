CREATE TABLE Vozilo (
    Id NVARCHAR(50) PRIMARY KEY,
    Registracija NVARCHAR(20) UNIQUE NOT NULL,
    Marka NVARCHAR(50),
    Model NVARCHAR(50),
    Godiste INT,
    Kategorija_id NVARCHAR(50),
    Kilometraza INT,
    Datum_registracije DATE,
    FOREIGN KEY (Kategorija_id) REFERENCES Kategorija_vozacke(Id)
);

CREATE TABLE Cas (
    Id NVARCHAR(50) PRIMARY KEY,
    Instruktor_id NVARCHAR(50),
    Datum DATE,
    Pocetak DATETIME2,
    Kraj DATETIME2,
    FOREIGN KEY (Instruktor_id) REFERENCES Zaposleni(Id_osobe)
);

CREATE TABLE Prakticni_cas (
    Cas_id NVARCHAR(50) PRIMARY KEY,
    Kandidat_id NVARCHAR(50),
    Vozilo_id NVARCHAR(50),
    FOREIGN KEY (Cas_id) REFERENCES Cas(Id),
    FOREIGN KEY (Kandidat_id) REFERENCES Kandidat(Id_osobe),
    FOREIGN KEY (Vozilo_id) REFERENCES Vozilo(Id)
);

CREATE TABLE Teorijski_cas (
    Cas_id NVARCHAR(50) PRIMARY KEY,
    Grupa_id NVARCHAR(50),
    FOREIGN KEY (Cas_id) REFERENCES Cas(Id),
    FOREIGN KEY (Grupa_id) REFERENCES Grupa(Id)
);