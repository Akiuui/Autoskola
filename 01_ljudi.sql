CREATE TABLE Osoba (
    Id NVARCHAR(50) PRIMARY KEY,
    Ime NVARCHAR(100) NOT NULL,
    Ime_roditelja NVARCHAR(100),
    Prezime NVARCHAR(100) NOT NULL,
    JMBG NVARCHAR(13) UNIQUE NOT NULL,
    Telefon NVARCHAR(20),
    Email NVARCHAR(100),
    Datum_rodjenja DATE
);

CREATE TABLE Tip_zaposlenih (
    Id NVARCHAR(50) PRIMARY KEY,
    Tip NVARCHAR(50) NOT NULL,
    Opis NVARCHAR(255)
);

CREATE TABLE Kandidat (
    Id_osobe NVARCHAR(50) PRIMARY KEY,
    Istek_lekarskog DATE,
    Datum_prve_pomoci DATE,
    FOREIGN KEY (Id_osobe) REFERENCES Osoba(Id)
);

CREATE TABLE Zaposleni (
    Id_osobe NVARCHAR(50) PRIMARY KEY,
    Kvalifikacija NVARCHAR(100),
    Aktivni_ugovor BIT NOT NULL DEFAULT 1,
    Tip_zaposlenog_id NVARCHAR(50),
    FOREIGN KEY (Id_osobe) REFERENCES Osoba(Id),
    FOREIGN KEY (Tip_zaposlenog_id) REFERENCES Tip_zaposlenih(Id)
);

CREATE TABLE Zaposleni_status (
    Id NVARCHAR(50) PRIMARY KEY,
    Zaposleni_id NVARCHAR(50),
    Tip NVARCHAR(50), -- BOL, GODISNJI, DOSTUPAN
    Datum_od DATE,
    Datum_do DATE,
    FOREIGN KEY (Zaposleni_id) REFERENCES Zaposleni(Id_osobe)
);