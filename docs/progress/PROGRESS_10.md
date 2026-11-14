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
```

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

