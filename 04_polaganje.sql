CREATE TABLE Tip_Polaganja (
    Id NVARCHAR(50) PRIMARY KEY,
    Tip NVARCHAR(50) NOT NULL,
    Opis NVARCHAR(255)
);

CREATE TABLE Polaganje (
    Id NVARCHAR(50) PRIMARY KEY,
    Obuka_id NVARCHAR(50),
    Grupa_id NVARCHAR(50),
    Tip_polaganja_id NVARCHAR(50),
    Uspesno BIT,
    Pocetak DATETIME2,
    Kraj DATETIME2,
    FOREIGN KEY (Obuka_id) REFERENCES Obuka(Id),
    FOREIGN KEY (Grupa_id) REFERENCES Grupa(Id),
    FOREIGN KEY (Tip_polaganja_id) REFERENCES Tip_Polaganja(Id)
);

CREATE TABLE Nadzornici_polaganja (
    Polaganje_id NVARCHAR(50),
    Nadzornik_id NVARCHAR(50),
    PRIMARY KEY (Polaganje_id, Nadzornik_id),
    FOREIGN KEY (Polaganje_id) REFERENCES Polaganje(Id),
    FOREIGN KEY (Nadzornik_id) REFERENCES Zaposleni(Id_osobe)
);