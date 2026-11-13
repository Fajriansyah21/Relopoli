Siap. Berikut versi **Markdown** dari **Relopoli News Final Review** yang bisa langsung kamu simpan sebagai dokumentasi. Isinya aku pertahankan sesuai hasil review sebelumnya.  

````markdown
# 📰 RELOPOLI NEWS — FINAL REVIEW

> Status: **FINAL REVIEW**
>
> Total News: **30**
>
> Tujuan: memastikan seluruh News memiliki efek, tipe, durasi, fallback, dan interaksi yang jelas.

---

# 1. Struktur News

| Kategori | Jumlah | Status |
|---|---:|---|
| 🍀 Luck | 11 | Reviewed |
| ⚠️ Bad | 11 | Reviewed |
| ⭐ Special | 8 | Reviewed |
| **TOTAL** | **30** | **Reviewed** |

---

# 2. 🍀 LUCK NEWS

## 2.1 City Bonus 💰

**Tipe:** Instant

Player langsung mendapatkan:

> **+25.000 Rels**

News tidak masuk Inventory.

---

## 2.2 Free Property Permit 🎟️

**Tipe:** Instant

Player memperoleh hak untuk mendapatkan **1 Property L1–L3 secara gratis** ketika melakukan pembelian Property yang memenuhi syarat.

- L1/L2/L3 → bisa digunakan.
- L4/L5 → tidak bisa digunakan untuk initial purchase.
- Efek tetap tersedia sampai digunakan.
- Setelah transaksi berhasil → efek habis.

---

## 2.3 Lucky Steps 👟

**Tipe:** Instant

Setelah Roll normal, player mendapat:

> **+3 langkah**

Aturan:

- Tidak mengubah nilai dadu.
- Double tetap Double.
- Triple Double tetap Triple Double.
- Movement Engine tetap digunakan.
- Crossing Start tetap dihitung.
- Tidak digunakan saat Jail.

---

## 2.4 Land Grant 🏠

**Tipe:** Instant

Sistem memilih **1 Unowned Property secara random**.

- Property diberikan pada L1.
- Player tidak memilih.
- Crown tidak termasuk.
- Jika semua Property sudah dimiliki:
  > **+15.000 Rels**

---

## 2.5 Premium Listing 📈

**Tipe:** Instant

Sistem random memilih **1 Property milik player**.

Efek:

> **+50% Rent selama 3 putaran**

Berlaku untuk L1–L5.

---

## 2.6 Express Route 🚍

**Tipe:** Instant

News mengantarkan player ke:

> **Tile 30 — Transport**

Alur:

```text
News
 ↓
Movement Engine
 ↓
Tile 30
 ↓
Turn selesai
````

Transport baru aktif pada **turn berikutnya**.

---

## 2.7 Golden Pass 🎟️

**Tipe:** Instant

News mengantarkan player ke:

> **Tile 20 — Reward**

Reward tidak langsung aktif pada turn tersebut.

Reward aktif pada **turn berikutnya**.

---

## 2.8 Crown Prosperity 👑

**Tipe:** Instant

Jika player memiliki Crown:

* Sistem random memilih **1 Crown**.
* Crown mendapat:

  > **+2.000 Rels Crown Reward**
* Durasi:

  > **3 putaran**

Jika player tidak memiliki Crown:

> **+15.000 Rels**

---

## 2.9 Special Discount 🏷️

**Tipe:** Instant

Player mendapat:

> **50% Discount**

Berlaku untuk:

* Pembelian Property.
* Upgrade Property.

Hanya untuk:

> **1 transaksi**

Efek tidak expired.

Jika belum digunakan:

> Tetap tersedia sampai digunakan.

---

## 2.10 Generous Neighbor 🤝

**Tipe:** Instant

Sistem random memilih **1 player lain**.

Nominal random:

> **10.000–70.000 Rels**

Uang diambil dari player tersebut.

Jika saldo tidak cukup:

> Bayar sesuai kemampuan.

Tidak menyebabkan negative balance.

---

## 2.11 Roll Again 🎲

**Tipe:** Stored

Player melakukan Roll normal.

Setelah melihat hasil:

* Gunakan hasil Roll pertama, atau
* Pilih **Roll Again**.

Jika Roll Again digunakan:

> Roll kedua wajib digunakan.

Kedua Roll tidak dijumlahkan.

News habis setelah digunakan.

---

# 3. ⚠️ BAD NEWS

> **Seluruh Bad News bersifat Instant.**

---

## 3.1 Market Loss 📉

**Tipe:** Instant

Nominal random:

> **30.000–150.000 Rels**

Uang masuk Bank.

Jika saldo tidak cukup:

> Balance boleh menjadi negative.

---

## 3.2 Traffic Jam 🚗

**Tipe:** Instant → efek aktif turn berikutnya

Saat mendapat News:

> Turn selesai.

Pada turn berikutnya:

> **Movement maksimal 5 tile**

Contoh:

| Roll | Movement |
| ---: | -------: |
|    3 |        3 |
|    5 |        5 |
|    8 |        5 |
|   12 |        5 |

Setelah turn tersebut:

> Traffic Jam selesai.

---

## 3.3 Jail Notice 🔒

**Tipe:** Instant

Player langsung dikirim ke Jail.

Movement Engine menentukan jalur terdekat.

Jika jarak depan dan belakang sama:

> **Prioritas Forward.**

Jika melewati Start:

> Pass Start tetap dihitung.

Setelah sampai:

> Player menjadi Jailed.

Turn selesai.

---

## 3.4 Property Detour 🏠

**Tipe:** Instant

Sistem random memilih:

> **1 Property milik player lain**

Player dipindahkan menggunakan Movement Engine.

Jika jarak sama:

> Forward.

Setelah sampai:

> **Landing Resolution normal.**

Jika tidak ada Property milik player lain:

> Tidak terjadi apa-apa → turn selesai.

---

## 3.5 Crown Disruption 👑⚠️

**Tipe:** Instant

Semua Crown milik player terkena Disruption.

Setiap Crown:

> Kehilangan Crown Reward berikutnya.

Untuk mengaktifkan kembali:

> Player harus menginjak Tile Crown tersebut.

Jika memiliki beberapa Crown:

> Setiap Crown harus diinjak satu per satu.

Crown tetap dihitung untuk Crown Victory.

---

## 3.6 Property Damage 💥

**Tipe:** Instant

Random memilih 1 Property.

| Level | Hasil             |
| ----- | ----------------- |
| L1    | Unowned           |
| L2    | Unowned           |
| L3    | L1                |
| L4    | L2                |
| L5    | Tidak terpengaruh |

L5 kebal.

Jika player tidak memiliki Property:

> Tidak terjadi apa-apa → turn selesai.

---

## 3.7 Construction Setback 🏗️

**Tipe:** Instant

Property random turun **tepat 1 level**.

| Level | Hasil   |
| ----- | ------- |
| L5    | L4      |
| L4    | L3      |
| L3    | L2      |
| L2    | L1      |
| L1    | Unowned |

Jika player tidak memiliki Property:

> Tidak terjadi apa-apa → turn selesai.

---

## 3.8 Falling Demand 📉🏠

**Tipe:** Instant

Sistem random memilih:

> **1–3 Property**

Property terpilih:

> **Rent −50%**

Durasi:

> **3 putaran**

Jika player memiliki kurang dari 3 Property:

> Hanya Property yang tersedia yang dipilih.

Jika tidak memiliki Property:

> Tidak terjadi apa-apa.

---

## 3.9 Forced Break ⏸️

**Tipe:** Instant

Turn saat mendapatkan News:

> Selesai.

Turn berikutnya:

* Tidak Roll.
* Tidak Movement.
* Tidak Fast Travel.
* Turn dilewati.

Setelah itu:

> Player kembali normal.

---

## 3.10 City Levy 🏙️💸

**Tipe:** Instant

Sistem mengambil:

> **25% balance player**

Nominal menggunakan kelipatan:

> **500 Rels**

Kemudian dibagi kepada:

* Semua player lain.
* Bank.

Player lain mendapat bagian yang sama.

Jika ada sisa:

> **Sisa masuk Bank.**

---

## 3.11 Property Slump 🏠🔒

**Tipe:** Instant

Semua Property milik player menjadi:

> **Inactive**

Selama Inactive:

> **Rent = 0**

Tidak memiliki timer.

Property tetap:

* Dimiliki.
* Mempertahankan level.
* Bisa dipulihkan.

### Reactivation

Siapa pun menginjak Property:

> Rent = 0 untuk landing tersebut
> → Property kembali Active.

Setiap Property dipulihkan:

> **Satu per satu.**

---

# 4. ⭐ SPECIAL NEWS

## 4.1 Jail Break 🔓

**Tipe:** Stored

Saat Jailed:

> Inventory → **Jalan Keluar**

Player menekan tombol.

Kemudian:

```text
News dikonsumsi
 ↓
Jail dilepas
 ↓
Physical Dice Roll
 ↓
Movement Engine
 ↓
Landing Resolution
 ↓
Turn selesai
```

Saat tidak Jail:

> News tidak dapat digunakan.

---

## 4.2 Property Seizure 🏠

**Tipe:** Stored

Player memilih:

> **1 Property milik player lain**

Property:

* Langsung berpindah ownership.
* Level tetap.
* Modifier/buff tetap.
* Negative modifier tetap.
* Semua status melekat ikut berpindah.

Crown tidak dapat disita.

---

## 4.3 Instant Upgrade ⬆️

**Tipe:** Stored

Player memilih:

> **1 Property miliknya**

Property naik:

> **+1 Level gratis**

Progression:

```text
L1 → L2
L2 → L3
L3 → L4
L4 → L5
```

L5 tidak dapat dipilih.

Satu News:

> Hanya meng-upgrade 1 Property.

Tidak terikat batas normal:

> **1 upgrade per turn**

Jadi normal upgrade + Instant Upgrade dapat dilakukan pada turn yang sama.

Jika tidak ada Property yang dapat di-upgrade:

> News tetap tersimpan.

---

## 4.4 Crown Breaker 👑💥

**Tipe:** Stored

Player memilih:

> **1 Crown milik player lain**

Crown:

> Destroyed → kembali menjadi Unowned.

Crown tidak berpindah ke pengguna News.

Seluruh status/modifier Crown tersebut hilang.

Jika player sudah memperoleh 4 Crown:

> **Game sudah selesai melalui Crown Victory.**

---

## 4.5 Half Rent 💰

**Tipe:** Stored

Player memilih:

> **1 Property milik player lain**

Durasi:

> **3 putaran**

Setiap kali Property menghasilkan Rent:

> **50% → Property Owner**
>
> **50% → Half Rent Holder**

Tenant tetap membayar:

> **100% Final Rent**

Tidak ada tambahan uang dari Bank.

---

## 4.6 Second Life ❤️

**Tipe:** Stored

Aktif saat player masuk:

> **Negative Balance**

Pada Bankruptcy Check:

```text
Negative Balance
 ↓
Balance → 0
 ↓
+50.000 Rels
 ↓
Final Balance = 50.000 Rels
 ↓
Give 1 Shield
```

Tidak masuk Asset Liquidation.

### Shield

Jika player terkena Rent dan masih mampu membayar:

> Rent dibayar normal → Shield tetap.

Jika player tidak mampu membayar:

> Shield aktif → Rent = 0 → Shield pecah.

---

## 4.7 Grand Exchange 🔄

**Tipe:** Stored

Player memilih:

> **1 aset miliknya sendiri**

### Property Exchange Matrix

| Property Milik | Target Property |
| -------------- | --------------- |
| L1             | L1–L2           |
| L2             | L1–L3           |
| L3             | L2–L4           |
| L4             | L3–L4           |
| L5             | L4–L5           |

Pertukaran:

> **Langsung dan tidak dapat ditolak.**

### Crown

> **Crown ↔ Crown**

Property tidak dapat ditukar dengan Crown.

Semua:

* Buff
* Negative Buff
* Status

ikut berpindah bersama aset.

---

## 4.8 Forced Transaction 🤝

**Tipe:** Stored

### Player A

Pemilik News.

### Player B

Pemilik aset target.

### Alur

```text
A memilih B
 ↓
A memilih Property / Crown B
 ↓
A memberikan harga
 ↓
B Accept / Reject
```

Jika B Accept:

> Transaksi terjadi.

Jika B Reject:

> B memberikan Counter Price.

Kemudian A:

### Accept

> A membayar Counter Price → aset berpindah.

### Reject

> Transaksi batal.

B membayar:

> **70% dari Counter Price**

kepada A.

Nominal:

> **Kelipatan 1.000 Rels**

---

## Timeout

Jika B tidak merespons:

> B membayar **80% Value resmi aset** kepada A.

Transaksi batal.

Aset tetap milik B.

Jika A timeout setelah menerima Counter:

> Transaksi batal tanpa kompensasi.

---

# 5. PROPERTY MODIFIER RULE

Modifier Property mengikuti:

> **Property**

bukan pemilik.

Contoh:

```text
Property A
+ Premium Listing
+ Falling Demand
```

Jika Property berpindah:

> Modifier ikut berpindah.

Hal ini berlaku pada:

* Property Seizure
* Grand Exchange
* Forced Transaction
* Normal Trade

---

# 6. PROPERTY STATUS

Property dapat memiliki status:

```text
Active
Inactive / Slump
```

### Active

Rent normal sesuai seluruh modifier.

### Inactive

> Rent = 0

Property tetap:

* Owned.
* Memiliki Level.
* Memiliki modifier lain jika modifier tersebut belum expired.

---

# 7. MODIFIER DURATION

Modifier dengan durasi:

> **3 putaran**

antara lain:

* Premium Listing
* Falling Demand
* Half Rent
* Crown Prosperity
* Reward multiplier

Rule:

> Putaran saat modifier diperoleh tidak dihitung.

Timer mulai pada putaran berikutnya.

---

# 8. MODIFIER STACKING

## Same Modifier

> **Refresh**

Contoh:

```text
Premium Listing
2 putaran tersisa

mendapat Premium Listing lagi

→ 3 putaran
```

Tidak menjadi:

> ×2.25

---

## Different Modifier

> **Stack**

Contoh:

```text
Reward ×3
Premium Listing ×1.5
Falling Demand ×0.5
```

Semua modifier aktif secara bersamaan.

---

# 9. PRIORITAS PROPERTY STATUS

Urutan dasar:

```text
Property Status Check
        ↓
Base Rent
        ↓
Set Bonus
        ↓
Rent Modifier
        ↓
Final Rounding
        ↓
Half Rent Distribution
```

Jika:

> **Property Slump = Active**

maka:

> **Final Rent = 0**

---

# 10. GLOBAL ROUNDING

Semua nominal ekonomi menggunakan kelipatan:

> **500 Rels**

Untuk Rent:

> Semua modifier dihitung dahulu.

Kemudian:

> **Rounding dilakukan sekali di akhir.**

---

# 11. NEWS TERMINOLOGY

## Instant

News tidak masuk Inventory.

Efek diberikan langsung atau menjadi status yang langsung aktif.

## Stored

News masuk Inventory.

Player menentukan kapan News digunakan.

---

# 12. NEWS FINAL STATUS

|  # | News                 | Category  | Type    | Status |
| -: | -------------------- | --------- | ------- | ------ |
|  1 | City Bonus           | 🍀 Luck   | Instant | ✅      |
|  2 | Free Property Permit | 🍀 Luck   | Instant | ✅      |
|  3 | Lucky Steps          | 🍀 Luck   | Instant | ✅      |
|  4 | Land Grant           | 🍀 Luck   | Instant | ✅      |
|  5 | Premium Listing      | 🍀 Luck   | Instant | ✅      |
|  6 | Express Route        | 🍀 Luck   | Instant | ✅      |
|  7 | Golden Pass          | 🍀 Luck   | Instant | ✅      |
|  8 | Crown Prosperity     | 🍀 Luck   | Instant | ✅      |
|  9 | Special Discount     | 🍀 Luck   | Instant | ✅      |
| 10 | Generous Neighbor    | 🍀 Luck   | Instant | ✅      |
| 11 | Roll Again           | 🍀 Luck   | Stored  | ✅      |
| 12 | Market Loss          | ⚠️ Bad    | Instant | ✅      |
| 13 | Traffic Jam          | ⚠️ Bad    | Instant | ✅      |
| 14 | Jail Notice          | ⚠️ Bad    | Instant | ✅      |
| 15 | Property Detour      | ⚠️ Bad    | Instant | ✅      |
| 16 | Crown Disruption     | ⚠️ Bad    | Instant | ✅      |
| 17 | Property Damage      | ⚠️ Bad    | Instant | ✅      |
| 18 | Construction Setback | ⚠️ Bad    | Instant | ✅      |
| 19 | Falling Demand       | ⚠️ Bad    | Instant | ✅      |
| 20 | Forced Break         | ⚠️ Bad    | Instant | ✅      |
| 21 | City Levy            | ⚠️ Bad    | Instant | ✅      |
| 22 | Property Slump       | ⚠️ Bad    | Instant | ✅      |
| 23 | Jail Break           | ⭐ Special | Stored  | ✅      |
| 24 | Property Seizure     | ⭐ Special | Stored  | ✅      |
| 25 | Instant Upgrade      | ⭐ Special | Stored  | ✅      |
| 26 | Crown Breaker        | ⭐ Special | Stored  | ✅      |
| 27 | Half Rent            | ⭐ Special | Stored  | ✅      |
| 28 | Second Life          | ⭐ Special | Stored  | ✅      |
| 29 | Grand Exchange       | ⭐ Special | Stored  | ✅      |
| 30 | Forced Transaction   | ⭐ Special | Stored  | ✅      |

---

# 13. REMAINING GLOBAL RULES TO FINALIZE

Relopoli News secara **effect design sudah selesai 30/30**.

Yang tersisa adalah finalisasi aturan sistem global:

1. **Timer 3 putaran**
2. **Modifier stacking order**
3. **Interaction antara Reward + Premium Listing + Falling Demand + Half Rent**
4. **Status Property ketika berpindah ownership**
5. **Interaction News dengan Bankruptcy**
6. **Final Landing Resolution Order**

Setelah bagian ini selesai:

> **RELOPOLI NEWS dapat dianggap benar-benar FINAL / READY FOR IMPLEMENTATION.**

Tentu. Aku rekap **Luck News** berdasarkan source dan hasil audit kita, dengan keputusan terbaru bahwa nama finalnya adalah **Roll Again**.

````markdown
# 🍀 RELOPOLI NEWS — LUCK NEWS

> Status: **LOCKED**
>
> Total Luck News: **11**
>
> Quantity masing-masing News: **3**
>
> Total copy Luck News: **33**
>
> Type:
> - Instant: 10
> - Stored: 1

---

# 1. Aturan Umum Luck News

Setiap jenis Luck News memiliki:

> **Quantity = 3**

Artinya terdapat maksimal 3 copy untuk masing-masing jenis Luck News dalam pool.

Luck News terbagi menjadi:

### Instant News

Efek langsung aktif ketika News didapat.

Instant News **tidak masuk Stored News Inventory**.

### Stored News

News masuk ke Stored News Inventory dan digunakan oleh Player sesuai Usage Rule.

Stored News hanya dapat digunakan oleh Player pemiliknya.

Untuk normal turn, Stored News diproses pada:

> **News Phase → sebelum Roll**

---

# 2. City Bonus 💰

**Type:** Instant  
**Quantity:** 3

Player langsung mendapatkan:

> **+25.000 Rels**

### Flow

```text
News Tile
↓
City Bonus
↓
+25.000 Rels
````

News tidak masuk Inventory.

### Status

🔒 **LOCKED**

---

# 3. Free Property Permit 🎟️

**Type:** Instant
**Quantity:** 3

Player memperoleh hak untuk mendapatkan:

> **1 Property L1–L3 secara gratis**

ketika melakukan pembelian Property yang memenuhi syarat.

### Aturan

* L1 → bisa digunakan.
* L2 → bisa digunakan.
* L3 → bisa digunakan.
* L4 → tidak bisa digunakan untuk initial purchase.
* L5 → tidak bisa digunakan untuk initial purchase.
* Efek tetap tersedia sampai digunakan.
* Setelah pembelian Property berhasil → efek habis.

### Sifat

News langsung mengaktifkan:

> **Free Property Permit**

bukan langsung memberikan Property.

### Status

🔒 **LOCKED**

---

# 4. Lucky Steps 👟

**Type:** Instant
**Quantity:** 3

Setelah Roll normal, Player mendapatkan:

> **+3 langkah**

### Aturan

* Tidak mengubah nilai dadu.
* Double tetap Double.
* Triple Double tetap Triple Double.
* Movement menggunakan **Movement Engine**.
* Crossing Start tetap dihitung.
* Tidak digunakan saat Jail.

### Contoh

```text
Roll = 5
↓
Base Movement = 5
↓
Lucky Steps +3
↓
Final Movement = 8
↓
Movement Engine
```

### Status

🔒 **LOCKED**

---

# 5. Land Grant 🏠

**Type:** Instant
**Quantity:** 3

Sistem memilih:

> **1 Unowned Property secara random**

Property diberikan kepada Player pada:

> **L1**

### Aturan

* Player tidak memilih Property.
* Selection dilakukan secara random.
* Crown tidak termasuk.
* Jika semua Property sudah dimiliki:

> **+15.000 Rels**

### Flow

```text
Land Grant
↓
Ada Unowned Property?
├── YES
│   ↓
│ Random 1 Property
│   ↓
│ Give L1
│
└── NO
    ↓
  +15.000 Rels
```

### Status

🔒 **LOCKED**

---

# 6. Premium Listing 📈

**Type:** Instant
**Quantity:** 3

Sistem random memilih:

> **1 Property milik Player**

Property tersebut mendapatkan:

> **+50% Rent**

Durasi:

> **3 putaran**

Berlaku untuk:

> **L1–L5**

### Modifier Rule

Jika modifier yang sama diberikan lagi:

> **Refresh**

Contoh:

```text
Premium Listing
2 putaran tersisa
↓
Premium Listing lagi
↓
3 putaran
```

Bukan menjadi +100% Rent.

Modifier mengikuti:

> **Property**

bukan pemilik.

### Status

🔒 **LOCKED**

---

# 7. Express Route 🚍

**Type:** Instant
**Quantity:** 3

News mengantarkan Player ke:

> **Tile 30 — Transport**

### Movement

Menggunakan:

> **Movement Engine**

Bukan teleport.

### Flow

```text
Express Route
↓
Movement Engine
↓
Tile 30 — Transport
↓
Turn selesai
```

Transport baru aktif pada:

> **Turn berikutnya**

Jika perjalanan melewati Start:

> **Pass Start tetap dihitung.**

### Status

🔒 **LOCKED**

---

# 8. Golden Pass 🎟️

**Type:** Instant
**Quantity:** 3

News mengantarkan Player ke:

> **Tile 20 — Reward**

Reward **tidak langsung aktif** pada turn ketika News diperoleh.

Reward aktif pada:

> **Turn berikutnya**

### Flow

```text
Golden Pass
↓
Movement Engine
↓
Tile 20 — Reward
↓
Reward belum aktif
↓
Turn selesai
```

Turn berikutnya:

```text
Turn berikutnya
↓
Reward aktif
```

### Status

🔒 **LOCKED**

---

# 9. Crown Prosperity 👑

**Type:** Instant
**Quantity:** 3

### Jika Player memiliki Crown

Sistem random memilih:

> **1 Crown**

Crown tersebut mendapatkan:

> **+2.000 Rels Crown Reward**

Durasi:

> **3 putaran**

Player tidak memilih Crown.

### Jika Player tidak memiliki Crown

Player mendapatkan:

> **+15.000 Rels**

### Modifier Rule

Modifier yang sama:

> **Refresh**

Modifier berbeda:

> **Stack**

### Status

🔒 **LOCKED**

---

# 10. Special Discount 🏷️

**Type:** Instant
**Quantity:** 3

Player mendapatkan:

> **50% Discount**

Berlaku untuk:

* Pembelian Property.
* Upgrade Property.

### Batas penggunaan

Satu News:

> **1 transaksi**

Setelah transaksi berhasil:

> **Discount habis.**

### Expiration

Tidak memiliki timer.

Jika belum digunakan:

> **Tetap tersedia sampai digunakan.**

### Catatan

Special Discount merupakan privilege yang langsung aktif ketika News didapat.

### Status

🔒 **LOCKED**

---

# 11. Generous Neighbor 🤝

**Type:** Instant
**Quantity:** 3

Sistem random memilih:

> **1 Player lain**

Kemudian menentukan nominal random:

> **10.000–70.000 Rels**

Nominal tersebut diambil dari Player yang terpilih.

### Jika saldo target tidak cukup

Target hanya membayar:

> **sesuai kemampuan**

Tidak boleh menyebabkan:

> **Negative Balance**

### Flow

```text
Generous Neighbor
↓
Random Player lain
↓
Random 10K–70K
↓
Target membayar sesuai kemampuan
↓
Rels diterima pemilik News
```

### Status

🔒 **LOCKED**

---

# 12. Roll Again 🎲

**Type:** Stored
**Quantity:** 3

> **Nama final: Roll Again**

Player menyimpan News ini di Stored News Inventory.

### Activation

Pada turn Player:

```text
Turn Start
↓
News Phase
↓
Roll Again tersedia
↓
Player memilih menggunakan
↓
Normal Roll
```

Player melakukan Roll pertama seperti normal.

Setelah melihat hasil:

> Player dapat memilih menggunakan hasil Roll pertama atau melakukan **Roll Again**.

### Jika menggunakan Roll pertama

```text
Roll #1
↓
Gunakan hasil
↓
Movement
```

### Jika memilih Roll Again

```text
Roll #1
↓
Player memilih Roll Again
↓
Roll #2
↓
Hasil Roll #2 WAJIB digunakan
↓
Movement
```

### Aturan

* Kedua Roll **tidak dijumlahkan**.
* Roll kedua menggantikan hasil Roll pertama.
* News habis setelah digunakan.
* Roll Again **bukan Double**.
* Tidak memicu Double Counter.
* Tidak memicu Triple Double.
* Tidak menjadi bagian dari Double Chain.

### Status

🔒 **LOCKED**

---

# 13. Master List — Luck News

|  # | Luck News            | Type    | Quantity | Efek Utama                                        |
| -: | -------------------- | ------- | -------: | ------------------------------------------------- |
|  1 | City Bonus           | Instant |        3 | +25.000 Rels                                      |
|  2 | Free Property Permit | Instant |        3 | 1 Property L1–L3 gratis                           |
|  3 | Lucky Steps          | Instant |        3 | +3 langkah setelah Roll                           |
|  4 | Land Grant           | Instant |        3 | Random Unowned Property → L1                      |
|  5 | Premium Listing      | Instant |        3 | +50% Rent selama 3 putaran                        |
|  6 | Express Route        | Instant |        3 | Movement ke Tile 30                               |
|  7 | Golden Pass          | Instant |        3 | Movement ke Tile 20; Reward aktif turn berikutnya |
|  8 | Crown Prosperity     | Instant |        3 | +2K Crown Reward / fallback +15K                  |
|  9 | Special Discount     | Instant |        3 | 50% Discount untuk 1 transaksi                    |
| 10 | Generous Neighbor    | Instant |        3 | Random Player bayar 10K–70K                       |
| 11 | Roll Again           | Stored  |        3 | Kesempatan memilih Roll kedua                     |

---

# 14. Total Luck News

```text
11 jenis Luck News
×
3 copy masing-masing
=
33 copy Luck News
```

### Distribution

```text
🍀 Instant Luck News
10 jenis
× 3
=
30 copy

🍀 Stored Luck News
1 jenis
× 3
=
3 copy

TOTAL
=
33 copy
```

---

# 🔒 LUCK NEWS STATUS

**11/11 Luck News sudah diaudit dan LOCKED.**

Tidak ada penambahan News baru.

Tidak ada perubahan terhadap efek source.

Nama final:

> **Roll Again** 🔒

```

Luck News sekarang sudah rapi dan bisa kita jadikan bagian final dari dokumentasi **Progress 17 — News System**.
```

Siap. Berikut rekap final **Bad News** berdasarkan hasil brainstorming kita dan keputusan yang sudah dikunci.

# RELOPOLI NEWS

## BAD NEWS — FINAL

**Total Bad News:** 11
**Tipe:** Semua `Instant`
**Quantity:** 3 copy per News
**Total Copy:** 33

---

# 1. Market Loss 💸

**Type:** Instant
**Quantity:** 3

Player kehilangan sejumlah Rels secara random.

Nominal yang mungkin:

```text
30.000
40.000
50.000
60.000
70.000
80.000
90.000
100.000
110.000
120.000
130.000
140.000
150.000 Rels
```

### Rules

* Random hanya menggunakan kelipatan **10.000 Rels**.
* Semua nominal memiliki peluang yang sama.
* Uang yang hilang masuk ke **Bank**.
* Balance player **boleh menjadi negatif**.
* Efek terjadi langsung ketika News diperoleh.

---

# 2. Traffic Jam 🚧

**Type:** Instant
**Quantity:** 3

Traffic Jam langsung aktif ketika News diperoleh dan memberikan efek pada **turn berikutnya**.

### Current Turn

Turn saat News diperoleh:

```text
Traffic Jam diperoleh
        ↓
Efek aktif
        ↓
Turn langsung berakhir
```

### Next Turn

Movement maksimum:

> **5 tile**

Hasil Roll tetap dihitung normal.

Contoh:

```text
Roll 3 → Move 3
Roll 5 → Move 5
Roll 8 → Move 5
Roll 12 → Move 5
```

### Double

Jika mendapatkan Double:

* Double tetap terdeteksi.
* Dice result tetap normal.
* Movement aktual tetap maksimum **5 tile**.
* Setelah movement dan Landing Resolution selesai, **Extra Roll tetap diberikan**.
* Extra Roll tidak terkena perubahan terhadap status Double.

Contoh:

```text
Roll 4 + 4
    ↓
Double
    ↓
Movement = 5
    ↓
Landing Resolution
    ↓
Extra Roll
```

Traffic Jam hanya membatasi **movement**, bukan mengubah hasil dice atau status Double.

Setelah turn terkena Traffic Jam selesai:

> Traffic Jam berakhir.

---

# 3. Jail Notice 🔒

**Type:** Instant
**Quantity:** 3

Player langsung dikirim menuju **Tile Jail** menggunakan Movement Engine.

### Movement

* Movement Engine menentukan rute terdekat.
* Jika terdapat dua rute dengan jarak sama → **Forward**.
* Jika perjalanan melewati Start → **Pass Start tetap dihitung**.

### Setelah Tiba di Tile Jail

Setelah karakter tiba di Tile Jail:

```text
Tiba di Tile Jail
        ↓
Teleport
        ↓
Jail Cell
        ↓
Player Jailed
        ↓
Turn End
```

Teleport dari Tile Jail menuju Jail Cell **bukan bagian dari Movement Engine**.

Tidak dilakukan Landing Resolution normal pada Tile Jail karena Tile Jail merupakan trigger khusus untuk masuk Jail.

---

# 4. Property Detour 🏠

**Type:** Instant
**Quantity:** 3

Sistem memilih secara random:

> **1 Property milik player lain**

Player kemudian bergerak menuju Property tersebut menggunakan **Movement Engine**.

### Rules

* Jika terdapat dua rute dengan jarak sama → **Forward**.
* Setelah tiba di Property tujuan → **Normal Landing Resolution** dijalankan.
* Semua status dan modifier Property yang berlaku tetap diperhitungkan.
* Jika tidak ada Property milik player lain → tidak ada efek.
* Jika tidak ada target valid → turn berakhir.

### Flow

```text
Property Detour
      ↓
Random pilih Property milik Player lain
      ↓
Movement Engine
      ↓
Move ke Property
      ↓
Tiba
      ↓
Normal Landing Resolution
      ↓
Turn selesai
```

---

# 5. Crown Disruption 👑⚠️

**Type:** Instant
**Quantity:** 3

Semua Crown yang dimiliki player menjadi:

> **Disrupted**

### Effect

Crown yang Disrupted:

> **Crown Reward berikutnya = 0**

Jika player memiliki beberapa Crown:

> Semua Crown terkena Disruption.

### Reactivation

Setiap Crown harus direaktivasi:

> **Satu per satu**

Reactivation terjadi ketika player:

> **Step/Landing pada tile Crown tersebut**

### Crown Prosperity

Crown Disruption:

* Tidak menghapus Crown Prosperity.
* Tidak menghapus timer Prosperity.
* Tidak pause timer Prosperity.

### Repeat Disruption

Jika Crown yang sudah Disrupted terkena Crown Disruption lagi:

> Status tetap **Disrupted**.

Tidak ada:

* Refresh.
* Timer baru.
* Efek tambahan.

### Victory

Crown tetap dimiliki player dan tetap dihitung untuk:

> **Crown Victory**

Crown Disruption tidak menghilangkan ownership Crown.

---

# 6. Property Damage 🏠💥

**Type:** Instant
**Quantity:** 3

Sistem memilih secara random:

> **1 Property milik player yang mendapatkan News**

Property milik player lain tidak dapat menjadi target.

### Damage Table

| Current Level | Result            |
| ------------- | ----------------- |
| L1            | Unowned           |
| L2            | Unowned           |
| L3            | L1                |
| L4            | L2                |
| L5            | Tidak terpengaruh |

### L5

L5:

> **Immune terhadap Property Damage**

### Jika Tidak Memiliki Property

Jika player tidak memiliki Property:

> Tidak ada efek.

### Jika Property Menjadi Unowned

Property mengikuti aturan Property → Unowned:

```text
Unowned
+
L1 / Empty Land
+
Clean State
```

Semua Property Modifier/status lama dihapus.

---

# 7. Construction Setback 🏗️⚠️

**Type:** Instant
**Quantity:** 3

Sistem memilih secara random:

> **1 Property milik player yang mendapatkan News**

Property turun:

> **tepat 1 Level**

### Level Reduction

```text
L5 → L4
L4 → L3
L3 → L2
L2 → L1
L1 → Unowned
```

### L1 → Unowned

Jika L1 turun menjadi Unowned:

* Semua Property Modifier/status dihapus.
* Property kembali menjadi:

```text
Clean
+
L1
+
Unowned
```

### Jika Tidak Memiliki Property

Jika player tidak memiliki Property:

> Tidak ada efek.

Property milik player lain tidak menjadi target.

---

# 8. Falling Demand 📉

**Type:** Instant
**Quantity:** 3

Sistem memilih:

> **1–3 Property milik player yang mendapatkan News secara random**

Property yang sudah memiliki Falling Demand:

> **Tetap dapat terpilih kembali.**

### Effect

Property yang terpilih mendapatkan:

> **Rent −50%**

### Duration

> **3 putaran**

Putaran ketika modifier diperoleh:

> Tidak dihitung.

Timer mulai pada putaran berikutnya.

### Same Modifier

Jika Property yang sudah memiliki Falling Demand terpilih kembali:

> **Refresh Duration**

Menjadi:

> **3 putaran**

Bukan stacking.

Contoh:

```text
Falling Demand
2 putaran tersisa

↓ mendapat Falling Demand lagi

Falling Demand
3 putaran
```

### Target

Jika player memiliki kurang dari 3 Property:

> Jumlah target menyesuaikan Property yang tersedia.

Jika player tidak memiliki Property:

> Tidak ada efek.

---

# 9. Forced Break ⛔

**Type:** Instant
**Quantity:** 3

Saat News diperoleh:

> **Turn saat ini langsung berakhir.**

Pada turn berikutnya:

> **Turn dibekukan sepenuhnya.**

### Forced Break Turn

Tidak ada:

* Roll.
* Movement.
* Fast Travel.
* Aktivitas turn lainnya.
* Pemrosesan efek/status yang membutuhkan turn player untuk berjalan.

Setelah turn yang dibekukan selesai:

> Player kembali ke normal flow.

Forced Break tidak mengubah aset atau Balance secara langsung.

---

# 10. City Levy 💸🏙️

**Type:** Instant
**Quantity:** 3

Player dikenakan Levy:

> **25% dari Balance positif**

### Balance ≤ 0

Jika:

```text
Balance ≤ 0
```

maka:

> **Levy = 0 Rels**

Tidak ada uang yang dibagikan.

### Rounding

Nominal Levy menggunakan:

> **Kelipatan 500 Rels**

### Distribution

Uang Levy dibagikan:

> **Secara merata kepada seluruh player lain**

Jika terdapat sisa dari pembagian:

> **Sisa masuk Bank**

City Levy hanya mengambil dari Balance positif sehingga tidak membuat Balance menjadi negatif.

---

# 11. Property Slump 🏠🔒

**Type:** Instant
**Quantity:** 3

Semua Property milik player yang mendapatkan News menjadi:

> **Inactive**

### Saat Inactive

```text
Rent = 0
```

Property:

* Tetap dimiliki.
* Mempertahankan Level.
* Tidak memiliki timer.
* Dapat dipulihkan.

### Reactivation

Jika siapa pun landing pada Property yang Inactive:

```text
Landing
   ↓
Rent = 0
   ↓
Property → Active
```

Jadi landing yang melakukan reactivation:

> **Tidak membayar Rent**

Reactivation dilakukan:

> **Satu per satu**

### Ownership Transfer

Jika Property Slump berpindah ownership:

> **Slump langsung hilang**

Property menjadi:

```text
Active
+
Owner Baru
```

Jadi Property Slump:

> **Tidak ikut berpindah bersama Property saat ownership transfer.**

---

# FINAL BAD NEWS TABLE

|  # | News                 | Type    | Quantity |  Status  |
| -: | -------------------- | ------- | -------: | :------: |
|  1 | Market Loss          | Instant |        3 | ✅ LOCKED |
|  2 | Traffic Jam          | Instant |        3 | ✅ LOCKED |
|  3 | Jail Notice          | Instant |        3 | ✅ LOCKED |
|  4 | Property Detour      | Instant |        3 | ✅ LOCKED |
|  5 | Crown Disruption     | Instant |        3 | ✅ LOCKED |
|  6 | Property Damage      | Instant |        3 | ✅ LOCKED |
|  7 | Construction Setback | Instant |        3 | ✅ LOCKED |
|  8 | Falling Demand       | Instant |        3 | ✅ LOCKED |
|  9 | Forced Break         | Instant |        3 | ✅ LOCKED |
| 10 | City Levy            | Instant |        3 | ✅ LOCKED |
| 11 | Property Slump       | Instant |        3 | ✅ LOCKED |

---

# TOTAL

```text
11 Bad News
×
3 copies each
=
33 Bad News Copies
```

Semua Bad News:

> **Instant**

Tidak ada Bad News yang masuk Stored News Inventory.

**BAD NEWS: 11/11 LOCKED** ✅

Rekap ini bisa langsung dijadikan bagian final **Relopoli News Design Document** dan digabung dengan rekap Luck News.

Siap. Berikut rekap final **Special News #1–#8** berdasarkan source dan keputusan brainstorming kita. Semua sudah **LOCKED**. 

# 📰 Relopoli — Special News System

## Status: 🔒 LOCKED

Special News adalah News kategori khusus dengan jumlah **1 copy untuk setiap jenis**.

Semua Special News pada sistem saat ini:

| # | Special News       | Tipe   | Quantity | Status    |
| - | ------------------ | ------ | -------: | --------- |
| 1 | Jail Break         | Stored |        1 | 🔒 LOCKED |
| 2 | Property Seizure   | Stored |        1 | 🔒 LOCKED |
| 3 | Instant Upgrade    | Stored |        1 | 🔒 LOCKED |
| 4 | Crown Breaker      | Stored |        1 | 🔒 LOCKED |
| 5 | Half Rent          | Stored |        1 | 🔒 LOCKED |
| 6 | Second Life        | Stored |        1 | 🔒 LOCKED |
| 7 | Grand Exchange     | Stored |        1 | 🔒 LOCKED |
| 8 | Forced Transaction | Stored |        1 | 🔒 LOCKED |

---

# 1. Jail Break 🔓

**Type:** Stored
**Quantity:** 1

## Usage

Jail Break hanya dapat digunakan ketika Player sedang:

> **Jailed**

Di Jail UI, News ditampilkan sebagai:

> **Jalan Keluar**

Jika Player tidak sedang Jailed:

> News tidak dapat digunakan.

## Effect

Saat digunakan:

```text
Jail Cell
↓
Use Jail Break
↓
News dikonsumsi
↓
Exit Jail
↓
Teleport → Tile Jail
↓
System / Police Physical Dice Roll
↓
Movement Engine
↓
Landing Resolution
↓
Turn End
```

Perpindahan dari **Jail Cell → Tile Jail** menggunakan teleport dan bukan Movement Engine.

Setelah kembali ke Tile Jail, System/Police melakukan physical dice roll dan movement berikutnya menggunakan Movement Engine normal.

Jail Break juga mengikuti aturan movement umum seperti Start Detection ketika movement melewati Start.

---

# 2. Property Seizure 🏠

**Type:** Stored
**Quantity:** 1

Player memilih:

> **1 Property milik Player lain**

Kemudian Property tersebut:

* langsung berpindah ownership;
* level tetap;
* modifier/buff tetap;
* negative modifier tetap;
* status yang melekat pada Property tetap mengikuti Property.

### Crown

> **Crown tidak dapat disita.**

### Property Slump

Untuk kasus Property yang sedang terkena **Property Slump**:

> Ownership transfer menyebabkan Property Slump langsung hilang.

Property menjadi:

> **Active**

Property tetap mempertahankan levelnya.

---

# 3. Instant Upgrade ⬆️

**Type:** Stored
**Quantity:** 1

Player memilih:

> **1 Property miliknya**

Property naik:

> **+1 Level secara gratis**

Progression:

```text
L1 → L2
L2 → L3
L3 → L4
L4 → L5
```

L5:

> **Tidak dapat dipilih.**

## Upgrade Limit

Instant Upgrade:

> **Tidak terikat batas normal 1 upgrade per turn.**

Artinya pada turn yang sama Player dapat melakukan:

```text
Normal Upgrade
+
Instant Upgrade
```

## Jika Tidak Ada Target

Jika Player tidak memiliki Property yang dapat di-upgrade:

> **News tetap tersimpan.**

## Property Modifier / Status

Semua:

* modifier;
* buff;
* negative modifier;
* status;

yang melekat pada Property:

> **Tetap mengikuti Property setelah upgrade.**

---

# 4. Crown Breaker 👑💥

**Type:** Stored
**Quantity:** 1

Player memilih:

> **1 Crown milik Player lain**

Crown tersebut:

> **Destroyed**

Crown tidak berpindah kepada pengguna News.

Setelah dihancurkan:

```text
Crown
↓
Destroyed
↓
Unowned
↓
Clean Crown
```

Seluruh:

* Crown Status;
* Crown Modifier;

dihapus.

## Crown Disruption

Crown yang sedang terkena:

> **Crown Disruption**

tetap dapat dipilih.

Crown langsung dihancurkan.

Status **Disrupted** tidak perlu diproses lebih lanjut karena seluruh status/modifier Crown dihapus.

## Crown Victory

Jika kondisi Crown Victory terpenuhi setelah proses penghancuran Crown sesuai aturan kemenangan game:

> **Crown Victory dipicu.**

---

# 5. Half Rent 💰

**Type:** Stored
**Quantity:** 1

Player memilih:

> **1 Property milik Player lain**

Property tersebut mendapatkan:

> **Half Rent selama 3 turns**

Setiap kali Property menghasilkan Rent:

```text
Final Rent
    ↓
50% → Property Owner
50% → Half Rent Holder
```

Tenant tetap membayar:

> **100% Final Rent**

Tidak ada tambahan uang yang berasal dari Bank.

## Rent Calculation

Half Rent diterapkan setelah seluruh perhitungan Rent selesai.

Urutannya:

```text
Base Rent
↓
Set Bonus
↓
Rent Modifier
↓
Final Rounding
↓
Final Rent
↓
Split 50 / 50
```

Jadi pembagian Half Rent menggunakan:

> **Final Rent**

---

# 6. Second Life ❤️

**Type:** Stored
**Quantity:** 1

Second Life tidak langsung memberikan uang ketika diperoleh.

News aktif ketika Player mengalami:

> **Negative Balance**

Pada:

> **Bankruptcy Check**

Second Life langsung dikonsumsi.

Flow:

```text
Negative Balance
↓
Bankruptcy Check
↓
Second Life ditemukan
↓
Second Life DIKONSUMSI
↓
Balance → 0
↓
+50,000 Rels
↓
Final Balance = 50,000 Rels
↓
Give 1 Shield
↓
Skip Asset Liquidation
```

Player:

* tidak masuk Asset Liquidation;
* mendapatkan 1 Shield;
* memiliki final balance sebesar 50,000 Rels.

Karena News dikonsumsi ketika aktif:

> **Second Life hanya dapat digunakan satu kali.**

---

# 7. Grand Exchange 🔄

**Type:** Stored
**Quantity:** 1

Player memilih:

> **1 asset miliknya**

Kemudian Player:

> **memilih sendiri asset milik Player lain**

sebagai pasangan pertukaran.

## Property Exchange Matrix

| Property yang dimiliki | Property yang dapat menjadi pasangan |
| ---------------------- | ------------------------------------ |
| L1                     | L1–L2                                |
| L2                     | L1–L3                                |
| L3                     | L2–L4                                |
| L4                     | L3–L4                                |
| L5                     | L4–L5                                |

Pertukaran Property dilakukan:

> **langsung**

Tidak ada pilihan untuk menolak dari sisi pasangan setelah pertukaran ditentukan sesuai aturan Grand Exchange.

## Crown

Crown hanya dapat ditukar:

> **Crown ↔ Crown**

Property:

> **Tidak dapat ditukar dengan Crown.**

## Modifier / Status

Semua:

* buff;
* negative buff;
* status;

tetap:

> **mengikuti asset yang ditukar.**

---

# 8. Forced Transaction 💰

**Type:** Stored
**Quantity:** 1

Player A yang memiliki News memilih:

1. Player B;
2. Property atau Crown milik Player B;
3. harga awal.

Flow:

```text
Player A
↓
Pilih Player B
↓
Pilih Property / Crown
↓
Tentukan Harga
↓
Player B menerima Offer
```

Player B memiliki pilihan:

> **Accept / Reject**

---

## Jika Player B Accept

```text
Accept
↓
Player A membayar harga
↓
Asset berpindah ke Player A
↓
Transaction selesai
```

---

## Jika Player B Reject

Player B memberikan:

> **Counter Price**

Player A kemudian dapat:

> **Accept / Reject**

### Jika Player A Accept

```text
Accept Counter
↓
Player A membayar Counter Price
↓
Asset berpindah ke Player A
↓
Transaction selesai
```

### Jika Player A Reject

Player B wajib membayar:

> **70% dari Counter Price**

Pembayaran dibulatkan ke:

> **1,000 Rels**

Kemudian:

* asset tetap milik Player B;
* transaction selesai.

---

## Player B Timeout

Jika Player B tidak memberikan respons sampai timeout:

> Player B membayar **80% Official Value asset** kepada Player A.

Kemudian:

* asset tetap milik Player B;
* transaction dibatalkan.

---

## Player A Timeout

Jika Player A timeout setelah menerima Counter Price:

> **Transaction batal.**

Tidak ada kompensasi.

---

## Modifier / Status

Jika Forced Transaction berhasil menyebabkan ownership berpindah:

> Modifier, buff, negative modifier, dan status yang melekat pada asset tetap mengikuti asset.

Asset tidak di-clean hanya karena ownership berpindah melalui Forced Transaction.

---

# 🔒 FINAL SPECIAL NEWS RULES

| Special News       | Effect                                                          | Status |
| ------------------ | --------------------------------------------------------------- | ------ |
| Jail Break         | Keluar Jail → kembali Tile Jail → System/Police Roll → Movement | 🔒     |
| Property Seizure   | Mengambil Property Player lain                                  | 🔒     |
| Instant Upgrade    | Upgrade 1 Property +1 Level gratis                              | 🔒     |
| Crown Breaker      | Menghancurkan Crown Player lain                                 | 🔒     |
| Half Rent          | Membagi Final Rent 50/50                                        | 🔒     |
| Second Life        | Menyelamatkan Player dari Negative Balance                      | 🔒     |
| Grand Exchange     | Menukar asset dengan asset Player lain                          | 🔒     |
| Forced Transaction | Memaksa proses transaksi dengan mekanisme Offer/Counter         | 🔒     |

---

# 📦 Special News Inventory

Setiap Special News hanya memiliki:

> **1 copy**

Sehingga jumlah maksimal Special News berdasarkan jenis:

> **1 per jenis News**

Total:

> **8 Special News**
>
> **8 copies**

---

# 🔒 STATUS AKHIR

## SPECIAL NEWS SYSTEM

**8 / 8 LOCKED**

```text
1. Jail Break          🔒
2. Property Seizure    🔒
3. Instant Upgrade     🔒
4. Crown Breaker       🔒
5. Half Rent           🔒
6. Second Life         🔒
7. Grand Exchange      🔒
8. Forced Transaction  🔒
```

**SPECIAL NEWS BRAINSTORM — SELESAI 🔒**

Bisa. Supaya konsisten dengan **Forced Transaction**, kita tambahkan satu aturan global yang berlaku untuk seluruh Special News yang melibatkan proses interaksi/keputusan, tanpa mengubah Special News yang bersifat langsung.

# 📰 Relopoli — Special News System

## Status: 🔒 LOCKED

### 📌 Aturan Pembatalan & Timeout Umum

Aturan berikut berlaku sebagai **aturan umum Special News** apabila sebuah Special News membutuhkan proses pemilihan, konfirmasi, atau respons dari Player lain.

## 1. News Tidak Dapat Dibatalkan Setelah Effect Dimulai

Setelah Player melakukan konfirmasi dan sistem mulai menjalankan effect:

> **News tidak dapat dibatalkan.**

Contoh:

```text
Select Target
↓
Confirm
↓
Effect Started
↓
CANNOT CANCEL
```

Jika effect sudah dimulai, News dianggap sudah digunakan.

---

## 2. Cancel Sebelum Confirm

Jika UI masih berada pada tahap pemilihan target:

> Player dapat membatalkan penggunaan News.

Flow:

```text
News Selected
↓
Target Selection
↓
Cancel
↓
Kembali ke News Inventory
```

News:

> **Tidak dikonsumsi.**

---

## 3. Invalid Target

Jika target yang dipilih menjadi tidak valid sebelum Confirm atau sebelum effect dimulai:

> **Action dibatalkan.**

News:

> **Tidak dikonsumsi.**

Player kembali ke kondisi sebelumnya dan dapat memilih target lain jika flow UI masih tersedia.

Contoh:

```text
Target Property
↓
Target menjadi tidak valid
↓
Validation Failed
↓
News tetap tersimpan
```

---

## 4. Target Menjadi Tidak Valid Setelah Confirm

Jika target valid ketika Confirm dilakukan tetapi menjadi tidak valid ketika server melakukan final validation:

> **Effect dibatalkan.**

News:

> **Tidak dikonsumsi**, kecuali Special News tersebut memang sudah memasuki tahap effect yang tidak dapat dibatalkan.

Untuk sistem yang membutuhkan transaksi/response Player lain, server melakukan validasi ulang sebelum perubahan final.

---

# ⏱️ 5. Timeout Umum

Jika sebuah Special News membutuhkan respons Player lain dan Player tersebut tidak memberikan respons dalam batas waktu yang ditentukan:

> **Interaction mengalami Timeout.**

Timeout bukan dianggap sebagai Accept.

Timeout mengikuti:

> **Fallback Rule dari Special News tersebut.**

Jika Special News tidak memiliki fallback rule khusus:

> **Effect dibatalkan dan News tidak dapat digunakan untuk effect tersebut.**

---

# 6. Timeout Tidak Sama dengan Reject

Timeout dan Reject merupakan dua kondisi berbeda.

### Reject

Player secara aktif memilih:

> **Reject / Decline**

### Timeout

Player:

> **Tidak memberikan respons sampai batas waktu habis.**

Flow:

```text
Offer
├── Accept
├── Reject
└── Timeout
```

Ketiganya merupakan hasil yang berbeda dan dapat memiliki consequence yang berbeda sesuai aturan Special News.

---

# 7. Timeout Hanya Berlaku Pada Player yang Harus Merespons

Timer berjalan untuk:

> **Player yang sedang memiliki kewajiban memberikan respons.**

Contoh:

```text
Player A
↓
Special News
↓
Player B harus merespons
↓
Timer dimulai
```

Player A tidak dianggap timeout selama:

> **Player B masih memiliki waktu untuk merespons.**

Jika B timeout:

> Jalankan Fallback Rule.

---

# 8. Timer Tidak Berjalan Setelah Interaction Selesai

Setelah salah satu kondisi terjadi:

```text
Accept
Reject
Timeout
Cancel
```

maka interaction selesai dan:

> **Timer dihentikan.**

Tidak ada:

> Double Timeout

atau consequence tambahan akibat timer yang masih berjalan.

---

# 9. Disconnect / Player Keluar

Jika Player yang sedang memiliki kewajiban memberikan respons:

> **Disconnect / Leave Game**

maka kondisi tersebut diperlakukan sebagai:

> **Timeout**

dan menggunakan Fallback Rule dari Special News terkait.

---

# 10. Server Authority

Semua:

* timeout;
* cancel;
* target validation;
* response;
* ownership transfer;
* payment;
* News consumption;

ditentukan oleh:

> **Server**

Client/UI hanya mengirimkan pilihan Player.

Server melakukan:

```text
Client Request
↓
Server Validation
↓
Valid?
├─ No → Reject Action
└─ Yes
    ↓
Apply Effect
```

Dengan demikian Player tidak dapat memanipulasi:

* harga;
* timer;
* target;
* ownership;
* payment;
* hasil effect.

---

# 11. Special News dengan Aturan Timeout Khusus

Jika sebuah Special News memiliki aturan timeout yang sudah ditentukan secara spesifik, maka:

> **Aturan khusus tersebut memiliki prioritas.**

Contoh:

### Forced Transaction

Player B timeout:

> B membayar **80% Official Value** kepada Player A.

Player A timeout setelah Counter:

> Transaction batal tanpa kompensasi.

Jadi Forced Transaction **tidak menggunakan fallback timeout generik** untuk dua kondisi tersebut.

---

# 🔒 Prinsip Umum

```text
Before Confirm
↓
Can Cancel
↓
Confirm
↓
Server Validation
↓
Valid?
├─ No → News tetap tersimpan
└─ Yes
    ↓
Effect / Interaction Started
    ↓
Cannot Cancel
    ↓
Accept / Reject / Timeout
    ↓
Resolve sesuai Special News
```

### Rule Utama

> **Cancel hanya berlaku sebelum effect dimulai.**

> **Timeout bukan Reject.**

> **Timeout mengikuti fallback khusus jika tersedia.**

> **Jika tidak ada fallback khusus, interaction dibatalkan.**

> **Server adalah authority untuk seluruh proses.**

Catatan: aturan umum di atas menambahkan beberapa aturan operasional yang **tidak seluruhnya tertulis eksplisit di source Special News**. Bagian yang paling jelas didukung source adalah adanya **Accept/Reject/Counter/Timeout** pada Forced Transaction; fallback timeout khususnya sudah kita pertahankan. 

# Relopoli — News UI Flow

**Status:** Final Brainstorm / UI Flow Specification  
**Scope:** Alur tampilan kartu News dan pemrosesan efeknya

## 1. News Terpicu

News terpicu ketika pemain menginjak tile News atau menerima News dari efek tertentu sesuai aturan permainan.

## 2. Kartu News Muncul

- Kartu News ditampilkan di tengah layar.
- Desain kartu menyesuaikan kategori News:
  - **Bad News:** aksen merah.
  - **Luck News:** aksen hijau dan emas.
  - **Special News:** aksen emas.
- Kartu menampilkan judul, ilustrasi, deskripsi efek, dan tombol **OK**.

## 3. Efek News Dijalankan

- Efek News dijalankan secara otomatis oleh sistem setelah kartu News muncul.
- Pemain tidak perlu menekan **OK** untuk memulai efek.
- Contoh efek meliputi pembayaran atau penerimaan Rels, pergerakan tambahan, pemberian item, dan perubahan status, sesuai jenis News.
- Efek gameplay divalidasi dan diproses oleh server.

## 4. Efek Selesai, Kartu Tetap Ditampilkan

- Setelah efek News selesai diproses, kartu tetap berada di layar.
- Pemain dapat membaca hasil efek dan menekan tombol **OK** untuk menutup kartu.
- Tombol **OK** tidak menjalankan ulang efek News.

## 5. Turn Berlanjut

- Setelah pemain menekan **OK**, kartu News ditutup.
- Turn dilanjutkan sesuai aturan permainan dan hasil efek News yang telah diproses.

## 6. Aturan Penting

1. Efek News dijalankan sebelum pemain menekan **OK**.
2. Turn menunggu selama kartu News masih ditampilkan.
3. Pemain tidak dapat melewati kartu News tanpa menekan **OK**.
4. Efek News hanya diproses satu kali dan tidak boleh terpicu ulang ketika pemain menekan **OK**.
5. Perubahan saldo, pergerakan, item, dan status harus diproses secara konsisten oleh server.
6. Nominal dan efek pada gambar desain hanya contoh visual, bukan aturan gameplay resmi.

## 7. Batasan Spesifikasi

Alur dasar News UI ini tidak menetapkan detail efek setiap kartu News. Efek spesifik masing-masing kartu tetap mengikuti spesifikasi mekanik News yang ditetapkan secara terpisah.