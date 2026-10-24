# Phase 5: ER/Data Model - KooBus

**Tarehe:** 2026-10-24  
**Hali:** In Progress  
**Lengo:** Kufafanua muundo wa data wa KooBus ili uendelee na kuunda API na UI kwa usahihi.

## Muhtasari

KooBus inahusika na kufuatilia mabasi ya shule nchini Tanzania. Mfumo huu utasaidia wazazi kufuatilia watoto wao, madereva/kondakta (matron) kusimamia safari, na wasimamizi kusimamia shule, njia, mabasi na watumiaji.

## Entities na Uhusiano

### Core Entities

| Table | Maelezo | Notes |
| --- | --- | --- |
| `users` | Watumiaji wote wa mfumo | `role`: parent, driver, matron, school_admin, super_admin. Inatumia `phone` kama unique, `password` imehashiwa |
| `schools` | Shule zinazotumia KooBus | Shule huweziwa na mabasi na njia |
| `buses` | Mabasi ya shule | Yanahusishwa na shule, yana uwezo (capacity) |
| `routes` | Njia za basi | Kila njia inahusishwa na shule na ina vituo (stops) |
| `route_stops` | Vituo vya kupanda/kushuka | Kuna `stop_order`, lat/lng kwa ajili ya geofencing baadaye |
| `children` | Watoto wanaosafiri | Wanahusishwa na shule na njia |
| `parent_children` | Uhusiano kati ya mzazi na mtoto | `relation`, `is_primary` - wazazi wengi wanaweza kushirikiana |
| `trips` | Safari za basi | Huundwa kwa kila safari (asubuhi/jioni), ina driver na matron |
| `trip_events` | Matukio ya safari | Kupanda (`board`), kushuka (`alight`), kutokufika (`absent`), kuahirishwa (`excused`) - **matron huwekwa kama aliyerekodi** |
| `locations` | GPS ya basi kwa wakati halisi | Inapakiwa na dereva wakati wa safari inayofanyika |
| `notifications` | Arifa kwa watumiaji | Inahusishwa na mtumiaji maalum |
| `device_tokens` | FCM tokens kwa push notifications | Kwa kila kifaa cha mtumiaji |

## ER Diagram (Maelezo)

```text
schools (1)──< (N) buses
schools (1)──< (N) routes
schools (1)──< (N) children
routes  (1)──< (N) route_stops
routes  (1)──< (N) children
routes  (1)──< (N) trips

users (driver) (1)──< (N) trips
users (matron) (1)──< (N) trips (nullable)
buses          (1)──< (N) trips
trips          (1)──< (N) trip_events
trips          (1)──< (N) locations
children       (1)──< (N) trip_events
route_stops    (1)──< (N) trip_events (nullable)
users (recorder)(1)──< (N) trip_events (nullable)

users          (1)──< (N) parent_children
children       (1)──< (N) parent_children
users          (1)──< (N) notifications
users          (1)──< (N) device_tokens
```

## Maamuzi muhimu

- **Matron ni tofauti na Driver** - Kila trip inaweza kuwa na `matron_id` tofauti. `trip_events` inarekodi `recorded_by` ili kujua ni nani alirekodi (matron/driver)
- **parent_children** inaruhusu wazazi wengi kushughulikia mtoto mmoja
- **trip_events.event_type**: `board`, `alight`, `absent`, `excused` - hii itatusaidia na Red Alert ya baadaye
- **locations** inahifadhi historia ya GPS (itatusaidia kuchunguza matatizo baadaye)
- **users.phone** ni unique - tumelinganisha na API iliyorekebishwa

## Post-MVP (Planned) - Tazama FUTURE_UX_IDEAS.md

Majedwali yafuatayo yamepangwa kwa ajili ya Phase 14+:
- `trip_attendance` (kumaliza Red Alert)
- `bus_fees`, `fee_invoices`, `fee_payments`
- `transport_providers`, `transport_requests`
- `school_announcements`, `complaints`

## Checklist ya Phase 5

- [x] Schema ya msingi imetengenezwa katika `Table.php`
- [x] Uhusiano umefafanuliwa
- [x] ERD documentation imeandikwa
- [ ] Kuthibitisha schema inalingana na mahitaji yote ya Flutter (parent/driver flows)
- [ ] Kuongeza indexes muhimu iwapo itahitajika
- [ ] Kupanga API endpoints za core entities
- [ ] Kusasisha CHECKLIST.md kuashiria Phase 5 inavyoendelea

**Kumbuka:** Tunajenga hatua kwa hatua. Schema ya sasa inatosha kwa kuanza na core flows. Tutazidisha tutakapohitaji.
