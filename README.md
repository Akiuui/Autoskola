Domeni:

Ljudi: kandidati, zaposleni, funkcije i izostanci
 - Kandidat, Zaposleni, Funkcije_Zaposlenih, Zaposleni_Funkcija, Zaposleni_Izostanak

Obuka: kategorije, tipovi obuke, aktivne obuke i grupe
 - Obuka, Tip_obuke, Kategorija_vozacke, Grupa, Kandidat_grupa

Casovi i vozila: raspored, evidencija casova i vozila
 - Cas, Vozilo

Polaganje: ispiti, rezultati kandidata i nadzornici
 - Polaganje, Polaganje_kandidat, Nadzornici_polaganja

Finansije: cenovnik i uplate za obuke
 - Cenovnik, Uplata

Pokretanje baze u MS SQL Server-u:

1. Otvoriti SQL Server Management Studio.
2. Povezati se na SQL Server instancu, na primer:
   - .\SQLEXPRESS
   - localhost\SQLEXPRESS
3. Kreirati novu bazu, na primer:

```sql
CREATE DATABASE Autoskola;
GO
USE Autoskola;
GO
```

4. U SSMS-u otvoriti fajl `00_master.sql`.
5. Uveriti se da je aktivna baza `Autoskola`.
6. Pokrenuti `00_master.sql` da se kreiraju sve tabele.
7. Nakon toga, opciono pokrenuti `06_test_podaci.sql` za unos test podataka.

Pokretanje preko sqlcmd-a:

```powershell
sqlcmd -S ".\SQLEXPRESS" -E -Q "CREATE DATABASE Autoskola"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\00_master.sql"
sqlcmd -S ".\SQLEXPRESS" -E -d Autoskola -i "D:\Projekti\Autoskola\06_test_podaci.sql"
```

Ako baza vec postoji i zelite ponovno kreiranje od nule, prvo je obrisati ili koristiti drugo ime baze.
