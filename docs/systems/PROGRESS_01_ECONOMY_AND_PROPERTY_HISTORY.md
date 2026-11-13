
````markdown
# RELOPOLI — RECAP HASIL BRAINSTORM
## Economy, Rent Modifier, Bankruptcy & Master Turn Flow

> Status: **LOCKED**
>
> Rekap khusus hasil obrolan ini.

---

# 1. Rent Calculation

## Urutan Perhitungan Rent

Urutan final:

1. **Property Slump Check**
2. **Base Rent**
3. **Set Bonus**
4. **Rent Multipliers**
5. **Final Rounding**
6. **Half Rent Split** jika aktif

### 1.1 Property Slump

Jika Property sedang **Inactive karena Property Slump**:

- Rent = **0**
- Modifier Rent lainnya tidak dihitung.
- Tidak ada Half Rent distribution.
- Modifier lain tidak otomatis terhapus.

---

### 1.2 Base Rent

Ambil Rent dasar berdasarkan:

- Property
- Level Property

---

### 1.3 Set Bonus

Jika Property merupakan bagian dari Set lengkap:

> **Rent × 1.2**

atau:

> **+20% Rent**

---

### 1.4 Rent Multipliers

Semua modifier multiplier yang aktif di-stack.

Modifier saat ini:

| Modifier | Multiplier |
|---|---:|
| Reward | ×2 / ×3 |
| Premium Listing | ×1.5 |
| Falling Demand | ×0.5 |

Modifier multiplier lain di masa depan juga masuk ke tahap ini.

### Contoh

```text
Base Rent = 10.000

× 1.2 Set
× 3 Reward
× 1.5 Premium Listing
× 0.5 Falling Demand

= 27.000 Rels
````

---

# 2. Rent Rounding

## Aturan

Semua modifier dihitung terlebih dahulu.

**Tidak ada rounding di tengah proses.**

Rounding hanya dilakukan:

> **Sekali di paling akhir.**

Final Rent dibulatkan ke kelipatan:

> **500 Rels**

### Contoh

```text
7.500 × 1.2 × 1.5 × 0.5
= 6.750

Final Rent
= 7.000 Rels
```

---

# 3. Balance Rule

Semua balance pemain menggunakan kelipatan:

> **500 Rels**

### Balance Valid

```text
25.000
10.500
5.000
500
0
```

### Balance Tidak Valid

```text
25.250
10.750
3.750
```

## Solvency

> **Balance ≥ 0 = valid / solvent**

Jadi:

* `Balance > 0` → solvent
* `Balance = 0` → tetap solvent
* `Balance < 0` → Bankruptcy Check

Player boleh bermain dengan:

> **0 Rels**

---

# 4. Half Rent

Half Rent bukan pengurang Rent.

Final Rent dihitung terlebih dahulu.

Kemudian:

> Tenant tetap membayar **100% Final Rent**.

Jika Half Rent aktif:

* Half Rent Holder mendapat 50%
* Property Owner mendapat sisanya

## Rounding Half Rent

Bagian Half Rent Holder dibulatkan ke bawah ke kelipatan 500.

Sisa diberikan kepada Property Owner.

### Contoh

```text
Final Rent = 7.500

Half Rent Holder = 3.500
Property Owner   = 4.000

Total             = 7.500
```

Dengan demikian:

> Owner + Half Rent Holder = selalu tepat Final Rent.

---

## 4.1 Half Rent Tidak Bisa Stack

Jika Property sudah memiliki Half Rent:

> Half Rent baru tidak dapat diterapkan.

Jika target tidak valid:

* News tidak langsung dikonsumsi.
* Player dapat memilih Property lain.
* Jika tidak ada target valid, News tetap tersimpan.

---

## 4.2 Half Rent Holder Menjadi Owner

Jika Half Rent Holder kemudian menjadi Owner Property:

> **Half Rent langsung berakhir.**

---

# 5. Modifier Classification

## 5.1 Player Modifier

Modifier melekat pada Player.

Contoh:

* Reward

Jika target Property tidak lagi dimiliki Player:

> Modifier langsung hilang.

---

## 5.2 Property Modifier

Modifier melekat pada Property.

Contoh:

* Premium Listing
* Falling Demand
* Half Rent

Jika Property berpindah ownership:

> Modifier ikut Property.

---

## 5.3 Crown Asset Modifier

Modifier/status tertentu melekat pada Crown.

Contoh:

* Crown Prosperity
* Crown Disruption

Jika Crown berpindah:

> Status/modifier ikut Crown.

---

# 6. Property Slump

Property Slump menyebabkan:

> **Property menjadi Inactive**

dan:

> **Rent = 0**

## Reactivation

Jika player landing pada Property yang sedang Slump:

* Property menjadi Active.
* Landing tersebut tidak membayar Rent.
* Modifier lain yang masih valid tetap ada.

## Ownership Transfer

Jika Property Slump berpindah ownership:

> **Slump langsung hilang.**

Property menjadi:

> **Active + Owner baru**

## Property Menjadi Unowned

Jika Property menjadi Unowned:

> Semua Property Modifier dihapus.

Property kembali:

> **Clean + L1 + Unowned**

---

# 7. Modifier Duration

Modifier berikut menggunakan durasi **3 Rounds**:

| Modifier         |   Durasi |
| ---------------- | -------: |
| Reward           | 3 Rounds |
| Premium Listing  | 3 Rounds |
| Falling Demand   | 3 Rounds |
| Half Rent        | 3 Rounds |
| Crown Prosperity | 3 Rounds |

---

## 7.1 Round Saat Modifier Diperoleh

Round ketika modifier diperoleh:

> **Tidak dihitung.**

Modifier langsung aktif.

Timer baru mulai dihitung setelah Round tersebut selesai.

### Contoh

Modifier diperoleh pada Round 4:

```text
Round 4 → tidak dihitung
Round 5 → 1
Round 6 → 2
Round 7 → 3
```

Setelah Round 7 selesai:

> Modifier expired.

---

# 8. Property Modifier + Ownership Transfer

Jika Property berpindah ownership:

> Modifier tetap ikut Property.

Timer:

> **Tidak di-reset.**

Timer tetap menggunakan Player yang pertama kali memperoleh modifier sebagai **Time Reference**.

### Contoh

Player A memberikan Falling Demand pada Property.

Kemudian:

```text
Property A → B
```

Hasil:

* Falling Demand tetap aktif.
* Modifier ikut Property.
* Timer tetap mengikuti Round Player A.
* Timer tidak berubah menjadi 3 Rounds baru untuk B.

---

# 9. Property Menjadi Unowned

Jika Property menjadi Unowned:

> Semua Property Modifier langsung dihapus.

Termasuk:

* Premium Listing
* Falling Demand
* Half Rent
* Property Slump

Jika Property dibeli lagi:

> Property kembali dalam kondisi **clean**.

Tidak ada modifier lama yang tersisa.

---

# 10. Same Modifier — Refresh

Jika modifier jenis yang sama diberikan lagi:

> **Refresh Duration**

Bukan stacking.

### Contoh

Premium Listing:

```text
×1.5
2 Rounds tersisa
```

Kemudian mendapatkan Premium Listing lagi:

```text
×1.5
3 Rounds
```

Bukan:

```text
×2.25
```

Prinsip:

> **Same Modifier → Refresh**

---

# 11. Different Modifier — Stack

Modifier yang berbeda tetap dapat stack.

### Contoh

```text
Premium Listing ×1.5
Falling Demand ×0.5
```

Hasil:

```text
×1.5 × 0.5
= ×0.75
```

---

# 12. Crown Modifier

## 12.1 Crown Reward

Base Crown Reward:

```text
Jumlah Property yang dimiliki Player
di district Crown
× 1.000 Rels
```

Maksimum:

> **7.000 Rels**

---

## 12.2 Crown Prosperity

Crown Prosperity:

> **+2.000 Rels**

### Contoh

Player memiliki 5 Property di district Crown:

```text
Base Reward = 5.000
Prosperity  = +2.000

Total = 7.000 Rels
```

---

## 12.3 Crown Disruption

Jika Crown Disrupted:

> Crown Reward berikutnya = **0**

Crown Prosperity:

> **Tidak dihapus.**

Setelah Crown direaktivasi:

> Crown Prosperity tetap dapat bekerja jika timer masih aktif.

Disruption:

> **Tidak pause timer Prosperity.**

---

## 12.4 Crown Breaker

Jika Crown dihancurkan:

* Ownership hilang.
* Crown Prosperity hilang.
* Crown Disruption hilang.
* Status Crown lainnya hilang.

Crown kembali:

> **Unowned + Clean**

---

## 12.5 Crown Prosperity Diberikan Lagi

Jika Crown sudah memiliki Crown Prosperity aktif:

> **Refresh Duration**

Bukan stack.

Tetap:

> **+2.000**

Timer kembali:

> **3 Rounds**

---

# 13. Payment Resolution

Urutan pembayaran Rent:

```text
Calculate Final Rent
        ↓
Calculate Half Rent Split
        ↓
Resolve Tenant Payment
        ↓
Shield / Bankruptcy jika diperlukan
        ↓
Payment berhasil
        ↓
Distribute Full Rent
```

Uang tidak dibagikan kepada penerima sebelum kemampuan pembayaran Tenant selesai ditentukan.

---

# 14. Shield

## Fungsi

Shield adalah:

> **Universal protection terhadap Negative Balance.**

Bukan hanya untuk Rent.

---

## 14.1 Cara Kerja

Shield mencegah balance menjadi negatif.

Contoh:

```text
Balance = 5.000
Effect = -30.000
```

Tanpa Shield:

```text
-25.000
```

Dengan Shield:

```text
5.000 → 0
```

Shield menyerap bagian yang diperlukan agar balance tidak menjadi negatif.

---

## 14.2 Shield Tidak Membatalkan Effect

Player tetap kehilangan balance yang dimilikinya.

Shield hanya melindungi bagian yang akan membuat balance menjadi negatif.

---

## 14.3 One Shield = One Negative-Balance Event

Setelah Shield digunakan:

> **Shield Consumed**

Shield tidak melindungi event negatif berikutnya.

---

# 15. Shield + Rent

Shield menjamin:

> **Full Rent tetap dibayarkan.**

### Contoh

```text
Balance = 5.000
Rent = 8.000
Shield = Active
```

Hasil:

```text
Tenant membayar = 5.000
Shield menanggung = 3.000

Tenant Balance = 0
```

Penerima tetap menerima:

> **8.000 Rels penuh**

Jika Half Rent aktif, pembagian tetap dihitung dari:

> **8.000 Rels**

---

# 16. Bankruptcy Pipeline

Trigger utama:

> **Balance < 0**

Urutan:

```text
Negative Balance
      ↓
Bankruptcy Check
      ↓
Second Life?
   ↙       ↘
 YES        NO
  ↓          ↓
Second Life  Asset Liquidation
```

---

# 17. Second Life

Jika Second Life aktif saat Bankruptcy:

```text
Negative Balance
      ↓
Balance → 0
      ↓
+50.000 Rels
      ↓
Balance = 50.000
      ↓
Give 1 Shield
```

Tidak ada Asset Liquidation.

---

# 18. Asset Liquidation

Jika tidak ada Second Life:

> Player masuk Asset Liquidation.

Player memilih sendiri asset yang akan dijual.

Target:

> **Balance ≥ 0**

Begitu balance mencapai 0 atau lebih:

> Liquidation berhenti.

---

## 18.1 Property Sale

Property dijual kepada Bank dengan:

> **±80% Current Property Value**

Kemudian dibulatkan ke:

> **500 Rels**

Setelah dijual:

> **Unowned + L1**

Semua Property Modifier dihapus.

---

## 18.2 Crown Sale

Crown dijual kepada Bank dengan:

> **100% Crown Value**

Setelah dijual:

> **Unowned + Clean Crown**

Seluruh Crown Modifier/Status dihapus.

---

## 18.3 Set Saat Liquidation

Jika Property yang dijual merupakan anggota Set:

> **Set langsung break.**

Property lain dalam Set kehilangan:

> **+20% Set Bonus**

UI Liquidation memberikan warning sebelum penjualan:

> Property ini merupakan bagian dari Set. Menjualnya akan memutus Set.

Player tetap bebas menjualnya.

---

# 19. Final Bankruptcy

Jika:

* Balance < 0
* Tidak ada Second Life
* Tidak ada Shield yang relevan/tersisa
* Tidak ada asset yang bisa dilikuidasi

Maka:

> **Final Bankruptcy**

Player:

> **Eliminated → Spectator**

Seluruh sisa:

* Landing Resolution
* Post-Landing
* Turn

langsung berhenti.

---

# 20. Bankruptcy di Tengah Landing Resolution

Bankruptcy Resolution adalah:

> **Sub-process**

bukan Turn baru.

Jika Player berhasil diselamatkan:

> Kembali ke titik proses sebelumnya.

Effect yang sudah diproses:

> **Tidak diulang.**

Jika Final Bankruptcy:

> Seluruh sisa Landing Resolution berhenti.

---

# 21. City Levy

City Levy hanya mengambil dari:

> **Balance positif**

### Balance > 0

City Levy berjalan sesuai aturan:

> sekitar 25% Balance

kemudian dibagi sesuai sistem City Levy.

### Balance = 0

> City Levy = **0**

### Balance < 0

> City Levy = **0**

City Levy:

> **Tidak menciptakan Negative Balance.**

---

# 22. Round Completion

Round selesai ketika Player melewati:

> **39 → 0**

Urutan:

```text
Crossing 39 → 0
        ↓
Round selesai
        ↓
Round-based Modifier Timer diperbarui
        ↓
First Lap / Pass Start diproses
        ↓
Player tiba di Tile 0
        ↓
Landing Start Resolution
```

Jadi:

> **Round selesai sebelum Landing Start.**

---

# 23. Master Turn Flow

```text
TURN_START
    ↓
PRE_ROLL
    ↓
FAST TRAVEL / NORMAL ROLL
    ↓
MOVEMENT
    ↓
ROUND COMPLETION CHECK
    ↓
LANDING RESOLUTION
    ↓
TRANSACTION / EFFECT
    ↓
BANKRUPTCY CHECK
    ↓
POST-LANDING
    ↓
DOUBLE CHECK
   ↙       ↘
DOUBLE    NORMAL
  ↓          ↓
ROLL      TURN_END
```

---

# 24. Triple Double

Jika Player mendapatkan:

```text
Double #1
    ↓
Double #2
    ↓
Double #3
```

Pada Double ketiga:

> **Player langsung masuk Jail.**

Tidak ada movement dari Roll ketiga.

Tidak ada Landing Resolution dari Roll ketiga.

Kemudian:

> **TURN_END**

Double Counter di-reset.

---

# 25. Economy Constants — UPDATED

Angka terbaru:

| Sistem               |            Nilai |
| -------------------- | ---------------: |
| **Starting Capital** | **250.000 Rels** |
| **Pass Start**       | **+20.000 Rels** |
| **Landing Start**    | **+30.000 Rels** |
| **First Lap Total**  | **100.000 Rels** |
| **Normal Jail Exit** |  **25.000 Rels** |
| **Forced Jail Exit** |  **50.000 Rels** |

---

# 26. First Lap Rule

First Lap Reward:

> **100.000 Rels TOTAL**

100K sudah termasuk reward Start yang terjadi pada penyelesaian First Lap.

### First Lap + Pass Start

> **Total = 100.000 Rels**

Bukan:

> 100K + 20K

### First Lap + Landing Start

> **Total = 100.000 Rels**

Bukan:

> 100K + 30K

---

# 27. Starting Capital

Starting Capital terbaru:

> **250.000 Rels**

Angka lama:

> 100.000 Rels

sudah **deprecated** dan digantikan oleh:

> **250.000 Rels**

---

# 28. Core Principles dari Pembahasan Ini

### Economy

> Semua balance menggunakan kelipatan 500 Rels.

> Balance `≥ 0` tetap valid.

### Rent

> Hitung semua modifier terlebih dahulu, rounding hanya sekali di akhir.

### Modifier

> Same Modifier → Refresh.

> Different Modifier → Stack.

> Player Modifier → mengikuti Player.

> Property Modifier → mengikuti Property.

> Crown Modifier → mengikuti Crown.

### Ownership

> Property Transfer tidak me-reset Property Modifier.

> Property menjadi Unowned → semua Property Modifier dihapus.

> Reward hilang jika Player kehilangan ownership atas target Property.

### Bankruptcy

> Negative Balance langsung memicu Bankruptcy Check.

> Second Life diperiksa sebelum Asset Liquidation.

> Asset Liquidation berhenti ketika Balance ≥ 0.

> Final Bankruptcy menghentikan seluruh sisa Turn/Resolution.

### Shield

> Universal Negative-Balance Protection.

> Satu Shield hanya melindungi satu Negative-Balance Event.

> Shield menjamin Full Rent.

### Round

> Round = crossing 39 → 0.

> Round-based timer tidak menghitung Round saat modifier diperoleh.

> Round selesai sebelum Landing Start diproses.

### Start

> Pass Start = 20K.

> Landing Start = 30K.

> First Lap = 100K total.

### Jail

> Normal exit = 25K.

> Forced exit = 50K.

### Starting Money

> 250K Rels.

```
```

# RELOPOLI — PROPERTY ECONOMY D1–D4

**Status:** LOCKED
**Starting Capital:** 100,000 Rels
**Currency:** Rels
**Nominal Rule:** Semua nominal ekonomi menggunakan kelipatan **500 Rels**.

---

# 1. GENERAL PROPERTY SYSTEM

## 1.1 Property Levels

Setiap Property memiliki 5 Level:

| Level  | Status                               |
| ------ | ------------------------------------ |
| **L1** | Empty Land / Empty Lot               |
| **L2** | Small Building / Small Establishment |
| **L3** | Medium Building / Growing Business   |
| **L4** | Large Building / Major Development   |
| **L5** | Iconic Landmark                      |

Progression harus terasa **visual dan substantif**, bukan sekadar memperbesar bangunan.

---

## 1.2 Initial Property Purchase

Ketika pemain mendarat di Property yang **belum dimiliki**:

* Jika memiliki cukup Rels, Purchase UI muncul.
* UI menawarkan:

  * **Buy L1**
  * **Buy L2**
  * **Buy L3**
* **L4 dan L5 disabled** untuk initial purchase.
* Pemain dapat langsung membeli L1, L2, atau L3.
* Jika Rels tidak cukup untuk suatu level, pilihan tersebut tidak dapat dibeli.

**Purchase dan Upgrade adalah dua sistem yang berbeda.**

---

# 2. PROPERTY UPGRADE SYSTEM

## 2.1 Upgrade Hanya Saat Mendarat di Property Sendiri

Ketika pemain mendarat di Property miliknya sendiri:

* Price cards muncul kembali.
* Pemain dapat melakukan upgrade.
* Maksimal **1 upgrade per turn**.

Available progression:

* L1 → L2
* L1 → L3
* L2 → L3
* L3 → L4
* L4 → L5

Tidak boleh melewati requirement:

* L4 membutuhkan L3.
* L5 membutuhkan L4.

---

## 2.2 Hidden Installment Economy

Untuk setiap Property:

> **L1 → L2 → L3 lebih murah daripada langsung membeli L3.**

Pemain tidak diberi tahu secara eksplisit mengenai hidden saving ini.

Tujuannya agar pemain dapat menemukan melalui pengalaman bahwa investasi bertahap lebih efisien.

Tidak ada hidden installment discount untuk:

* L3 → L4
* L4 → L5

---

# 3. PROPERTY VALUE SYSTEM

Terdapat tiga konsep utama:

### Buy Value L1/L2/L3

Untuk Property yang belum dimiliki:

> Buy Value = harga pembelian level tersebut.

### Value L4

> **Value L4 = Buy L3 + Upgrade L3→L4**

Value L4 digunakan sebagai reference value untuk:

* pembelian Property L4 melalui landing;
* trade/transaction reference.

### Value L5

> **Value L5 = Value L4 + Upgrade L4→L5**

L5 **tidak dapat dibeli melalui landing**, tetapi Value L5 tetap dicatat sebagai reference value untuk trade/transaction.

---

# 4. BUYING ANOTHER PLAYER'S PROPERTY

Ketika pemain mendarat di Property milik pemain lain:

### Jika Property L1–L4:

1. Landing player membayar Rent kepada owner.
2. Jika landing player masih memiliki cukup Rels, opsi **Buy Property** muncul.
3. UI menampilkan current Property Value.
4. Buyer membayar Value tersebut kepada owner.
5. Ownership berpindah.
6. Level Property **tidak berubah**.

### Jika Property L5:

* Tidak dapat dibeli melalui landing.

### Crown:

* Tidak dapat dibeli melalui landing.

---

# 5. NORMAL TRADE

Property dapat berpindah melalui Trade/Transaction.

**Value bukan harga wajib dalam normal Trade.**

Players dapat melakukan negosiasi dengan harga/deal yang disepakati.

Property Level tidak berubah hanya karena ownership berpindah.

---

# 6. SET SYSTEM

Setiap District memiliki **tepat 1 official Set**.

Set terdiri dari **tepat 3 designated adjacent Properties**.

Property lain yang berdekatan tetapi tidak termasuk designation **tidak menjadi bagian Set**.

## Set Completion

Jika satu pemain memiliki seluruh 3 Property dalam sebuah Set:

> Set menjadi COMPLETE.

Set memberikan peningkatan Rent sekitar **+20%**.

Namun bonus **tidak dihitung menggunakan formula +20% secara kaku**.

Nilai Set Rent ditentukan langsung dan dibulatkan/diatur agar tetap menggunakan kelipatan **500 Rels**.

Jika salah satu dari 3 Property keluar dari kepemilikan pemain:

> Set BREAKS dan bonus Set hilang.

---

# 7. DISTRICT 1 — GROWING COMMUNITY

## Theme

Neighborhood yang berkembang menjadi vibrant community.

Vibe:

* green
* calm
* friendly
* residential/community
* commercial
* waterfront

## Properties

| Tile | Property         | Category                            |
| ---: | ---------------- | ----------------------------------- |
|    1 | Pinewood Lane    | Residential                         |
|    2 | Maple Row        | Residential                         |
|    4 | Willow Café      | F&B / Set #1                        |
|    5 | Sunny Market     | Commercial / Retail / Set #1        |
|    6 | Bloom Gardens    | Lifestyle / Public / Set #1         |
|    8 | Riverside Walk   | Commercial / Lifestyle / Waterfront |
|    9 | Harborview Hotel | Hospitality                         |

## Set #1

**Willow Café + Sunny Market + Bloom Gardens**

---

## 7.1 D1 Buy Value

| Tile | Property         | Buy L1 | Buy L2 | Buy L3 |
| ---: | ---------------- | -----: | -----: | -----: |
|    1 | Pinewood Lane    |  5,000 |  7,000 |  9,500 |
|    2 | Maple Row        |  5,500 |  7,500 | 10,500 |
|    4 | Willow Café      |  6,500 |  8,500 | 12,000 |
|    5 | Sunny Market     |  7,000 |  9,000 | 13,000 |
|    6 | Bloom Gardens    |  7,500 |  9,500 | 14,000 |
|    8 | Riverside Walk   |  8,500 | 10,500 | 15,000 |
|    9 | Harborview Hotel |  9,500 | 11,500 | 16,000 |

---

## 7.2 D1 Hidden Upgrade Cost

| Property         | L1→L2 | L2→L3 | Total from L1 |
| ---------------- | ----: | ----: | ------------: |
| Pinewood Lane    | 1,500 | 2,000 |         8,500 |
| Maple Row        | 1,500 | 2,500 |         9,500 |
| Willow Café      | 1,500 | 3,000 |        10,500 |
| Sunny Market     | 2,000 | 3,500 |        12,000 |
| Bloom Gardens    | 2,000 | 4,000 |        13,500 |
| Riverside Walk   | 2,000 | 4,000 |        14,500 |
| Harborview Hotel | 2,000 | 4,000 |        15,500 |

All are cheaper than direct Buy L3.

**Total Direct Buy L3:** 90,000 Rels
**Total via L1→L2→L3:** 84,000 Rels
**Total Hidden Saving:** 6,000 Rels

---

## 7.3 D1 L3→L4 & L4→L5

| Tile | Property         |  L3→L4 |  L4→L5 |
| ---: | ---------------- | -----: | -----: |
|    1 | Pinewood Lane    | 11,500 | 16,000 |
|    2 | Maple Row        | 13,000 | 18,000 |
|    4 | Willow Café      | 15,000 | 20,000 |
|    5 | Sunny Market     | 16,500 | 22,000 |
|    6 | Bloom Gardens    | 18,000 | 24,000 |
|    8 | Riverside Walk   | 18,500 | 26,000 |
|    9 | Harborview Hotel | 20,000 | 28,000 |

---

## 7.4 D1 Value L4/L5

| Property         | Value L4 | Value L5 |
| ---------------- | -------: | -------: |
| Pinewood Lane    |   21,000 |   37,000 |
| Maple Row        |   23,500 |   41,500 |
| Willow Café      |   27,000 |   47,000 |
| Sunny Market     |   29,500 |   51,500 |
| Bloom Gardens    |   32,000 |   56,000 |
| Riverside Walk   |   33,500 |   59,500 |
| Harborview Hotel |   36,000 |   64,000 |

---

## 7.5 D1 Rent Normal

| Tile | Property         |    L1 |    L2 |    L3 |     L4 |     L5 |
| ---: | ---------------- | ----: | ----: | ----: | -----: | -----: |
|    1 | Pinewood Lane    | 1,000 | 2,000 | 3,500 |  6,000 | 10,000 |
|    2 | Maple Row        | 1,000 | 2,000 | 4,000 |  6,500 | 11,000 |
|    4 | Willow Café      | 1,500 | 2,500 | 4,500 |  7,500 | 12,000 |
|    5 | Sunny Market     | 1,500 | 3,000 | 5,000 |  8,000 | 13,000 |
|    6 | Bloom Gardens    | 1,500 | 3,000 | 5,000 |  8,500 | 14,000 |
|    8 | Riverside Walk   | 2,000 | 4,000 | 5,500 |  9,000 | 15,000 |
|    9 | Harborview Hotel | 2,000 | 4,000 | 6,000 | 10,000 | 16,000 |

---

## 7.6 D1 Set #1 Rent

| Property      | L1 Set | L2 Set | L3 Set | L4 Set | L5 Set |
| ------------- | -----: | -----: | -----: | -----: | -----: |
| Willow Café   |  2,000 |  3,000 |  5,500 |  9,000 | 14,500 |
| Sunny Market  |  2,000 |  3,500 |  6,000 |  9,500 | 15,500 |
| Bloom Gardens |  2,000 |  3,500 |  6,000 | 10,000 | 17,000 |

---

# 8. DISTRICT 2 — URBAN COMMERCIAL DISTRICT

## Theme

Bustling urban district focused on:

* business
* shopping
* city life
* wider streets
* taller buildings
* signage
* retail
* plazas
* business activity

Not yet super-highrise downtown.

## Properties

| Tile | Property          | Category                               |
| ---: | ----------------- | -------------------------------------- |
|   11 | Metroline Offices | Corporate Business / Commercial Office |
|   12 | Lantern Square    | F&B / Lifestyle                        |
|   14 | Grand Avenue      | Commercial / Retail                    |
|   15 | Velvet Theater    | Entertainment / Performing Arts        |
|   17 | Central Brew      | F&B / Coffee / Set #2                  |
|   18 | Civic Plaza       | Lifestyle / Public / Set #2            |
|   19 | Skyline Suites    | Hospitality / Set #2                   |

## Set #2

**Central Brew + Civic Plaza + Skyline Suites**

---

## 8.1 D2 Buy Value

| Tile | Property          | Buy L1 | Buy L2 | Buy L3 |
| ---: | ----------------- | -----: | -----: | -----: |
|   11 | Metroline Offices | 11,500 | 14,000 | 17,000 |
|   12 | Lantern Square    | 12,500 | 15,000 | 18,500 |
|   14 | Grand Avenue      | 13,500 | 16,000 | 20,000 |
|   15 | Velvet Theater    | 14,000 | 17,000 | 22,000 |
|   17 | Central Brew      | 15,000 | 18,000 | 24,000 |
|   18 | Civic Plaza       | 16,000 | 19,000 | 26,000 |
|   19 | Skyline Suites    | 17,000 | 20,000 | 28,500 |

---

## 8.2 D2 Hidden Upgrade Cost

| Tile | Property          | L1→L2 | L2→L3 | Total from L1 | Direct Buy L3 | Hidden Saving |
| ---: | ----------------- | ----: | ----: | ------------: | ------------: | ------------: |
|   11 | Metroline Offices | 2,000 | 2,500 |        16,000 |        17,000 |         1,000 |
|   12 | Lantern Square    | 2,000 | 3,500 |        18,000 |        18,500 |           500 |
|   14 | Grand Avenue      | 2,000 | 3,500 |        19,000 |        20,000 |         1,000 |
|   15 | Velvet Theater    | 2,500 | 4,500 |        21,000 |        22,000 |         1,000 |
|   17 | Central Brew      | 2,500 | 5,500 |        23,000 |        24,000 |         1,000 |
|   18 | Civic Plaza       | 3,000 | 5,000 |        24,000 |        26,000 |         2,000 |
|   19 | Skyline Suites    | 3,000 | 6,000 |        26,000 |        28,500 |         2,500 |

**Total Direct Buy L3:** 156,000 Rels
**Total via L1→L2→L3:** 147,000 Rels
**Total Hidden Saving:** 9,000 Rels

---

## 8.3 D2 L3→L4 & L4→L5

| Tile | Property          |  L3→L4 |  L4→L5 |
| ---: | ----------------- | -----: | -----: |
|   11 | Metroline Offices | 20,000 | 28,000 |
|   12 | Lantern Square    | 21,500 | 29,500 |
|   14 | Grand Avenue      | 23,000 | 31,500 |
|   15 | Velvet Theater    | 25,000 | 34,000 |
|   17 | Central Brew      | 27,000 | 36,500 |
|   18 | Civic Plaza       | 29,000 | 39,000 |
|   19 | Skyline Suites    | 31,500 | 42,000 |

---

## 8.4 D2 Value L4/L5

| Tile | Property          | Value L4 | Value L5 |
| ---: | ----------------- | -------: | -------: |
|   11 | Metroline Offices |   37,000 |   65,000 |
|   12 | Lantern Square    |   40,000 |   69,500 |
|   14 | Grand Avenue      |   43,000 |   74,500 |
|   15 | Velvet Theater    |   47,000 |   81,000 |
|   17 | Central Brew      |   51,000 |   87,500 |
|   18 | Civic Plaza       |   55,000 |   94,000 |
|   19 | Skyline Suites    |   60,000 |  102,000 |

---

## 8.5 D2 Rent Normal

| Tile | Property          |    L1 |    L2 |    L3 |     L4 |     L5 |
| ---: | ----------------- | ----: | ----: | ----: | -----: | -----: |
|   11 | Metroline Offices | 2,000 | 3,000 | 5,000 |  8,000 | 13,000 |
|   12 | Lantern Square    | 2,000 | 3,000 | 5,000 |  8,500 | 14,000 |
|   14 | Grand Avenue      | 2,500 | 3,500 | 5,500 |  9,000 | 15,000 |
|   15 | Velvet Theater    | 2,500 | 4,000 | 6,000 | 10,000 | 16,000 |
|   17 | Central Brew      | 3,000 | 4,500 | 6,500 | 10,500 | 17,000 |
|   18 | Civic Plaza       | 3,000 | 5,000 | 7,000 | 11,500 | 18,500 |
|   19 | Skyline Suites    | 3,500 | 5,500 | 7,500 | 12,500 | 20,000 |

---

## 8.6 D2 Set #2 Rent

| Property       | L1 Set | L2 Set | L3 Set | L4 Set | L5 Set |
| -------------- | -----: | -----: | -----: | -----: | -----: |
| Central Brew   |  3,500 |  5,500 |  8,000 | 12,500 | 20,500 |
| Civic Plaza    |  3,500 |  6,000 |  8,500 | 14,000 | 22,000 |
| Skyline Suites |  4,500 |  6,500 |  9,000 | 15,000 | 24,000 |

---

# 9. DISTRICT 3 — ENTERTAINMENT & LEISURE DISTRICT

## Theme

> The city's ultimate destination for entertainment, leisure, and big experiences.

Vibe:

* exciting
* playful
* social
* colorful
* energetic
* large buildings
* expressive signage
* giant billboards
* decorative lighting
* large plazas
* entertainment venues
* outdoor attractions
* event banners
* fountains/water features

## Properties

| Tile | Property            | Category              |
| ---: | ------------------- | --------------------- |
|   21 | Pixel Plaza         | Gaming / Set #3       |
|   22 | Starfall Park       | Attraction / Set #3   |
|   23 | Starlight Arena     | Performance / Set #3  |
|   25 | Neon Bowl           | Recreation            |
|   26 | AquaVista           | Leisure / Aquatic     |
|   28 | Prism Cinema        | Cinema                |
|   29 | Grand Escape Resort | Hospitality / Leisure |

## Set #3

**Pixel Plaza + Starfall Park + Starlight Arena**

---

## 9.1 D3 Buy Value

| Tile | Property            | Buy L1 | Buy L2 | Buy L3 |
| ---: | ------------------- | -----: | -----: | -----: |
|   21 | Pixel Plaza         | 18,500 | 22,000 | 26,000 |
|   22 | Starfall Park       | 19,500 | 23,000 | 28,000 |
|   23 | Starlight Arena     | 20,500 | 24,500 | 30,000 |
|   25 | Neon Bowl           | 21,000 | 25,000 | 31,500 |
|   26 | AquaVista           | 22,000 | 26,500 | 33,000 |
|   28 | Prism Cinema        | 23,500 | 28,000 | 35,000 |
|   29 | Grand Escape Resort | 25,000 | 29,500 | 36,500 |

---

## 9.2 D3 Hidden Upgrade Cost

| Tile | Property            | L1→L2 | L2→L3 | Total from L1 | Direct Buy L3 | Hidden Saving |
| ---: | ------------------- | ----: | ----: | ------------: | ------------: | ------------: |
|   21 | Pixel Plaza         | 2,500 | 4,000 |        25,000 |        26,000 |         1,000 |
|   22 | Starfall Park       | 2,500 | 4,500 |        26,500 |        28,000 |         1,500 |
|   23 | Starlight Arena     | 3,000 | 4,500 |        28,000 |        30,000 |         2,000 |
|   25 | Neon Bowl           | 3,000 | 5,000 |        29,000 |        31,500 |         2,500 |
|   26 | AquaVista           | 3,000 | 5,500 |        30,500 |        33,000 |         2,500 |
|   28 | Prism Cinema        | 3,500 | 6,000 |        31,500 |        35,000 |         3,500 |
|   29 | Grand Escape Resort | 3,500 | 6,500 |        35,000 |        36,500 |         1,500 |

**Total Direct Buy L3:** 220,000 Rels
**Total via L1→L2→L3:** 205,500 Rels
**Total Hidden Saving:** 14,500 Rels

---

## 9.3 D3 L3→L4 & L4→L5

| Tile | Property            |  L3→L4 |  L4→L5 |
| ---: | ------------------- | -----: | -----: |
|   21 | Pixel Plaza         | 30,000 | 40,000 |
|   22 | Starfall Park       | 32,000 | 43,000 |
|   23 | Starlight Arena     | 34,000 | 46,000 |
|   25 | Neon Bowl           | 36,000 | 48,000 |
|   26 | AquaVista           | 38,000 | 51,000 |
|   28 | Prism Cinema        | 40,000 | 54,000 |
|   29 | Grand Escape Resort | 42,000 | 57,000 |

---

## 9.4 D3 Value L4/L5

| Tile | Property            | Value L4 | Value L5 |
| ---: | ------------------- | -------: | -------: |
|   21 | Pixel Plaza         |   56,000 |   96,000 |
|   22 | Starfall Park       |   60,000 |  103,000 |
|   23 | Starlight Arena     |   64,000 |  110,000 |
|   25 | Neon Bowl           |   67,500 |  115,500 |
|   26 | AquaVista           |   71,000 |  122,000 |
|   28 | Prism Cinema        |   75,000 |  129,000 |
|   29 | Grand Escape Resort |   78,500 |  135,500 |

---

## 9.5 D3 Rent Normal

| Tile | Property            |    L1 |    L2 |     L3 |     L4 |     L5 |
| ---: | ------------------- | ----: | ----: | -----: | -----: | -----: |
|   21 | Pixel Plaza         | 3,500 | 5,000 |  7,500 | 12,000 | 19,000 |
|   22 | Starfall Park       | 3,500 | 5,500 |  8,000 | 13,000 | 21,000 |
|   23 | Starlight Arena     | 4,000 | 6,000 |  8,500 | 14,000 | 23,000 |
|   25 | Neon Bowl           | 4,000 | 6,000 |  9,000 | 15,000 | 24,500 |
|   26 | AquaVista           | 4,500 | 6,500 |  9,500 | 16,000 | 26,000 |
|   28 | Prism Cinema        | 4,500 | 7,000 | 10,000 | 17,000 | 28,000 |
|   29 | Grand Escape Resort | 5,000 | 7,500 | 11,000 | 18,000 | 30,000 |

---

## 9.6 D3 Set #3 Rent

| Property        | L1 Set | L2 Set | L3 Set | L4 Set | L5 Set |
| --------------- | -----: | -----: | -----: | -----: | -----: |
| Pixel Plaza     |  4,000 |  6,000 |  9,000 | 14,500 | 23,000 |
| Starfall Park   |  4,000 |  6,500 |  9,500 | 15,500 | 25,500 |
| Starlight Arena |  5,000 |  7,000 | 10,000 | 17,000 | 28,000 |

---

# 10. DISTRICT 4 — LUXURY & PRESTIGE DISTRICT

## Theme

The most prestigious district.

Focus:

* fashion
* fine dining
* art
* luxury retail
* jewelry
* premium residences
* premium hotels

Vibe:

* elegant
* aspirational
* sophisticated
* bright
* stylized modern

## Properties

| Tile | Property           | Category                |
| ---: | ------------------ | ----------------------- |
|   31 | Aurelia Maison     | Luxury Fashion          |
|   32 | Celestia Dining    | Fine Dining             |
|   34 | Opaline Gallery    | Art / Set #4            |
|   35 | Maison Royale      | Luxury Retail / Set #4  |
|   36 | Lumina Jewel House | Jewelry / Set #4        |
|   38 | Grand Meridian     | Luxury Residential      |
|   39 | Celestial Heights  | Ultra-Premium Sky Hotel |

## Set #4

**Opaline Gallery + Maison Royale + Lumina Jewel House**

---

## 10.1 D4 Buy Value

| Tile | Property           | Buy L1 | Buy L2 | Buy L3 |
| ---: | ------------------ | -----: | -----: | -----: |
|   31 | Aurelia Maison     | 26,000 | 30,000 | 34,000 |
|   32 | Celestia Dining    | 27,000 | 31,500 | 37,000 |
|   34 | Opaline Gallery    | 28,500 | 33,000 | 40,000 |
|   35 | Maison Royale      | 30,000 | 35,000 | 42,500 |
|   36 | Lumina Jewel House | 31,500 | 37,000 | 45,000 |
|   38 | Grand Meridian     | 33,000 | 38,000 | 46,500 |
|   39 | Celestial Heights  | 34,000 | 39,000 | 48,000 |

---

## 10.2 D4 Hidden Upgrade Cost

| Tile | Property           | L1→L2 | L2→L3 | Total from L1 | Direct Buy L3 | Hidden Saving |
| ---: | ------------------ | ----: | ----: | ------------: | ------------: | ------------: |
|   31 | Aurelia Maison     | 3,000 | 4,000 |        33,000 |        34,000 |         1,000 |
|   32 | Celestia Dining    | 3,000 | 5,000 |        35,000 |        37,000 |         2,000 |
|   34 | Opaline Gallery    | 3,500 | 6,000 |        38,000 |        40,000 |         2,000 |
|   35 | Maison Royale      | 3,500 | 6,500 |        40,000 |        42,500 |         2,500 |
|   36 | Lumina Jewel House | 4,000 | 6,500 |        42,000 |        45,000 |         3,000 |
|   38 | Grand Meridian     | 4,000 | 7,000 |        44,000 |        46,500 |         2,500 |
|   39 | Celestial Heights  | 4,000 | 7,500 |        45,500 |        48,000 |         2,500 |

**Total Direct Buy L3:** 293,000 Rels
**Total via L1→L2→L3:** 277,500 Rels
**Total Hidden Saving:** 15,500 Rels

---

## 10.3 D4 L3→L4 & L4→L5

| Tile | Property           |  L3→L4 |  L4→L5 |
| ---: | ------------------ | -----: | -----: |
|   31 | Aurelia Maison     | 38,000 | 52,000 |
|   32 | Celestia Dining    | 41,000 | 55,000 |
|   34 | Opaline Gallery    | 44,000 | 58,000 |
|   35 | Maison Royale      | 47,000 | 62,000 |
|   36 | Lumina Jewel House | 50,000 | 66,000 |
|   38 | Grand Meridian     | 52,000 | 69,000 |
|   39 | Celestial Heights  | 54,000 | 72,000 |

---

## 10.4 D4 Value L4/L5

| Tile | Property           | Value L4 | Value L5 |
| ---: | ------------------ | -------: | -------: |
|   31 | Aurelia Maison     |   72,000 |  124,000 |
|   32 | Celestia Dining    |   78,000 |  133,000 |
|   34 | Opaline Gallery    |   84,000 |  142,000 |
|   35 | Maison Royale      |   89,500 |  151,500 |
|   36 | Lumina Jewel House |   95,000 |  161,000 |
|   38 | Grand Meridian     |   98,500 |  167,500 |
|   39 | Celestial Heights  |  102,000 |  174,000 |

---

## 10.5 D4 Rent Normal

| Tile | Property           |    L1 |    L2 |     L3 |     L4 |     L5 |
| ---: | ------------------ | ----: | ----: | -----: | -----: | -----: |
|   31 | Aurelia Maison     | 4,500 | 6,000 |  9,000 | 15,000 | 24,000 |
|   32 | Celestia Dining    | 4,500 | 6,500 |  9,500 | 16,000 | 26,000 |
|   34 | Opaline Gallery    | 5,000 | 7,000 | 10,000 | 17,000 | 28,000 |
|   35 | Maison Royale      | 5,000 | 7,500 | 10,500 | 18,000 | 30,000 |
|   36 | Lumina Jewel House | 5,500 | 8,000 | 11,500 | 19,000 | 32,000 |
|   38 | Grand Meridian     | 5,500 | 8,500 | 12,000 | 20,000 | 35,000 |
|   39 | Celestial Heights  | 6,000 | 9,000 | 13,000 | 22,000 | 38,000 |

---

## 10.6 D4 Set #4 Rent

| Property           | L1 Set | L2 Set | L3 Set | L4 Set | L5 Set |
| ------------------ | -----: | -----: | -----: | -----: | -----: |
| Opaline Gallery    |  6,000 |  8,500 | 12,000 | 20,500 | 34,000 |
| Maison Royale      |  6,000 |  9,000 | 12,500 | 22,000 | 36,000 |
| Lumina Jewel House |  6,500 |  9,500 | 14,000 | 23,000 | 39,000 |

---

# 11. ECONOMIC PROGRESSION AUDIT

## Starting Capital

**100,000 Rels**

This allows:

* D1 purchases to be relatively accessible.
* D2 purchases to become meaningful investment decisions.
* D3 purchases to require greater capital management.
* D4 purchases to become high-value strategic decisions.

---

## District Buy Progression

| District |  Buy L1 Range |  Buy L2 Range |  Buy L3 Range |
| -------- | ------------: | ------------: | ------------: |
| D1       |   5,000–9,500 |  7,000–11,500 |  9,500–16,000 |
| D2       | 11,500–17,000 | 14,000–20,000 | 17,000–28,500 |
| D3       | 18,500–25,000 | 22,000–29,500 | 26,000–36,500 |
| D4       | 26,000–34,000 | 30,000–39,000 | 34,000–48,000 |

Overall progression:

> **Growing Community → Urban Commercial → Entertainment & Leisure → Luxury & Prestige**

---

## Hidden Saving Progression

| District | Direct L3 Total | Staged L3 Total | Hidden Saving |
| -------- | --------------: | --------------: | ------------: |
| D1       |          90,000 |          84,000 |         6,000 |
| D2       |         156,000 |         147,000 |         9,000 |
| D3       |         220,000 |         205,500 |        14,500 |
| D4       |         293,000 |         277,500 |        15,500 |

The staged path is always cheaper than Direct Buy L3.

---

## Highest Normal Rent by District

| District | Property            |    L1 |     L3 |     L5 |
| -------- | ------------------- | ----: | -----: | -----: |
| D1       | Harborview Hotel    | 2,000 |  6,000 | 16,000 |
| D2       | Skyline Suites      | 3,500 |  7,500 | 20,000 |
| D3       | Grand Escape Resort | 5,000 | 11,000 | 30,000 |
| D4       | Celestial Heights   | 6,000 | 13,000 | 38,000 |

Rent progression clearly increases from D1 toward D4.

---

# 12. FINAL PROPERTY ECONOMY STATUS

**28 Properties:** COMPLETE

Each Property has:

* Buy Value L1
* Buy Value L2
* Buy Value L3
* Hidden L1→L2 cost
* Hidden L2→L3 cost
* L3→L4 cost
* L4→L5 cost
* Value L4
* Value L5
* Normal Rent L1–L5
* Set Rent L1–L5 where applicable

## Four Official Sets

1. **Set #1 — D1:** Willow Café + Sunny Market + Bloom Gardens
2. **Set #2 — D2:** Central Brew + Civic Plaza + Skyline Suites
3. **Set #3 — D3:** Pixel Plaza + Starfall Park + Starlight Arena
4. **Set #4 — D4:** Opaline Gallery + Maison Royale + Lumina Jewel House

## Locked Economic Principles

* Starting Capital = **100,000 Rels**
* All economic values use **500 Rels increments**
* L1/L2/L3 can be directly purchased when landing on an unowned Property
* L4/L5 cannot be initially purchased
* Maximum 1 upgrade per turn
* L1 can upgrade directly to L3
* Hidden saving exists only through L1→L2→L3
* L4 requires L3
* L5 requires L4
* L1–L4 can be purchased from another player upon landing
* L5 cannot be purchased through landing
* Crown cannot be purchased through landing
* Property ownership transfer does not change Property Level
* Normal Trade allows negotiated deals
* Property Value is a reference, not a mandatory Trade price
* Complete Set gives approximately +20% Rent
* Set bonus disappears when the Set is broken
* Exactly one official Set exists per District

**PROPERTY ECONOMY D1–D4: LOCKED.**
