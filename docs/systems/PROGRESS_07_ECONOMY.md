Siap. Berikut **rekap Brainstorm Economy Relopoli** yang sudah disesuaikan dengan keputusan terbaru, termasuk revisi terakhir mengenai **Negative Balance → Bankruptcy Check → Second Life → Asset Liquidation → Final Bankruptcy**. Saya juga memisahkan aturan Economy dari sistem lain agar tidak tercampur.

````markdown
# RELOPOLI — ECONOMY SYSTEM

> Status: 🔒 LOCKED
>
> Economy System mengatur Balance, Rent, Modifier ekonomi, pembayaran, Shield, Bankruptcy, Asset Liquidation, dan aturan dasar perputaran uang dalam Relopoli.

---

# 1. CURRENCY

Mata uang Relopoli:

> **Rels**

Semua transaksi ekonomi menggunakan Rels.

---

# 2. STARTING CAPITAL

Setiap player memulai permainan dengan:

> **250.000 Rels**

---

# 3. BALANCE RULE

Balance player menggunakan kelipatan:

> **500 Rels**

Contoh valid:

```text
250.000
125.500
10.000
500
0
````

Tidak ada balance dengan pecahan di luar kelipatan 500.

---

# 4. SOLVENCY

Player dianggap masih solvent apabila:

> **Balance ≥ 0**

Artinya:

```text
Balance > 0
→ Solvent

Balance = 0
→ Tetap Solvent

Balance < 0
→ Negative Balance
→ Bankruptcy Check
```

Player **boleh memiliki 0 Rels** dan tetap bermain.

---

# 5. NEGATIVE BALANCE

Negative Balance terjadi ketika suatu kewajiban ekonomi membuat:

> **Balance < 0**

Negative Balance tidak langsung berarti player otomatis keluar dari game.

Negative Balance memicu:

> **Bankruptcy Check**

---

# 6. BANKRUPTCY PIPELINE

Urutan final:

```text
NEGATIVE BALANCE
       ↓
BANKRUPTCY CHECK
       ↓
Punya Second Life?
   ↙             ↘
 YES              NO
  ↓                ↓
SECOND LIFE     ASSET LIQUIDATION
  ↓                ↓
Balance pulih   Jual aset
                   ↓
              Balance > 0?
                ↙     ↘
              YES      NO
               ↓        ↓
             Selesai   Jual aset lagi
                          ↓
                    Ada aset lagi?
                     ↙        ↘
                   YES        NO
                    ↓          ↓
                Jual lagi   BANKRUPT FINAL
                               ↓
                         Room Exit /
                       Spectator Mode
```

---

# 7. SECOND LIFE

Second Life merupakan mekanisme perlindungan terhadap Bankruptcy.

Jika pada Bankruptcy Check player masih memiliki:

> **Second Life**

maka Second Life langsung aktif.

Player:

```text
Negative Balance
      ↓
Balance → 0
      ↓
+50.000 Rels
      ↓
Balance = 50.000 Rels
      ↓
Give 1 Shield
```

Setelah Second Life aktif:

> **Asset Liquidation tidak dilakukan.**

Second Life hanya digunakan ketika Bankruptcy Check dipicu.

---

# 8. SECOND LIFE — IMPORTANT RULE

Second Life diperiksa:

> **sebelum Asset Liquidation**

Bukan setelah player mulai menjual aset.

Dengan demikian urutannya selalu:

```text
Negative Balance
↓
Bankruptcy Check
↓
Second Life?
↓
Jika tidak ada → Asset Liquidation
```

Tidak ada kondisi:

```text
Jual beberapa aset
↓
baru cek Second Life
```

---

# 9. SHIELD

Shield merupakan:

> **Universal protection terhadap Negative Balance.**

Shield mencegah suatu negative-balance event membuat Balance menjadi negatif.

---

## 9.1 Shield dan Pembayaran

Contoh:

```text
Balance = 5.000
Effect  = -30.000
Shield  = Active
```

Tanpa Shield:

```text
-25.000
```

Dengan Shield:

```text
Balance → 0
```

Shield menyerap bagian yang diperlukan agar balance tidak menjadi negatif.

---

# 10. SHIELD TIDAK MEMBATALKAN EFFECT

Shield tidak membuat effect menjadi gratis.

Player tetap kehilangan balance yang dimilikinya.

Contoh:

```text
Balance = 5.000
Rent    = 30.000
Shield  = Active
```

Player:

> kehilangan 5.000 Rels

Shield:

> melindungi 25.000 Rels sisanya.

Balance akhir:

> **0 Rels**

---

# 11. SHIELD CONSUMPTION

Satu Shield:

> **hanya melindungi satu Negative-Balance Event**

Setelah digunakan:

> **Shield consumed**

Shield tidak otomatis melindungi event negatif berikutnya.

---

# 12. SHIELD + RENT

Shield menjamin:

> **Full Rent tetap dapat diterima oleh penerima.**

Contoh:

```text
Tenant Balance = 5.000
Rent           = 8.000
Shield         = Active
```

Hasil:

```text
Tenant membayar      = 5.000
Shield menanggung    = 3.000
Tenant Balance       = 0
```

Penerima tetap menerima:

> **8.000 Rels penuh**

Jika Half Rent aktif, pembagian tetap dihitung dari:

> **8.000 Rels Final Rent**

bukan hanya 5.000 Rels yang berasal dari balance tenant.

---

# 13. ASSET LIQUIDATION

Jika player:

* memiliki Negative Balance,
* tidak memiliki Second Life,

maka player masuk:

> **Asset Liquidation**

Tujuan liquidation:

> Membuat Balance kembali menjadi **≥ 0**

---

# 14. ASSET LIQUIDATION — PLAYER CONTROL

Player memilih sendiri aset yang ingin dijual.

System tidak secara otomatis memilih aset player.

Player dapat memilih aset yang tersedia sampai:

> **Balance ≥ 0**

---

# 15. LIQUIDATION LOOP

Flow:

```text
Negative Balance
      ↓
Bankruptcy Check
      ↓
No Second Life
      ↓
Asset Liquidation
      ↓
Ada aset?
      ↓
Player menjual aset
      ↓
Balance diperbarui
      ↓
Balance > 0?
   ↙          ↘
 YES           NO
  ↓             ↓
SELESAI       Ada aset lagi?
                ↙       ↘
              YES       NO
               ↓         ↓
           Jual lagi  Final Bankruptcy
```

Catatan:

> Jika Balance mencapai **0**, player sudah solvent dan liquidation selesai.

Tidak perlu menjual aset tambahan.

---

# 16. PROPERTY LIQUIDATION

Ketika Property dijual dalam Asset Liquidation:

> Player menerima sekitar **80% Current Property Value**

Nilai kemudian dibulatkan ke:

> **Kelipatan 500 Rels**

---

# 17. PROPERTY SETELAH DIJUAL

Property yang dijual menjadi:

> **Unowned + L1 / Empty Land**

Semua Property Modifier dihapus.

Termasuk:

* Reward
* Premium Listing
* Falling Demand
* Half Rent
* Property Slump
* Modifier Property lainnya

Property kembali menjadi kondisi:

> **Clean**

dan dapat dibeli player lain sesuai aturan Property.

---

# 18. SET BREAK

Jika Property yang dijual merupakan bagian dari Set:

> **Set langsung broken**

Property lain yang sebelumnya mendapat:

> **+20% Set Bonus**

tidak lagi mendapatkan Set Bonus tersebut.

Sistem harus memberikan warning sebelum liquidation confirmation.

Contoh:

> `Property ini merupakan bagian dari Set. Menjualnya akan memutus Set.`

Player tetap dapat memilih untuk menjualnya.

---

# 19. CROWN LIQUIDATION

Crown dapat dijual dalam Asset Liquidation.

Nilai penjualan:

> **100% Crown Value**

Setelah Crown dijual:

> **Unowned + Clean Crown**

Semua Crown Modifier/Status yang melekat pada Crown tersebut dihapus.

Termasuk:

* Crown Prosperity
* Crown Disruption
* Status Crown lainnya

---

# 20. CROWN DAN SETELAH DIJUAL

Crown yang dijual:

* Tidak lagi dimiliki player.
* Tidak lagi memberikan Crown Reward.
* Tidak lagi memiliki modifier lama.
* Dapat dimiliki kembali sesuai aturan Crown.

---

# 21. FINAL BANKRUPTCY

Player menjadi:

> **Bankrupt Final**

jika:

```text
Balance < 0
AND
Tidak punya Second Life
AND
Tidak ada aset yang dapat dilikuidasi
```

Maka:

> Player tidak dapat melanjutkan permainan sebagai active player.

---

# 22. AFTER FINAL BANKRUPTCY

Setelah Final Bankruptcy:

> **Player keluar dari Room / masuk Spectator Mode**

Player tidak lagi menjalankan:

* Roll
* Movement
* Landing Resolution
* Transaction
* Economy Resolution
* Turn berikutnya

Player dianggap:

> **Eliminated**

---

# 23. BANKRUPTCY DI TENGAH RESOLUTION

Bankruptcy merupakan:

> **Sub-process dari Turn**

Bukan Turn baru.

Contoh:

```text
Landing
 ↓
Payment
 ↓
Negative Balance
 ↓
Bankruptcy Check
 ↓
Second Life / Liquidation
 ↓
Kembali ke proses sebelumnya
```

Jika player berhasil diselamatkan:

> Turn tetap berlanjut dari titik proses yang benar.

Effect yang sudah diproses:

> **Tidak diulang.**

---

# 24. FINAL BANKRUPTCY DI TENGAH TURN

Jika Final Bankruptcy terjadi:

> Seluruh sisa proses Turn dihentikan.

Contoh:

```text
Landing
 ↓
Payment
 ↓
Negative Balance
 ↓
Bankruptcy
 ↓
Tidak ada aset
 ↓
FINAL BANKRUPTCY
 ↓
Spectator Mode
```

Tidak ada:

* Extra Roll
* Landing Effect berikutnya
* Post-Landing
* Turn End normal

Player langsung keluar dari active game flow.

---

# 25. RENT CALCULATION

Rent dihitung dalam urutan:

```text
Property Slump Check
        ↓
Base Rent
        ↓
Set Bonus
        ↓
Rent Multipliers
        ↓
Final Rounding
        ↓
Half Rent Split
        ↓
Payment
```

---

# 26. PROPERTY SLUMP

Jika Property sedang:

> **Inactive / Property Slump**

maka:

> **Rent = 0**

Property Slump memiliki prioritas sebelum perhitungan Rent lainnya.

Tidak ada Rent yang dibayarkan dari Property tersebut selama status Slump aktif.

---

# 27. BASE RENT

Jika Property aktif:

> System mengambil Base Rent sesuai level Property.

Contoh:

```text
Property L3
↓
Ambil Base Rent L3
```

---

# 28. SET BONUS

Jika Property merupakan bagian dari Set lengkap:

> **Rent × 1.2**

atau:

> **+20% Rent**

Set Bonus dihitung sebelum Rent Multiplier lainnya.

---

# 29. RENT MULTIPLIERS

Modifier Rent dapat melakukan stacking.

Modifier yang berbeda:

> **Stack**

Contoh:

```text
Reward ×3
Premium Listing ×1.5
Falling Demand ×0.5
```

Perhitungan:

```text
Base Rent
× 3
× 1.5
× 0.5
```

---

# 30. SAME MODIFIER

Jika modifier yang sama diberikan kembali:

> **Refresh Duration**

Bukan stacking.

Contoh:

```text
Premium Listing
2 Rounds tersisa

↓ mendapat Premium Listing lagi

Premium Listing
3 Rounds
```

Tidak menjadi:

```text
×1.5 × 1.5
```

---

# 31. RENT ROUNDING

Semua modifier dihitung terlebih dahulu.

Tidak ada rounding di tengah perhitungan.

Rounding hanya dilakukan:

> **Sekali di akhir**

ke kelipatan:

> **500 Rels**

Contoh:

```text
Base Rent = 7.500
× 1.2
× 1.5
× 0.5

= 6.750

Final Rent
= 7.000 Rels
```

---

# 32. HALF RENT

Half Rent tidak mengurangi kewajiban tenant.

Tenant tetap membayar:

> **100% Final Rent**

Kemudian Final Rent dibagi:

```text
50% → Half Rent Holder
50% → Property Owner
```

Jika pembagian menghasilkan angka yang bukan kelipatan 500:

> Bagian Half Rent Holder dibulatkan ke bawah ke kelipatan 500.

Sisa diberikan kepada Property Owner.

Contoh:

```text
Final Rent = 7.500

Half Rent Holder = 3.500
Property Owner   = 4.000

Total             = 7.500
```

Dengan demikian:

> **Total penerimaan selalu sama dengan Final Rent.**

---

# 33. HALF RENT + OWNERSHIP

Jika Half Rent Holder kemudian menjadi owner Property:

> **Half Rent langsung berakhir.**

Property tidak membayar Half Rent kepada dirinya sendiri.

---

# 34. HALF RENT TARGET

Satu Property hanya dapat memiliki:

> **1 Half Rent Holder**

Jika Property sudah memiliki Half Rent:

> Half Rent baru tidak dapat diterapkan.

Jika News/efek Half Rent tidak menemukan target valid:

> News tetap tersedia sesuai aturan Stored News.

---

# 35. MODIFIER OWNERSHIP

Modifier memiliki tiga kategori utama.

### Player Modifier

Mengikuti:

> **Player**

Contoh:

* Reward

Jika player kehilangan Property:

> Modifier Player tetap mengikuti player selama efeknya memang merupakan Player Modifier.

---

### Property Modifier

Mengikuti:

> **Property**

Contoh:

* Premium Listing
* Falling Demand
* Half Rent
* Property Slump

Jika Property berpindah ownership:

> Modifier tetap mengikuti Property.

---

### Crown Modifier

Crown Modifier dan Crown Status dapat melekat pada Crown selama Crown tersebut belum berpindah ownership.

Contoh:

- Crown Prosperity
- Crown Disruption

**Aturan ownership transfer:**

Jika Crown berpindah ownership melalui mekanisme transfer yang diizinkan:

> **Crown di-reset menjadi Clean Crown.**

Semua Crown Modifier dan Crown Status dihapus, termasuk Crown Prosperity dan Crown Disruption.

Semua timer dan sisa durasi modifier/status juga dihapus.

Pemilik baru menerima Crown dalam kondisi Clean dan tidak mewarisi modifier atau status pemilik sebelumnya.

Aturan ini berbeda dari Property Modifier. Property Modifier tetap mengikuti Property saat ownership berpindah, kecuali ada aturan khusus yang menyatakan sebaliknya.

**Catatan:** Ketentuan lama yang menyatakan bahwa Crown Modifier atau Crown Status mengikuti Crown setelah ownership berpindah sudah tidak berlaku. Lihat `Progress 20 — Source Correction: Crown Ownership Transfer` untuk aturan final.

---

# 36. PROPERTY TRANSFER

Jika Property berpindah ownership melalui:

* Trade
* Property Seizure
* Grand Exchange
* Forced Transaction
* Mekanik transfer lainnya

maka:

> **Property Modifier tetap melekat pada Property**

Timer:

> **Tidak di-reset**

Modifier tidak menjadi efek baru hanya karena ownership berubah.

---

# 37. PROPERTY → UNOWNED

Jika Property menjadi Unowned:

> Semua Property Modifier dihapus.

Property kembali menjadi:

```text
Unowned
+
L1 / Empty Land
+
Clean State
```

Property yang kemudian dibeli player baru:

> Tidak membawa modifier lama.

---

# 38. MODIFIER DURATION

Modifier yang menggunakan durasi:

> **3 putaran**

Contoh:

* Reward
* Premium Listing
* Falling Demand
* Half Rent
* Crown Prosperity

---

# 39. ARTI 3 PUTARAN

Untuk modifier player:

> **3 putaran = 3 giliran player yang bersangkutan**

Round saat modifier diperoleh:

> **Tidak dihitung**

Contoh:

```text
Player mendapat modifier pada Turn 4

Turn 4 → tidak dihitung
Turn 5 → 1
Turn 6 → 2
Turn 7 → 3
```

Setelah Turn 7 selesai:

> Modifier expired.

Giliran player lain:

> Tidak mengurangi durasi modifier player tersebut.

---

# 40. PROPERTY MODIFIER + OWNERSHIP TRANSFER

Jika Property memiliki modifier lalu berpindah ownership:

```text
Property A
+ Falling Demand
```

kemudian:

```text
Player A
 ↓
Player B
```

maka:

```text
Property A
+ Falling Demand
```

tetap aktif.

Timer tetap berjalan berdasarkan:

> **Time Reference saat modifier pertama kali dibuat**

Timer tidak berubah menjadi 3 putaran baru.

---

# 41. CROWN ECONOMY

Crown Reward dihitung berdasarkan jumlah Property yang dimiliki player di district Crown.

Formula:

```text
Jumlah Property di Crown District
× 1.000 Rels
```

Maksimum:

> **7.000 Rels**

---

# 42. CROWN PROSPERITY

Crown Prosperity memberikan:

> **+2.000 Rels**

kepada Crown Reward.

Jika player memiliki 5 Property:

```text
Base Reward = 5.000
Prosperity  = 2.000

Total = 7.000 Rels
```

Durasi:

> **3 putaran**

Jika Prosperity diberikan lagi pada Crown yang sama:

> **Refresh menjadi 3 putaran**

Bukan stacking.

---

# 43. CROWN DISRUPTION

Jika Crown terkena Disruption:

> **Crown Reward berikutnya = 0**

Crown Prosperity:

> **Tidak dihapus**

Timer Prosperity:

> **Tetap berjalan**

Disruption tidak melakukan pause timer.

---

# 44. CROWN BREAKER

Jika Crown dihancurkan:

```text
Crown
↓
Destroyed
↓
Unowned
↓
Clean
```

Semua status/modifier Crown tersebut hilang.

Termasuk:

* Crown Prosperity
* Crown Disruption
* status Crown lainnya

---

# 45. CITY LEVY

City Levy hanya mengambil dari:

> **Balance positif**

Jika:

```text
Balance > 0
```

maka City Levy dapat diproses sesuai aturan:

> **25% Balance**

Nominal menggunakan kelipatan:

> **500 Rels**

Jika:

```text
Balance = 0
```

maka:

> **City Levy = 0**

Jika balance sudah negatif:

> City Levy tidak mengambil tambahan.

City Levy tidak boleh menciptakan Negative Balance baru.

---

# 46. PAYMENT RESOLUTION

Payment menggunakan urutan:

```text
Calculate Final Rent
        ↓
Calculate Half Rent Split
        ↓
Check Tenant Payment
        ↓
Resolve Shield / Bankruptcy
        ↓
Payment Completed
        ↓
Distribute Full Rent
```

Penerima tidak boleh menerima sebagian pembayaran sebelum sistem mengetahui apakah tenant mampu memenuhi kewajiban menggunakan:

* Balance
* Shield
* Second Life
* Asset Liquidation

---

# 47. FULL RENT PRINCIPLE

Jika suatu transaksi menyatakan tenant harus membayar:

> **Final Rent**

maka jumlah kewajiban tetap Final Rent.

Shield tidak mengurangi kewajiban tersebut.

Second Life tidak mengurangi kewajiban tersebut.

Asset Liquidation tidak mengurangi kewajiban tersebut.

Mekanisme tersebut hanya menentukan:

> **bagaimana player dapat memenuhi kewajiban atau mencegah Bankruptcy.**

---

# 48. ECONOMY + START

Nilai ekonomi Start:

| Mekanik          |                  Nilai |
| ---------------- | ---------------------: |
| Starting Capital |       **250.000 Rels** |
| Pass Start       |       **+20.000 Rels** |
| Landing Start    |       **+30.000 Rels** |
| First Lap        | **100.000 Rels total** |

First Lap:

> **menggantikan bonus Rels Start pada movement tersebut**

Jadi:

```text
First Lap + Pass Start
→ 100.000 total

First Lap + Landing Start
→ 100.000 total
```

Bukan:

```text
100.000 + 20.000
```

atau:

```text
100.000 + 30.000
```

Jika Landing Start terjadi pada First Lap:

> Efek upgrade Start tetap diberikan.

---

# 49. REWARD PAYMENT TIMING

Reward Start tidak dibayarkan ketika player baru melewati Start.

Urutannya:

```text
Movement
 ↓
Movement Complete
 ↓
Detect Start
 ↓
Check First Lap
 ↓
Determine Reward
 ↓
Pay Reward
 ↓
Resolve Destination
 ↓
Landing Effect
```

Ini berlaku untuk:

* Normal Roll
* Double
* Multiple Double
* Forced Movement
* Transport
* Movement lain yang sah

---

# 50. ECONOMY CORE RULES

### Balance

> **Balance ≥ 0 = Solvent**

### Negative Balance

> **Negative Balance → Bankruptcy Check**

### Bankruptcy

> **Second Life diperiksa sebelum Asset Liquidation**

### Liquidation

> **Player menjual aset sendiri sampai Balance ≥ 0**

### Final Bankruptcy

> **Tidak punya Second Life + tidak ada aset + Balance tetap negatif**

→ **Eliminated / Spectator**

### Rent

> **Modifier dihitung terlebih dahulu, rounding hanya sekali di akhir**

### Modifier

> **Same Modifier = Refresh**

> **Different Modifier = Stack**

### Ownership

> **Property Modifier mengikuti Property**

> **Crown Modifier mengikuti Crown**

### Unowned

> **Property/Crown menjadi Unowned → modifier lama dibersihkan**

### Shield

> **Satu Shield melindungi satu Negative-Balance Event**

### Full Rent

> **Tenant wajib menyelesaikan Full Rent**

### Start

> **Reward dibayarkan setelah Movement selesai**

---

# 51. MASTER ECONOMY FLOW

```text
TRANSACTION / EFFECT
        ↓
CALCULATE ECONOMIC VALUE
        ↓
ROUND TO 500 RELS
        ↓
CHECK PAYMENT
        ↓
Balance sufficient?
   ↙             ↘
 YES              NO
  ↓                ↓
PAYMENT        Negative Balance
COMPLETE             ↓
  ↓            BANKRUPTCY CHECK
  ↓                  ↓
  ↓          Has Second Life?
  ↓             ↙         ↘
  ↓           YES          NO
  ↓            ↓            ↓
  ↓       SECOND LIFE   ASSET LIQUIDATION
  ↓            ↓            ↓
  ↓        Balance 50K    Sell Asset
  ↓            ↓            ↓
  ↓        Give Shield   Balance ≥ 0?
  ↓                         ↙      ↘
  ↓                       YES       NO
  ↓                        ↓         ↓
  ↓                     RESUME   More Asset?
  ↓                                  ↙  ↘
  ↓                                YES   NO
  ↓                                 ↓     ↓
  ↓                              SELL    FINAL
  ↓                              AGAIN  BANKRUPTCY
  ↓                                        ↓
PAYMENT COMPLETE                       SPECTATOR
```

---

# 52. FINAL ECONOMY STATUS

| Component                      | Status    |
| ------------------------------ | --------- |
| Starting Capital — 250K        | 🔒 LOCKED |
| Balance Unit — 500 Rels        | 🔒 LOCKED |
| Balance 0 = Solvent            | 🔒 LOCKED |
| Negative Balance Detection     | 🔒 LOCKED |
| Bankruptcy Check               | 🔒 LOCKED |
| Second Life Before Liquidation | 🔒 LOCKED |
| Second Life = 50K + Shield     | 🔒 LOCKED |
| Asset Liquidation              | 🔒 LOCKED |
| Player Chooses Asset           | 🔒 LOCKED |
| Property Sale ≈ 80% Value      | 🔒 LOCKED |
| Crown Sale = 100% Value        | 🔒 LOCKED |
| Set Break on Property Sale     | 🔒 LOCKED |
| Final Bankruptcy               | 🔒 LOCKED |
| Spectator After Bankruptcy     | 🔒 LOCKED |
| Rent Calculation               | 🔒 LOCKED |
| Set Bonus +20%                 | 🔒 LOCKED |
| Rent Rounding — 500            | 🔒 LOCKED |
| Same Modifier = Refresh        | 🔒 LOCKED |
| Different Modifier = Stack     | 🔒 LOCKED |
| Half Rent                      | 🔒 LOCKED |
| Shield                         | 🔒 LOCKED |
| Crown Economy                  | 🔒 LOCKED |
| City Levy                      | 🔒 LOCKED |
| Start Economy                  | 🔒 LOCKED |
| First Lap = 100K Total         | 🔒 LOCKED |
| Reward Timing After Movement   | 🔒 LOCKED |

---

# FINAL ECONOMY PRINCIPLE

> **Economy Relopoli selalu berusaha menyelesaikan kewajiban finansial player tanpa langsung mengeliminasi player. Negative Balance terlebih dahulu memicu Bankruptcy Check. Jika memiliki Second Life, Second Life aktif. Jika tidak, player masuk Asset Liquidation dan menjual aset sampai Balance kembali ≥ 0. Hanya jika seluruh aset habis dan Balance masih negatif, player mengalami Final Bankruptcy dan keluar dari active game sebagai Spectator.**

**ECONOMY SYSTEM — BRAINSTORM SELESAI / LOCKED 🔒**

```

Rekap ini juga menyatukan keputusan terbaru yang kamu tegaskan tadi: **Second Life selalu dicek sebelum Asset Liquidation**, dan liquidation berjalan berulang sampai **Balance ≥ 0** atau **tidak ada aset lagi**. :contentReference[oaicite:0]{index=0}
```

Berikut rekap **Brainstorm Roll Relopoli** dalam format Markdown:

````markdown
# 🎲 Relopoli — Roll System
## Status: 🔒 LOCKED

### 1. Awal Turn
- Setiap **Normal Turn selalu dimulai dengan Roll**.
- Roll menggunakan **2 dadu fisik**.
- Kedua dadu harus benar-benar berhenti sebelum hasil dibaca.

---

### 2. Pembacaan Dadu
- Hasil dadu dibaca dari **sisi atas (Top Face)**.
- Sistem menggunakan **Raycast dari atas** untuk membaca angka dadu.
- Area Roll memiliki **physical barrier** agar dadu tetap berada di area yang ditentukan.

#### Invalid Result
Jika:
- dadu belum berhenti,
- posisi dadu ambigu,
- raycast gagal,
- top face tidak dapat dibaca dengan valid,

maka hasil **tidak digunakan**.

Sistem melakukan validasi/retry sampai mendapatkan hasil yang valid.

---

### 3. Total Roll

Total movement ditentukan dari jumlah kedua dadu:

| Dadu 1 | Dadu 2 | Total Movement |
|---:|---:|---:|
| 1 | 1 | 2 |
| 1 | 2 | 3 |
| ... | ... | ... |
| 6 | 6 | 12 |

- Nilai Roll berada di antara **2–12**.
- Normal Dice Movement selalu bergerak **Forward**.
- Setelah hasil valid diperoleh, sistem menghitung destination.

---

### 4. Double

**Double** terjadi ketika kedua dadu memiliki angka yang sama.

Contoh:

- 1 + 1 = Double
- 2 + 2 = Double
- 3 + 3 = Double
- 4 + 4 = Double
- 5 + 5 = Double
- 6 + 6 = Double

#### Efek Double
- Movement tetap menggunakan **jumlah kedua dadu**.
- Double **tidak menggandakan nilai movement**.

Contoh:

> 4 + 4 = 8 movement

Setelah movement dan landing resolution selesai:

> Double → mendapatkan **1 Extra Roll**

Multiple Double dapat terjadi dalam satu turn.

---

### 5. Double Counter

- Double Counter berlaku **per turn**.
- Counter di-reset ketika turn berakhir.
- Setiap Double berturut-turut menambah counter.

Contoh:

```text
Roll 1 → Double
        ↓
Movement + Landing
        ↓
Extra Roll

Roll 2 → Double
        ↓
Movement + Landing
        ↓
Extra Roll

Roll 3 → Double
        ↓
TRIPLE DOUBLE
````

---

### 6. Triple Double

Jika player mendapatkan **3 Double berturut-turut dalam satu turn**:

> **Triple Double → langsung Jail**

Ketika Triple Double terjadi:

* ❌ Tidak melakukan movement dari roll ketiga.
* ❌ Tidak melakukan Landing Resolution.
* ❌ Tidak mendapatkan Extra Roll.
* ✅ Player langsung masuk Jail.
* ✅ Turn langsung berakhir.

Jadi:

```text
Double #1
   ↓
Movement
   ↓
Landing Resolution
   ↓
Extra Roll

Double #2
   ↓
Movement
   ↓
Landing Resolution
   ↓
Extra Roll

Double #3
   ↓
TRIPLE DOUBLE
   ↓
JAIL
   ↓
TURN END
```

---

### 7. Destination

Setelah hasil dadu valid:

1. Hitung total movement.
2. Hitung destination berdasarkan board path.
3. Tentukan path movement.
4. Tampilkan **Destination Arrow**.
5. Movement Engine menjalankan movement.

Destination Arrow:

* menunjukkan **tile tujuan**,
* bukan menunjukkan keseluruhan jalur,
* muncul setelah destination diketahui,
* dihapus setelah movement selesai.

---

### 8. Hubungan Roll dengan Movement Engine

Roll System bertanggung jawab atas:

* Physical Dice Roll
* Dice Result Detection
* Result Validation
* Total Dice Calculation
* Double Detection
* Double Counter
* Triple Double Detection
* Destination Calculation Trigger
* Destination Arrow Trigger

Sedangkan **Movement Engine** bertanggung jawab atas:

* Menentukan path movement.
* Menjalankan character movement.
* Smooth movement.
* Mengikuti jalur board.
* Start Detection selama movement.
* Menyelesaikan movement sampai destination.

Roll dan Movement **tidak menjadi satu sistem**.

---

### 9. Urutan Normal Roll

```text
START NORMAL TURN
        ↓
ROLL 2 DICE
        ↓
DICE STOP
        ↓
READ TOP FACE
        ↓
VALIDATE RESULT
        ↓
INVALID?
 ┌──────┴──────┐
 YES           NO
  ↓             ↓
RETRY      CALCULATE TOTAL
                ↓
          CHECK DOUBLE
                ↓
       Triple Double?
        ┌───────┴───────┐
       YES              NO
        ↓                ↓
      JAIL          CALCULATE
        ↓            DESTINATION
   TURN END              ↓
                     MOVEMENT
                         ↓
                 START DETECTION
                         ↓
                 START REWARD
                         ↓
               LANDING RESOLUTION
                         ↓
                    DOUBLE?
                  ┌──────┴──────┐
                 YES            NO
                  ↓              ↓
              EXTRA ROLL      TURN END
                  ↓
                ROLL
```

---

### 10. Double Movement

Double **tidak berarti movement dua kali lipat**.

Contoh:

```text
Dice: 4 + 4
Total: 8

Movement #1:
8 tiles

Landing Resolution

Double detected
        ↓
Extra Roll

Movement #2:
sesuai hasil roll berikutnya
```

Jadi Double memberikan **kesempatan Roll tambahan**, bukan tambahan movement dari roll yang sama.

---

### 11. Prinsip Utama

> **Setiap Normal Turn dimulai dengan Roll.**

> **Double menggunakan total normal dadu dan memberikan Extra Roll setelah movement + landing selesai.**

> **Triple Double menghentikan turn dan langsung memasukkan player ke Jail tanpa movement dari roll ketiga.**

> **Roll System menentukan hasil dadu dan trigger movement, sedangkan Movement Engine menjalankan movement secara fisik.**

```
```