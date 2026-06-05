CREATE TABLE [Polaganje] (
    [Id] UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (newid()),
    [Tip_id] UNIQUEIDENTIFIER NOT NULL,
    [Pocetak] DATETIME2 NOT NULL,
    [Kraj] DATETIME2 NOT NULL,
    [Kreiran_datum] DATETIME2 NOT NULL DEFAULT (getdate()),
    [Izmenjen_datum] DATETIME2
);
GO

CREATE TABLE [Polaganje_kandidat] (
    [Polaganje_id] UNIQUEIDENTIFIER NOT NULL,
    [Obuka_id] UNIQUEIDENTIFIER NOT NULL,
    [Uspesno] BIT,
    [Broj_Poenta] TINYINT
);
GO

CREATE TABLE [Nadzornici_polaganja] (
    [Polaganje_id] UNIQUEIDENTIFIER NOT NULL,
    [Nadzornik_id] UNIQUEIDENTIFIER NOT NULL
);
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'enum: Teorijsko, Prakticno',
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

ALTER TABLE [Polaganje] ADD FOREIGN KEY ([Tip_id]) REFERENCES [Tip_obuke] ([Id]);
GO

ALTER TABLE [Polaganje_kandidat] ADD FOREIGN KEY ([Polaganje_id]) REFERENCES [Polaganje] ([Id]);
GO

ALTER TABLE [Polaganje_kandidat] ADD FOREIGN KEY ([Obuka_id]) REFERENCES [Obuka] ([Id]);
GO

ALTER TABLE [Nadzornici_polaganja] ADD FOREIGN KEY ([Polaganje_id]) REFERENCES [Polaganje] ([Id]);
GO

ALTER TABLE [Nadzornici_polaganja] ADD FOREIGN KEY ([Nadzornik_id]) REFERENCES [Zaposleni] ([Id]);
GO
