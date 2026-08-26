CREATE TABLE Kandidat (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Istek_lekarskog DATE,
    Ime NVARCHAR(50) NOT NULL,
    Ime_roditelja NVARCHAR(50),
    Prezime NVARCHAR(50) NOT NULL,
    JMBG CHAR(13) NOT NULL,
    Istek_licne_karte DATE,
    Telefon NVARCHAR(15) NOT NULL,
    Email NVARCHAR(100),
    Datum_rodjenja DATE NOT NULL,
    Kreiran_datum DATETIME2 NOT NULL
        CONSTRAINT DF_Kandidat_Kreiran_datum DEFAULT (getdate()),
    Izmenjen_datum DATETIME2,
    CONSTRAINT UQ_Kandidat_JMBG UNIQUE (JMBG),
    -- Obavezna tekstualna polja ne smeju biti prazna.
    CONSTRAINT CK_Kandidat_Tekst_Obavezan CHECK (
        LEN(LTRIM(RTRIM(Ime))) > 0
        AND LEN(LTRIM(RTRIM(Prezime))) > 0
        AND LEN(LTRIM(RTRIM(Telefon))) > 0
    ),
    -- Ime i prezime smeju imati samo slova i moraju poceti velikim slovom.
    CONSTRAINT CK_Kandidat_Ime_Prezime_Format CHECK (
        Ime NOT LIKE N'%[^A-Za-zćčšđžĆČŠĐŽ]%'
        AND Ime LIKE N'[A-ZĆČŠĐŽ]%'
        AND Ime NOT LIKE N'% %'
        AND Prezime NOT LIKE N'%[^A-Za-zćčšđžĆČŠĐŽ]%'
        AND Prezime LIKE N'[A-ZĆČŠĐŽ]%'
        AND Prezime NOT LIKE N'% %'
    ),
    -- Opciona tekstualna polja, ako su uneta, ne smeju biti prazna.
    CONSTRAINT CK_Kandidat_Tekst_Optional CHECK (
        (Ime_roditelja IS NULL OR LEN(LTRIM(RTRIM(Ime_roditelja))) > 0)
        AND (Email IS NULL OR LEN(LTRIM(RTRIM(Email))) > 0)
    ),
    -- Email, ako je unet, mora imati osnovni format.
    CONSTRAINT CK_Kandidat_Email_Format CHECK (Email IS NULL OR Email LIKE '%@%.%'),
    -- JMBG sme da ima samo cifre.
    CONSTRAINT CK_Kandidat_JMBG_Format CHECK (JMBG NOT LIKE '%[^0-9]%'),
    -- Datum rodjenja mora biti manji od danasnjeg datuma.
    CONSTRAINT CK_Kandidat_Datum_rodjenja CHECK (Datum_rodjenja < CONVERT(date, getdate()))
);
GO

CREATE TABLE Zaposleni (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Kvalifikacija NVARCHAR(100),
    Aktivni_ugovor BIT NOT NULL
        CONSTRAINT DF_Zaposleni_Aktivni_ugovor DEFAULT (1),
    Ime NVARCHAR(50) NOT NULL,
    Ime_roditelja NVARCHAR(50),
    Prezime NVARCHAR(50) NOT NULL,
    JMBG CHAR(13) NOT NULL,
    Istek_licne_karte DATE,
    Telefon NVARCHAR(15) NOT NULL,
    Email NVARCHAR(100),
    Datum_rodjenja DATE NOT NULL,
    Kreiran_datum DATETIME2 NOT NULL
        CONSTRAINT DF_Zaposleni_Kreiran_datum DEFAULT (getdate()),
    Izmenjen_datum DATETIME2,
    CONSTRAINT UQ_Zaposleni_JMBG UNIQUE (JMBG),
    -- Obavezna tekstualna polja ne smeju biti prazna.
    CONSTRAINT CK_Zaposleni_Tekst_Obavezan CHECK (
        LEN(LTRIM(RTRIM(Ime))) > 0
        AND LEN(LTRIM(RTRIM(Prezime))) > 0
        AND LEN(LTRIM(RTRIM(Telefon))) > 0
    ),
    -- Ime i prezime smeju imati samo slova i moraju poceti velikim slovom.
    CONSTRAINT CK_Zaposleni_Ime_Prezime_Format CHECK (
        Ime NOT LIKE N'%[^A-Za-zćčšđžĆČŠĐŽ]%'
        AND Ime LIKE N'[A-ZĆČŠĐŽ]%'
        AND Ime NOT LIKE N'% %'
        AND Prezime NOT LIKE N'%[^A-Za-zćčšđžĆČŠĐŽ]%'
        AND Prezime LIKE N'[A-ZĆČŠĐŽ]%'
        AND Prezime NOT LIKE N'% %'
    ),
    -- Opciona tekstualna polja, ako su uneta, ne smeju biti prazna.
    CONSTRAINT CK_Zaposleni_Tekst_Optional CHECK (
        (Kvalifikacija IS NULL OR LEN(LTRIM(RTRIM(Kvalifikacija))) > 0)
        AND (Ime_roditelja IS NULL OR LEN(LTRIM(RTRIM(Ime_roditelja))) > 0)
        AND (Email IS NULL OR LEN(LTRIM(RTRIM(Email))) > 0)
    ),
    -- Email, ako je unet, mora imati osnovni format.
    CONSTRAINT CK_Zaposleni_Email_Format CHECK (Email IS NULL OR Email LIKE '%@%.%'),
    -- JMBG sme da ima samo cifre.
    CONSTRAINT CK_Zaposleni_JMBG_Format CHECK (JMBG NOT LIKE '%[^0-9]%'),
    -- Datum rodjenja mora biti manji od danasnjeg datuma.
    CONSTRAINT CK_Zaposleni_Datum_rodjenja CHECK (Datum_rodjenja < CONVERT(date, getdate()))
);
GO

CREATE TABLE Zaposleni_Izostanak (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Zaposleni_id INT NOT NULL CONSTRAINT FK_Zaposleni_Izostanak_Id REFERENCES Zaposleni (Id),
    Tip NVARCHAR(20) NOT NULL,
    Datum_od DATE NOT NULL,
    Datum_do DATE,
    -- Tip izostanka moze biti samo bolovanje ili godisnji odmor.
    CONSTRAINT CK_Zaposleni_Izostanak_Tip CHECK (Tip IN (N'BOL', N'GODISNJI')),
    -- Datum zavrsetka izostanka, ako postoji, ne sme biti pre datuma pocetka.
    CONSTRAINT CK_Zaposleni_Izostanak_Datum CHECK (Datum_do IS NULL OR Datum_do >= Datum_od)
);
GO

CREATE TABLE Funkcije_Zaposlenih (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Ime_funkcije NVARCHAR(50) NOT NULL,
    Minimalna_kvalifikacija NVARCHAR(50),
    Opis NVARCHAR(100),
    -- Tekstualna polja ne smeju biti prazna.
    CONSTRAINT CK_Funkcije_Zaposlenih_Tekst CHECK (
        LEN(LTRIM(RTRIM(Ime_funkcije))) > 0
        AND (Minimalna_kvalifikacija IS NULL OR LEN(LTRIM(RTRIM(Minimalna_kvalifikacija))) > 0)
        AND (Opis IS NULL OR LEN(LTRIM(RTRIM(Opis))) > 0)
    )
);
GO

CREATE TABLE Zaposleni_Funkcija (
    Id_zaposlenog INT NOT NULL CONSTRAINT FK_Zaposleni_Funkcija_Id_zaposlenog REFERENCES Zaposleni (Id),
    Id_funkcije INT NOT NULL CONSTRAINT FK_Zaposleni_Funkcija_Id_funkcije REFERENCES Funkcije_Zaposlenih (Id),
    CONSTRAINT PK_Zaposleni_Funkcija PRIMARY KEY (Id_zaposlenog, Id_funkcije)
);
GO

-- CREATE INDEX IX_Zaposleni_Funkcija_Funkcija_Zaposleni ON Zaposleni_Funkcija (Id_funkcije, Id_zaposlenog);
