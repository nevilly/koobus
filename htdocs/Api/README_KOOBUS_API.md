# KooBus PHP API (htdocs/Api/api/v1)

Hii API inatumia muundo wa **Routes → Controller → Module → Database**.

## Muundo wa Faili

```text
api/v1/
├── index.php        # Entry point
├── Config.php       # Router - inachambua URL na ku-load Route inayofaa
├── .htaccess        # URL rewriting kwenda index.php
├── .rd              # Env config (DB, SECRET, MAIL, FCM) - usiweke secrets kwenye repo
├── Session.php      # Session/Cookie handling
├── Table.php        # Schema installer (huunda tables za KooBus)
│
├── Routes/          # Route handlers (HTTP method validation + ku-call controller)
├── Controller/      # Business logic kati ya Routes na Module
├── Module/          # Database layer (huunda SQL, hu-call Database base class)
├── HTTP/            # HTTP response, headers, CORS, JSON helpers
├── Util/            # Helpers (Token/JWT-like, Hash, Mailer, File upload, etc)
└── PHPMailer/       # Mailer library
```

## Jinsi inavyofanya kazi

1. `index.php` -> `Config.php`
2. `Config.php` inachambua `$_SERVER['REQUEST_URI']` na kuamua `Route`, `Route1`, `Route2`, ...
3. Kama kuna `Routes/{Route}.php`, hu-load na kuunda instance ya class hiyo
4. Inaitwa method kulingana na `Route2` (k.m `login`, `user`, `add`) au params
5. `Routes/*` hutumia `Controller/*` ambayo hutumia `Module/*` inayoongezeka na `Database.php`
6. `HTTP::response()` hurudisha JSON

## Routes muhimu kwa KooBus (mpango)

| Route | Njia | Maelezo |
| --- | --- | --- |
| `Users` | `POST /api/v1/users/login` au kulingana na routing | Login kwa parent/driver/matron/school_admin/super_admin |
| `Users` | `POST /api/v1/users/add` / `register` | Kusajili mtumiaji (kwa sasa tunarekebisha) |
| `Users` | `GET /api/v1/users/user` | Profile ya mtumiaji aliye-login (hutumia token `Owesis ...`) |
| `Users` | `PUT /api/v1/users/update` | Kusasisha profile |

## Auth

- Token hutolewa na `Util::generateToken()` na kufichwa na `Util::encrypt_decrypt()`
- Hutumwa kwenye header kama: `Authorization: Owesis <encrypted_token>`
- `Util::getToken()` na `Util::tokenValidate()` hutumika kuthibitisha

## Kusakinisha kwenye XAMPP (Windows)

### Mahali sahihi (muhimu)

PHP API inatafuta modules kwa `$_SERVER["DOCUMENT_ROOT"] . "/api/v1/..."`.
Kwa hiyo hamisha **yaliyomo ndani ya `htdocs/Api/api`** kwenda
`C:\xampp\htdocs\api`, na `htdocs/Api/public` kwenda
`C:\xampp\htdocs\public`:

```text
htdocs/Api/api      -> C:\xampp\htdocs\api
htdocs/Api/public   -> C:\xampp\htdocs\public
```

**Usihamishie `htdocs/Api` yote kwenda `C:\xampp\htdocs\Api`.**
Hiyo itaweka API kwenye `/Api/api/v1/...`, wakati includes zinatafuta
`/api/v1/...`; API itashindikana kupata `Module/Database.php`.

### Njia A: script ya sync (inapendekezwa)

Baada ya kila badiliko kwenye repo:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\deploy-xampp.ps1
```

Script inasafirisha `api` na `public` kwenda XAMPP. `.rd` ya XAMPP
haiyaguzwi baada ya kuundwa mara ya kwanza.

Kama unataka target ifanane kabisa na source (files za ziada zinafutwa):

```powershell
powershell -ExecutionPolicy Bypass -File scripts\deploy-xampp.ps1 -Mirror
```

### Njia B: directory junction (dev ya haraka)

Hii inafanya `C:\xampp\htdocs\api` ionekane kama folder ya repo; hakuna
copy baada ya kila badiliko:

```powershell
# Kama folder ipo, ihifadhi/iondoe kwanza
if (Test-Path C:\xampp\htdocs\api) {
    Rename-Item C:\xampp\htdocs\api "api_backup_$(Get-Date -Format yyyyMMdd_HHmmss)"
}

cmd /c mklink /J C:\xampp\htdocs\api "C:\Users\dell\Desktop\mApp\koob\koobus\htdocs\Api\api"
cmd /c mklink /J C:\xampp\htdocs\public "C:\Users\dell\Desktop\mApp\koob\koobus\htdocs\Api\public"
```

Junction inafanya kazi kwa sababu XAMPP `httpd.conf` ina
`Options Indexes FollowSymLinks` na `AllowOverride All`.

### Njia C: copy ya mkono

```powershell
Copy-Item -Recurse -Force .\htdocs\Api\api    C:\xampp\htdocs\api
Copy-Item -Recurse -Force .\htdocs\Api\public C:\xampp\htdocs\public
```

### Database na install

1. Fungua XAMPP Control Panel; washa **Apache** na **MySQL**.
2. Kwenye mashine hii Apache tayari amewekwa `Listen 8080` na
   `ServerName localhost:8080`, kwa sababu port 80 inamilikiwa na
   `ReportServer$SQLEXPRESS`. Tumia URL zenye `:8080`. Kama unabadilisha
   kwenda port 80, zima service ya SSRS kwanza au badilisha `httpd.conf`
   (`Listen` na `ServerName`) kwa usawa.
3. Unda database `koobuss` (au badilisha `DB:` kwenye `.rd`):
   ```sql
   CREATE DATABASE IF NOT EXISTS koobuss
     CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
4. Hariri `C:\xampp\htdocs\api\v1\.rd`:
   - `DB_USER`, `DB_PASS`, `DB_HOST`, `DB_PORT`, `DB`
   - `APP_ENV: development` (kwa dev) au `APP_ENV: production`
   - `SECRET: <random>`
5. Fungua `http://localhost:8080/api/v1/install` (kama Apache ni port 80,
   tumia `http://localhost/api/v1/install`).
   Unapaswa kuona: `KooBus tables installed/checked successfully!`
6. Jaribio la haraka: `http://localhost:8080/api/v1/doesnotexist` inapaswa
   kurudisha JSON `{"status":403,...}`, si HTML ya 404.
7. Bootstrap ya super_admin wa kwanza (mara moja tu, kabla ya
   super_admin mwingine kuwepo):
   ```powershell
   $body = @{
     role='super_admin'; first_name='Koo'; last_name='Admin'
     username='superadmin'; phone='255700000001'
     password='BadilishaHii123'; email='admin@koobus.local'
   } | ConvertTo-Json

   Invoke-RestMethod -Uri 'http://localhost:8080/api/v1/users/add' `
     -Method Post -ContentType 'application/json' -Body $body
   ```

### Hali ya deployment ya sasa (2026-10-25)

- Apache 2.4.56 kwenye port 8080, MySQL 3306, database `koobuss`.
- `install`, `login` na `users/user` zimejaribiwa kupitia Apache halisi.
- Phase 8 live matrix imepita: `pending -> active`, `active -> completed`,
  `pending -> cancelled`, `409` kwa trip ya pili inayoendelea, `409` kwa
  transition batili, na `403` kwa parent/matron/dereva mwingine.
- Data ya majaribio (shule, dereva, basi, route, stops, trips) ipo kwenye
  database ya local. Kabla ya kutumia kwa watu wa kweli, safisha data hii,
  badilisha nenosiri la super_admin, na weka `APP_ENV: production` pamoja
  na `SECRET` halisi.

### URL ya app (Flutter)

```text
Windows/web/desktop : http://localhost:8080/api/v1
Android emulator    : http://10.0.2.2:8080/api/v1
Simu halisi (LAN)   : http://<IP-ya-PC>:8080/api/v1
```

Mfano:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1
```

Kwa simu halisi, PC na simu lazima ziwe kwenye Wi-Fi moja, na Windows
Firewall iruhusu Apache (port 80/8080). Debug build inaruhusu HTTP;
release itahitaji HTTPS.

### Kanuni ya update

- Repo (`koobus`) ndiyo source of truth; usiedit code moja kwa moja
  kwenye `C:\xampp\htdocs` kwa muda mrefu.
- Badilisha repo -> run sync/junction -> test XAMPP -> commit/push.
- `.rd` ya XAMPP ina credentials za local; usiweke production secrets
  kwenye repo.

## Maelezo ya KOO_BUS_ADAPT

Kila badiliko ambalo limefanywa ili kukifanya kiendane na KooBus limewekwa alama `// KOO_BUS_ADAPT:` ili iwe rahisi kufuatilia.

**Tarehe ya kurekebishwa:** 2026-10-24
