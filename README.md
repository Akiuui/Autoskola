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
- Pokrece fajlove za kreiranje tabela, unos test podataka, poglede, funkcije i procedure.

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
- Koristi se za analizu performansi pomocu execution plan-a.
- Uz svaki primer se nalazi komentarisani predlog indeksa i komanda za njegovo uklanjanje.

`08_pogledi.sql`
- Kreira poglede.
- Pogledi postoje da bi se kompleksni JOIN upiti pretvorili u citljive izvestaje.

`09_funkcije.sql`
- Kreira funkcije.
- Funkcije postoje da bi se proracuni koji se ponavljaju izdvojili na jedno mesto.

`10_procedure.sql`
- Kreira procedure sa transakcijama.
- Procedure predstavljaju poslovne operacije, kao sto su upis kandidata na obuku, zakazivanje casa i evidentiranje uplate.

`13_demo_pozivi.sql`
- Sadrzi primere koriscenja pogleda, funkcija i procedura.
- Procedure se u demo delu pokrecu u transakciji koja se na kraju ponistava.
- Ovaj fajl je dodatni demo materijal i nije neophodan za osnovno kreiranje objekata.

## Redosled pokretanja

Preporuceni redosled:

```text
00_master.sql
07_execution_plan_analiza.sql
13_demo_pozivi.sql
```

Objasnjenje redosleda:
- `00_master.sql` redom pokrece fajlove za kreiranje tabela, unos test podataka, poglede, funkcije i procedure.
- `07_execution_plan_analiza.sql` sluzi za prikaz cestih read upita i predloga indeksa na osnovu execution plan-a.
- `13_demo_pozivi.sql` sluzi za demonstraciju rada pogleda, funkcija i procedura.

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
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\07_execution_plan_analiza.sql"
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

Analiza indeksa:
- `07_execution_plan_analiza.sql` sadrzi najcesce read upite i komentarisane predloge indeksa.
- Predlozi indeksa pokrivaju casove po instruktoru i datumu, casove po obuci, obuke po kandidatu i kategoriji, uplate po obuci, uplate po datumu, polaganja po obuci, kandidate po grupi i zaposlene po funkciji.
