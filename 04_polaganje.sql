CREATE TABLE [Polaganje] (
    -- Identifikator polaganja se automatski generise.
    [Id] UNIQUEIDENTIFIER NOT NULL CONSTRAINT [DF_Polaganje_Id] DEFAULT (newid()),
    [Tip_id] UNIQUEIDENTIFIER NOT NULL,
    [Pocetak] DATETIME2 NOT NULL,
    [Kraj] DATETIME2 NOT NULL,
    -- Datum kreiranja polaganja se automatski postavlja pri unosu.
    [Kreiran_datum] DATETIME2 NOT NULL CONSTRAINT [DF_Polaganje_Kreiran_datum] DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2,
    -- Svako polaganje mora imati jedinstven identifikator.
    CONSTRAINT [PK_Polaganje] PRIMARY KEY ([Id]),
    -- Vreme zavrsetka polaganja mora biti posle vremena pocetka.
    CONSTRAINT [CK_Polaganje_Vreme] CHECK ([Kraj] > [Pocetak])
);
GO

CREATE TABLE [Polaganje_kandidat] (
    [Polaganje_id] UNIQUEIDENTIFIER NOT NULL,
    [Obuka_id] UNIQUEIDENTIFIER NOT NULL,
    [Uspesno] BIT,
    [Broj_Poenta] TINYINT,
    -- Ista obuka ne moze biti prijavljena na isto polaganje vise puta.
    CONSTRAINT [PK_Polaganje_kandidat] PRIMARY KEY ([Polaganje_id], [Obuka_id]),
    -- Broj poena, ako je unet, mora biti u opsegu od 0 do 100.
    CONSTRAINT [CK_Polaganje_kandidat_Broj_Poenta] CHECK ([Broj_Poenta] IS NULL OR [Broj_Poenta] BETWEEN 0 AND 100),
    -- Ako rezultat nije evidentiran, poeni su NULL; ako jeste, poeni moraju biti uneti.
    CONSTRAINT [CK_Polaganje_kandidat_Uspesno_Poeni] CHECK (
        ([Uspesno] IS NULL AND [Broj_Poenta] IS NULL)
        OR
        ([Uspesno] IS NOT NULL AND [Broj_Poenta] IS NOT NULL)
    )
);
GO

CREATE TABLE [Nadzornici_polaganja] (
    [Polaganje_id] UNIQUEIDENTIFIER NOT NULL,
    [Nadzornik_id] UNIQUEIDENTIFIER NOT NULL,
    -- Isti nadzornik ne moze biti dodat na isto polaganje vise puta.
    CONSTRAINT [PK_Nadzornici_polaganja] PRIMARY KEY ([Polaganje_id], [Nadzornik_id])
);
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Tip polaganja je povezan sa Tip_obuke.Id; dozvoljeni tipovi su definisani u Tip_obuke.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Polaganje',
@level2type = N'Column', @level2name = 'Tip_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'null = nije odrzano, 1 = polozio, 0 = nije polozio',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Polaganje_kandidat',
@level2type = N'Column', @level2name = 'Uspesno';
GO

ALTER TABLE [Polaganje]
ADD CONSTRAINT [FK_Polaganje_Tip_obuke]
-- Polaganje mora imati postojeci tip obuke/polaganja.
FOREIGN KEY ([Tip_id]) REFERENCES [Tip_obuke] ([Id]);
GO

ALTER TABLE [Polaganje_kandidat]
ADD CONSTRAINT [FK_Polaganje_kandidat_Polaganje]
-- Rezultat kandidata mora biti vezan za postojece polaganje.
FOREIGN KEY ([Polaganje_id]) REFERENCES [Polaganje] ([Id]);
GO

ALTER TABLE [Polaganje_kandidat]
ADD CONSTRAINT [FK_Polaganje_kandidat_Obuka]
-- Rezultat kandidata mora biti vezan za postojecu obuku.
FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id]);
GO

ALTER TABLE [Nadzornici_polaganja]
ADD CONSTRAINT [FK_Nadzornici_polaganja_Polaganje]
-- Nadzornik mora biti vezan za postojece polaganje.
FOREIGN KEY ([Polaganje_id]) REFERENCES [Polaganje] ([Id]);
GO

ALTER TABLE [Nadzornici_polaganja]
ADD CONSTRAINT [FK_Nadzornici_polaganja_Zaposleni]
-- Nadzornik polaganja mora biti postojeci zaposleni.
FOREIGN KEY ([Nadzornik_id]) REFERENCES [Zaposleni] ([Id]);
GO
