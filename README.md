# Auto skola - baza podataka

Ovaj projekat predstavlja fizicki model baze podataka za auto-skolu.
Baza je organizovana po domenima: ljudi, obuka, casovi, polaganja i finansije.

## Domeni

Ljudi:
- `Kandidat`
- `Zaposleni`
- `Funkcije_Zaposlenih`
- `Zaposleni_Funkcija`
- `Zaposleni_Izostanak`

Obuka:
- `Tip_obuke`
- `Kategorija_vozacke`
- `Grupa`
- `Obuka`
- `Kandidat_grupa`

Casovi i vozila:
- `Vozilo`
- `Cas`

Polaganje:
- `Polaganje`
- `Polaganje_kandidat`
- `Nadzornici_polaganja`

Finansije:
- `Cenovnik`
- `Uplata`

## SQL fajlovi

`00_master.sql`
- Pokrece fajlove za kreiranje tabela.

`01_ljudi.sql`
- Kreira tabele za kandidate, zaposlene, funkcije zaposlenih i izostanke.

`02_obuka.sql`
- Kreira tabele za tipove obuke, kategorije, grupe, obuke i pripadnost kandidata grupi.

`03_casovi.sql`
- Kreira tabele za vozila i casove.

`04_polaganje.sql`
- Kreira tabele za polaganja, rezultate kandidata i nadzornike polaganja.

`05_finansije.sql`
- Kreira tabele za cenovnik i uplate.

`06_test_podaci.sql`
- Popunjava bazu test podacima.
- Podaci su napravljeni tako da se ne unose rucni `Id` identifikatori.
- Skripta je idempotentna, sto znaci da moze da se pokrene vise puta bez dupliranja istih logickih podataka.

`07_execution_plan_analiza.sql`
- Sadrzi najcesce read upite.
- Koristi se za analizu performansi pre i posle dodavanja indeksa.
- Uz svaki primer se nalazi predlog indeksa i komanda za uklanjanje tog indeksa.

`08_pogledi.sql`
- Kreira poglede.
- Pogledi postoje da bi se kompleksni JOIN upiti pretvorili u citljive izvestaje.

`09_funkcije.sql`
- Kreira funkcije.
- Funkcije postoje da bi se proracuni koji se ponavljaju izdvojili na jedno mesto.

`10_procedure.sql`
- Kreira procedure sa transakcijama.
- Procedure predstavljaju poslovne operacije, kao sto su upis kandidata na obuku, zakazivanje casa i evidentiranje uplate.

`11_trigeri.sql`
- Kreira trigere.
- Triggeri automatski azuriraju `Izmenjen_datum` i sprecavaju fizicko brisanje uplata.

`12_indeksi.sql`
- Kreira indekse za optimizaciju najcescih upita.
- Ovaj fajl se pokrece nakon analize u `07_execution_plan_analiza.sql`.

`13_demo_pozivi.sql`
- Sadrzi primere koriscenja pogleda, funkcija i procedura.
- Procedure se u demo delu pokrecu u transakciji koja se na kraju ponistava.

## Redosled pokretanja

Preporuceni redosled:

```text
00_master.sql
06_test_podaci.sql
08_pogledi.sql
09_funkcije.sql
10_procedure.sql
11_trigeri.sql
07_execution_plan_analiza.sql
12_indeksi.sql
07_execution_plan_analiza.sql
13_demo_pozivi.sql
```

Objasnjenje redosleda:
- Prvo se kreiraju tabele.
- Zatim se unose test podaci.
- Nakon toga se kreiraju pogledi, funkcije, procedure i triggeri.
- `07_execution_plan_analiza.sql` se pokrece pre indeksa da bi se videlo pocetno stanje performansi.
- `12_indeksi.sql` kreira indekse.
- `07_execution_plan_analiza.sql` se zatim pokrece ponovo radi poredjenja.
- `13_demo_pozivi.sql` sluzi za demonstraciju rada objekata.

## Pokretanje u SQL Server Management Studio

1. Otvoriti SQL Server Management Studio.
2. Povezati se na SQL Server instancu, na primer:
   - `.\SQLEXPRESS`
   - `localhost\SQLEXPRESS`
3. Kreirati novu bazu:

```sql
CREATE DATABASE Autoskola;
GO
USE Autoskola;
GO
```

4. Otvoriti i pokrenuti fajlove redom iz sekcije `Redosled pokretanja`.
5. Za analizu indeksa ukljuciti Actual Execution Plan pomocu `Ctrl + M`.

## Pokretanje preko sqlcmd

```powershell
sqlcmd -S ".\SQLEXPRESS" -E -Q "CREATE DATABASE Autoskola"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\00_master.sql"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\06_test_podaci.sql"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\08_pogledi.sql"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\09_funkcije.sql"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\10_procedure.sql"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\11_trigeri.sql"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\12_indeksi.sql"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\13_demo_pozivi.sql"
```

Ako baza vec postoji i zelite ponovno kreiranje od nule, prvo je obrisati ili koristiti drugo ime baze.

## Objasnjenje dodatih objekata

Pogledi:
- `vw_Kandidati_Obuke`: pregled kandidata i njihovih obuka.
- `vw_Raspored_Casova`: pregled rasporeda casova sa instruktorima, kandidatima i vozilima.
- `vw_Uplate_Po_Obuci`: finansijski pregled uplata po obuci.
- `vw_Rezultati_Polaganja`: pregled rezultata polaganja.
- `vw_Zaposleni_Funkcije`: pregled zaposlenih i njihovih funkcija.
- `vw_Stanje_Obuke`: kontrolni pregled obuke, broja casova, polaganja i uplata.

Funkcije:
- `fn_UkupnoUplacenoZaObuku`: sabira uplate za jednu obuku.
- `fn_BrojCasovaZaObuku`: vraca broj casova za obuku.
- `fn_BrojPolaganjaZaObuku`: vraca broj polaganja za obuku.
- `fn_KandidatImaAktivnuObuku`: proverava da li kandidat vec ima aktivnu obuku za kategoriju.
- `fn_RasporedInstruktora`: vraca raspored instruktora za zadati period.

Procedure:
- `usp_UpisKandidataNaObuku`: upisuje kandidata na obuku i opciono u grupu.
- `usp_ZakaziPrakticniCas`: zakazuje prakticni cas uz provere zauzetosti.
- `usp_EvidentirajUplatu`: evidentira uplatu.
- `usp_PrijaviKandidataNaPolaganje`: prijavljuje obuku na polaganje.
- `usp_EvidentirajRezultatPolaganja`: upisuje rezultat polaganja.

Triggeri:
- `trg_Kandidat_SetIzmenjenDatum`
- `trg_Zaposleni_SetIzmenjenDatum`
- `trg_Obuka_SetIzmenjenDatum`
- `trg_Vozilo_SetIzmenjenDatum`
- `trg_Cas_SetIzmenjenDatum`
- `trg_Polaganje_SetIzmenjenDatum`
- `trg_Uplata_SetIzmenjenDatum`
- `trg_Uplata_ZabraniBrisanje`

Indeksi:
- Indeksi su dodati za najcesce nacine citanja: casovi po instruktoru i datumu, casovi po obuci, obuke po kandidatu i kategoriji, uplate po obuci, uplate po datumu, polaganja po obuci, kandidati po grupi i zaposleni po funkciji.
