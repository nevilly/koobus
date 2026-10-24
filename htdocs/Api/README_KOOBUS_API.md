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

## Kusakinisha ndani ya XAMPP baadaye

1. Weka folder `htdocs/Api` ndani ya `xampp/htdocs/`
2. Badilisha `.rd` kulingana na mazingira yako ya local (DB_USER, DB_PASS n.k)
3. Fungua browser: `http://localhost/Api/api/v1/install` au piga `Table.php` moja kwa moja ili kuunda tables
4. Hakikisha `.htaccess` inafanya kazi (mod_rewrite imewashwa)

## Maelezo ya KOO_BUS_ADAPT

Kila badiliko ambalo limefanywa ili kukifanya kiendane na KooBus limewekwa alama `// KOO_BUS_ADAPT:` ili iwe rahisi kufuatilia.

**Tarehe ya kurekebishwa:** 2026-10-24
