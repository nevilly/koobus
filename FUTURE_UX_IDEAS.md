# KooBus — Future UX Ideas & Roadmap (Post-MVP)

> **Purpose:** Hifadhi mawazo haya ili yasahau. Sio lazima yafanyike sasa, lakini ni bora kuyatengenezea mazingira mapema (schema, UI placeholders) ili tukifika muda wa kuzitekeleza zisitusumbue.

**Date:** 2026-10-24  
**Status:** Planning / Backlog  
**Target:** Post-MVP (Phases 14+)

## Muhtasari

Hizi ni features zenye nguvu sana na nyingi zinaweza kuwa selling point ya KooBus. Tunazitengeneza kwa hatua hatua bila kuharibu mtiririko wa Phase 0-13.

---

## 1. Kiashiria cha mwanafunzi asiyeshiriki safari (Red Alert kwa Dereva) - KIPAUMBELE #1

**Tatizo:** Dereva/matron hawajui mapema ni watoto gani hawatashiriki safari leo, hivyo huweza kusimama kituoni bila sababu au kuchelewa.

**Suluhisho:**
- Kwenye skrini ya dereva ya safari inayoendelea, gawanya orodha kuwa "Wanaopanda" na "Hawatafika leo"
- Avatar ya mtoto asiyeingia basi iwe na border nyekundu + alama `!` au label `HATAFIKA`
- Kwenye ramani (baadaye), onyesha pin nyekundu kwenye vituo ambavyo havitashitishwa
- Mzazi au matron anaweza kuashiria mwanafunzi kama "hatafika leo"

**Schema (plaan):**
```sql
trip_attendance (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  trip_id BIGINT NOT NULL,
  child_id BIGINT NOT NULL,
  status ENUM('boarded','alighted','absent','excused') NOT NULL,
  marked_by ENUM('matron','parent','driver') NOT NULL,
  marked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  notes TEXT NULL,
  FOREIGN KEY (trip_id) REFERENCES trips(id),
  FOREIGN KEY (child_id) REFERENCES children(id),
  UNIQUE KEY unique_trip_child (trip_id, child_id)
);
```

**Faida:** Huokoa muda, huongeza usalama, inafanya kazi kwa urahisi.

---

## 2. Malipo ya Ada ya Basi (Installments/Weekly/Full) - KIPAUMBELE #2

**Tatizo:** Familia nyingi nchini Tanzania hazina uwezo wa kulipa ada yote mara moja.

**Suluhisho:**
- Malipo kamili, kwa awamu (2,3,4), au kwa wiki
- Onyesha salio wazi: "Umebaki kulipa TZS X"
- Historia ya malipo na receipt
- Kumbusho la malipo
- Shule ndiyo inaweka bei na kusimamia madeni

**Schema (plaan):**
```sql
bus_fees (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  school_id BIGINT NOT NULL,
  route_id BIGINT NOT NULL,
  amount_full DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'TZS',
  FOREIGN KEY (school_id) REFERENCES schools(id),
  FOREIGN KEY (route_id) REFERENCES routes(id)
);

fee_invoices (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  child_id BIGINT NOT NULL,
  parent_id BIGINT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  paid_amount DECIMAL(10,2) DEFAULT 0,
  balance DECIMAL(10,2) NOT NULL,
  due_date DATE NOT NULL,
  status ENUM('unpaid','partial','paid','overdue') DEFAULT 'unpaid',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (child_id) REFERENCES children(id),
  FOREIGN KEY (parent_id) REFERENCES users(id)
);

fee_payments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  invoice_id BIGINT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  method ENUM('cash','mobile_money','bank','other') NOT NULL,
  reference VARCHAR(100) NULL,
  paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  received_by BIGINT NULL,
  FOREIGN KEY (invoice_id) REFERENCES fee_invoices(id),
  FOREIGN KEY (received_by) REFERENCES users(id)
);
```

**Kumbuka:** Usijenge payment gateway sasa. Tuanze na UI + schema tu. Tukifika hatua hiyo tutachagua mtoa huduma (AzamPay, Selcom, M-Pesa).

---

## 3. Soko la Usafiri Mbadala (Bajaj, Pikipiki, Coaster) - KIPAUMBELE #3

**Tatizo:** Shule zingine hazina basi lao au kuna siku basi halipo.

**Suluhisho:** Sehemu ya "Pata Usafiri Karibu" ambapo wazazi wanaweza kuona madereva wa kibinafsi walio karibu na kuwasiliana nao.

**Kanuni za Usalama:**
- Usajili mkali na uthibitishaji wa hati
- `status: pending/approved/rejected`
- Alama `Imethibitishwa` kwa wale walioidhinishwa
- Upatikanaji `Inapatikana / Haipatikani`
- Anza na Bajaj/Coaster kwanza, kuepuka pikipiki mwanzoni
- Onyesha tu eneo linalofanya kazi
- Ni "backup transport" sio "taxi app"

**Schema (plaan):**
```sql
transport_providers (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  vehicle_type ENUM('bajaj','bodaboda','coaster','pickup','other') NOT NULL,
  plate_no VARCHAR(20) NOT NULL,
  license_no VARCHAR(50) NOT NULL,
  vehicle_photo VARCHAR(255) NULL,
  license_photo VARCHAR(255) NULL,
  verified BOOLEAN DEFAULT FALSE,
  status ENUM('pending','approved','rejected','suspended') DEFAULT 'pending',
  area VARCHAR(100) NOT NULL,
  fare_estimate_min DECIMAL(10,2) NULL,
  fare_estimate_max DECIMAL(10,2) NULL,
  available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

transport_requests (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  parent_id BIGINT NOT NULL,
  child_id BIGINT NOT NULL,
  provider_id BIGINT NOT NULL,
  from_location VARCHAR(255) NOT NULL,
  to_school_id BIGINT NOT NULL,
  status ENUM('pending','accepted','rejected','completed','cancelled') DEFAULT 'pending',
  requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  responded_at TIMESTAMP NULL,
  FOREIGN KEY (parent_id) REFERENCES users(id),
  FOREIGN KEY (child_id) REFERENCES children(id),
  FOREIGN KEY (provider_id) REFERENCES transport_providers(id),
  FOREIGN KEY (to_school_id) REFERENCES schools(id)
);
```

---

## 4. Mawasiliano, SMS & Kupiga Simu - KIPAUMBELE #4

| Feature | Maelezo | Kipaumbele |
| --- | --- | --- |
| **Kupiga simu dereva/matron** | Kitufe cha `Piga simu` kwenye kadi ya basi/mwanafunzi. Tumia `tel:` link. | Juu |
| **SMS fallback kwa simu za kawaida** | Tumia SMS gateway (Africa's Talking, Telerivet). Mfano: *"Mtoto wako [Jina] anakaribia kufika kituoni cha [Mahali]."* au *"Mtoto wako hayuko hewani leo."* | Juu |
| **Ujumbe kutoka shule** | Sehemu `Taarifa za Shule` ndani ya tab ya Taarifa. Aina: `Elimu`, `Ada`, `Matukio`, `Dharura`. | Wastani-Juu |
| **Kuripoti dereva** | Fomu rahisi: Sababu (ucheleweshaji, kuendesha kwa kasi, tabia), maelezo ya hiari. Ipelekwe kwa msimamizi bila kumwonyesha mzazi majibu mara moja. | Wastani |
| **Malalamiko ya wazazi** | Malalamiko ya jumla kuhusu huduma. Mzazi anaweza kufuatilia hali yake. | Wastani |

**Schema (plaan):**
```sql
school_announcements (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  school_id BIGINT NOT NULL,
  title VARCHAR(150) NOT NULL,
  message TEXT NOT NULL,
  type ENUM('education','fees','events','emergency') NOT NULL,
  published_by BIGINT NOT NULL,
  published_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (school_id) REFERENCES schools(id),
  FOREIGN KEY (published_by) REFERENCES users(id)
);

complaints (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  parent_id BIGINT NOT NULL,
  school_id BIGINT NOT NULL,
  driver_id BIGINT NULL,
  trip_id BIGINT NULL,
  type ENUM('driver','service','safety','other') NOT NULL,
  reason VARCHAR(100) NOT NULL,
  description TEXT NULL,
  status ENUM('open','in_progress','resolved','closed') DEFAULT 'open',
  reported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP NULL,
  resolved_by BIGINT NULL,
  FOREIGN KEY (parent_id) REFERENCES users(id),
  FOREIGN KEY (school_id) REFERENCES schools(id),
  FOREIGN KEY (driver_id) REFERENCES users(id),
  FOREIGN KEY (trip_id) REFERENCES trips(id)
);
```

---

## 5. Vipengele Vidogo Vinavyoongeza Thamani

| Kipengele | Maelezo |
| --- | --- |
| **"Mwanafunzi hayuko hewani" notification** | Pale matron anapoashiria `absent`, mzazi apokee arifa mara moja (push au SMS). |
| **Kumbusho la malipo** | Kwenye Nyumbani au Wasifu ionyeshe `Ada haijalipiwa: TZS ...` ikiwa kuna deni. |
| **Historia ya mawasiliano** | Mzazi ajue ujumbe gani umetumwa au alipokea. |
| **Muda wa kusubiri** | Kwa usafiri mbadala, onyesha "Inasubiri uthibitisho". |
| **Wazazi wengi** | Tayari umezingatia hili (waliounganishwa kuchukua watoto) – endeleza na ruhusa wazi. |

---

## Mpangilio wa Utekelezaji

| Hatua | Kazi | Maelezo |
| --- | --- | --- |
| **Hatua 1** | **Ongeza kwenye mpangilio** | Tayari imefanywa - imewekwa kwenye CHECKLIST na FUTURE_UX_IDEAS. |
| **Hatua 2** | **Tengeneza schema ya mustakabali** | Ongeza majedwali haya kwenye ERD wakati wa Phase 5 kama `planned`. |
| **Hatua 3** | **Anza na "Red Alert" kwa dereva** | Inayonufaisha moja kwa moja kwa usalama na rahisi kuunganishwa na `trip_events`. |
| **Hatua 4** | **Malipo + SMS fallback** | Zinongeza matumizi sana kwa wazazi wengi. |
| **Hatua 5** | **Soko la usafiri mbadala** | Fanya baada ya kuwa na watumiaji chache au kama shule zinaiomba. Inahitaji tahadhari zaidi. |

**Kanuni kuu:** Anza kidogo, jaribu, kisha panua. Usijenge yote mara moja.
