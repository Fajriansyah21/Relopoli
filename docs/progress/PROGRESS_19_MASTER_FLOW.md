Siap. Aku rekap **Progress 19 — System Integration & Turn Flow Audit** berdasarkan hasil pembahasan kita, termasuk hasil Full Game Flow Audit terakhir.

# RELOPOLI — PROGRESS 19

# SYSTEM INTEGRATION & TURN FLOW AUDIT

> Status: **BRAINSTORM SELESAI / INTEGRATION AUDIT LOCKED**
>
> Tujuan Progress 19 adalah menyatukan seluruh sistem yang sebelumnya sudah dibahas menjadi satu alur permainan yang konsisten, bukan menambahkan fitur baru.

---

# 1. TURN CONTROLLER

Turn Controller menjadi **central authority** untuk seluruh Turn Flow.

```text
Turn Controller
├── News Phase
├── Roll
├── Dice Resolution
├── Movement
├── Landing Resolution
├── Special Resolution / UI
├── Victory Check
├── Extra Roll Check
└── Turn End
```

Sistem lain seperti:

* Property
* Crown
* News
* Reward
* Transport
* Jail
* Economy

tidak menentukan pergantian Turn secara independen.

Mereka menyelesaikan prosesnya dan mengembalikan hasil kepada Turn Controller.

---

# 2. RESOLUTION CHAIN

Satu Turn dapat memiliki beberapa Resolution secara berurutan.

```text
Resolution A
↓
Resolution B
↓
Resolution C
↓
Turn End
```

Contoh:

```text
News
↓
Movement
↓
Landing Resolution
↓
Property Resolution
↓
Economy Resolution
↓
Turn Continue
```

Jika sebuah sistem menghasilkan Movement tambahan:

```text
Movement
↓
Movement Complete
↓
Start / First Lap
↓
Landing Resolution
```

kecuali effect tersebut secara eksplisit menentukan bahwa Turn berakhir atau memiliki flow khusus.

---

# 3. TURN END

Turn tidak berakhir hanya karena Player sudah mendarat di sebuah Tile.

Turn baru berakhir setelah:

1. Movement selesai.
2. Start / First Lap selesai.
3. Landing Resolution selesai.
4. Special Resolution selesai.
5. Blocking UI selesai.
6. Tidak ada Resolution Chain lanjutan.
7. Tidak ada Extra Roll.
8. Tidak ada State yang mengambil alih Turn.

Prinsip:

> **Turn End terjadi ketika seluruh Resolution Chain selesai dan tidak ada proses lain yang masih menunggu.**

---

# 4. NEWS PHASE

Pada awal Normal Turn:

```text
PLAYER TURN START
        ↓
PRE-ROLL
        ↓
 ┌──────┴──────┐
 ↓             ↓
ROLL          STORED NEWS
BUTTON        BUTTON
 ↓             ↓
Roll        News Phase
                ↓
        Player memilih News
                ↓
          News Resolution
                ↓
               Roll
```

Aturan:

* Player boleh langsung Roll.
* Player boleh membuka Stored News terlebih dahulu.
* Maximum **1 Stored News per Turn**.
* News harus selesai diproses sebelum Roll.
* Roll Again tetap merupakan Stored News.
* Roll Again bukan Double.
* Roll Again bukan bagian dari Double Chain.

---

# 5. ROLL

Normal Turn menggunakan:

> **2 Physical Dice**

Flow:

```text
ROLL
↓
Dice bergerak
↓
Dice berhenti
↓
Read Top Face
↓
Validate Result
↓
Calculate Total
↓
Detect Double
↓
Calculate Destination
↓
Destination Arrow
↓
Movement
```

Jika hasil dice tidak valid:

```text
Invalid Result
↓
Retry
```

Hasil invalid tidak boleh menghasilkan:

* Movement
* Destination
* Double
* Triple Double
* Landing Resolution

---

# 6. DOUBLE

Double terjadi ketika kedua dice memiliki nilai yang sama.

Contoh:

```text
4 + 4 = Double
Total Movement = 8
```

Double **tidak menggandakan movement**.

Setelah:

```text
Movement
↓
Start / First Lap
↓
Landing Resolution
```

Player mendapatkan:

> **1 Extra Roll**

---

# 7. DOUBLE COUNTER

Double Counter berlaku dalam satu Turn.

```text
Turn Start
↓
Double Counter = 0
```

Kemudian:

```text
Double #1 → Counter 1
Double #2 → Counter 2
Double #3 → Triple Double
```

Counter di-reset ketika Turn berakhir.

---

# 8. TRIPLE DOUBLE

Double ketiga berturut-turut dalam satu Turn:

```text
Roll
↓
Double
↓
Double Counter = 3
↓
TRIPLE DOUBLE
↓
JAIL
↓
TURN END
```

Roll ketiga:

* Tidak melakukan Movement.
* Tidak melakukan Landing Resolution.
* Tidak mendapatkan Extra Roll.

---

# 9. MOVEMENT

Semua jenis Movement menggunakan:

> **Movement Engine yang sama.**

Termasuk:

* Normal Dice Movement
* Double Movement
* Forced Movement
* News Movement
* Transport
* Jail Exit Movement

Movement Engine menangani:

* Path
* Direction
* Character Movement
* Movement Speed
* Smooth Turning
* Destination
* Arrival
* Movement Completion

Server menjadi source of truth untuk Movement.

---

# 10. MOVEMENT → START → LANDING

Flow utama:

```text
Movement
↓
Movement Complete
↓
Start Detection
↓
First Lap Check
↓
Start Reward
↓
Landing Resolution
```

Tile yang dilewati tidak dianggap Landing.

Start merupakan pengecualian:

> **Crossing Start tetap terdeteksi walaupun Player tidak berhenti di Start.**

Start diproses setelah Movement selesai dan sebelum Landing Resolution.

---

# 11. LANDING RESOLUTION

Landing Resolution merupakan **router**, bukan sistem gameplay tunggal.

```text
Landing Resolution
│
├── Property
├── Crown
├── News
├── Reward
├── Transport
└── Jail
```

Destination menentukan sistem yang dijalankan.

---

# 12. PROPERTY RESOLUTION

```text
Landing Property
↓
Ownership Check
```

### Unowned

```text
Buy Property UI
↓
Player pilih L1 / L2 / L3
↓
Confirmation
↓
Purchase
↓
Ownership Update
↓
UI Close
↓
Property Animation
↓
Resolution Complete
```

### Own Property

```text
Landing
↓
Upgrade Available?
├── No → Resolution Complete
└── Yes → Upgrade UI
```

Upgrade:

```text
Confirm
↓
UI Close
↓
Property Animation
↓
Resolution Continue
```

### Other Player

```text
Landing
↓
Calculate Rent
↓
Pay Rent
↓
Economy Resolution
↓
Property L1–L4?
├── Yes → Buy Property UI
└── L5 → Resolution Complete
```

Purchase bersifat atomic dan Confirm bersifat final.

---

# 13. CROWN RESOLUTION

Crown memiliki tiga keadaan:

```text
Unowned
Owned by Self
Owned by Other
```

### Unowned

```text
Landing
↓
Crown Purchase UI
↓
Buy / Cancel
↓
Payment
↓
Ownership Update
↓
Victory Check
```

### Own Crown

```text
Landing
↓
Calculate Crown Reward
↓
Apply Reward
↓
Reward Feedback
↓
Resolution Complete
```

### Other Player Crown

```text
Landing
↓
Nothing
↓
Resolution Complete
```

Crown Victory:

```text
4 Crown
↓
WIN
```

Victory menggunakan ownership aktual.

---

# 14. REWARD INTEGRATION

Landing Reward mengikuti:

```text
Landing Reward
↓
Reward Resolution
↓
Effect
↓
Resolution Complete
```

Namun:

> **Landing di Reward Tile tidak selalu berarti Reward langsung aktif.**

Contoh Golden Pass:

```text
Golden Pass
↓
Movement → Tile 20
↓
Reward belum aktif
↓
Turn End
↓
Reward aktif pada Turn berikutnya
```

---

# 15. TRANSPORT INTEGRATION

Transport menggunakan Movement Engine yang sama.

```text
Landing Tile 30
↓
Transport Privilege
↓
Turn End
↓
Turn Berikutnya
↓
Destination UI
↓
Player memilih destination
↓
Pay Transport
↓
Movement Engine
↓
Destination
↓
Transport Privilege habis
↓
Destination Resolution
```

Transport:

* Bukan teleport.
* Tidak menggunakan dice.
* Menggunakan official board path.
* Tetap mendeteksi Start.
* Hanya memberikan 1 Fast Travel.
* Tidak dapat stacking.

Destination tetap menjalankan sistem tile normal.

---

# 16. NEWS MOVEMENT EXCEPTION

Tidak semua News Movement kembali ke Landing Resolution.

Contoh:

### Express Route

```text
News
↓
Movement → Tile 30
↓
Transport aktif next turn
↓
Turn End
```

### Golden Pass

```text
News
↓
Movement → Tile 20
↓
Reward aktif next turn
↓
Turn End
```

Jadi aturan global:

> **Movement biasanya kembali ke Landing Resolution, kecuali effect yang menghasilkan Movement secara eksplisit memiliki flow khusus.**

---

# 17. JAIL INTEGRATION

Jail merupakan Player State khusus.

Triple Double:

```text
Double #3
↓
Jail
↓
Turn End
```

Jail Turn memiliki tiga pilihan:

```text
Double Dice
Pay 25K
Use News
```

Semua jalur Jail Exit akhirnya menggunakan:

```text
Jail Exit
↓
Movement
↓
Start Detection
↓
Landing Resolution
↓
Turn End
```

Police/System Roll tidak menggunakan Double Chain normal.

---

# 18. ECONOMY INTEGRATION

Semua transaksi/effect yang memengaruhi Balance menggunakan Economy Resolution.

```text
Transaction / Effect
↓
Calculate Economic Value
↓
Round to 500 Rels
↓
Check Payment
↓
Payment / Negative Balance
```

Negative Balance:

```text
Negative Balance
↓
Bankruptcy Check
↓
Second Life?
├── Yes → Second Life
└── No → Asset Liquidation
```

Jika berhasil diselamatkan:

```text
Resume Previous Resolution
```

Jika Final Bankruptcy:

```text
Final Bankruptcy
↓
Eliminated
↓
Spectator
↓
Current Resolution / Turn berhenti
```

---

# 19. BLOCKING UI

Gameplay UI dapat menghentikan sementara Resolution Chain.

```text
Landing Property
↓
Buy UI
↓
WAITING PLAYER DECISION
↓
Confirm / Cancel
↓
Resolution Continue
```

UI tidak mengambil alih Turn Controller.

Prinsip:

> **Gameplay UI dapat memblokir Resolution Chain, tetapi tidak menggantikan Turn State.**

Player Screen seperti:

* News
* Assets
* Trade
* Transaction
* Settings
* Shop

tidak mengambil alih Turn State.

---

# 20. VICTORY SYSTEM

Relopoli memiliki **4 Win Conditions**.

### 1. Last Player Standing

```text
Player lain
↓
Final Bankruptcy
↓
Eliminated
↓
Tersisa 1 Active Player
↓
WIN
```

### 2. Crown Victory

```text
4 Crown
↓
WIN
```

### 3. Set Victory

Player memiliki seluruh:

> **4 Official Set**

Setiap Set terdiri dari:

> **3 Property yang berdampingan.**

```text
Set 1 ✓
Set 2 ✓
Set 3 ✓
Set 4 ✓
↓
WIN
```

### 4. L5 Property Victory

Target bergantung pada jumlah Active Player:

| Active Player | Target L5 |
| ------------: | --------: |
|             4 |     18 L5 |
|             3 |     21 L5 |
|             2 |     23 L5 |

Yang dihitung adalah:

> **Current Property L5 Ownership**

bukan pernah mencapai jumlah tersebut sebelumnya.

---

# 21. GLOBAL VICTORY CHECK

Victory tidak dikelola terpisah oleh masing-masing system.

Semua perubahan penting masuk ke:

```text
State Change
↓
Global Victory Check
│
├── Last Player Standing?
├── 4 Crowns?
├── 4 Sets?
└── L5 Threshold?
       ↓
WIN / CONTINUE
```

Victory Check dilakukan setelah State Update yang berpotensi memenuhi Win Condition.

---

# 22. L5 THRESHOLD DINAMIS

Target L5 mengikuti jumlah Player aktif saat ini.

Contoh:

```text
4 Active Players
↓
Target = 18 L5
```

Jika satu Player bangkrut:

```text
3 Active Players
↓
Target = 21 L5
```

Perubahan jumlah Player **tidak otomatis membuat Player menang**.

Target baru hanya menjadi threshold baru yang harus dipenuhi.

---

# 23. GAME END

Ketika Win Condition terpenuhi:

```text
Win Condition Detected
↓
Victory Validation
↓
Game State = ENDED
↓
Winner ditetapkan
↓
Turn Controller STOP
↓
Gameplay STOP
↓
Victory UI
```

Victory mengalahkan Turn Flow.

Tidak ada:

* Extra Roll
* Turn End normal
* Next Player
* Movement berikutnya

setelah Game End.

---

# 24. PLAYER STATE VS GAME STATE

Keduanya dibedakan.

### Game State

```text
GAME
├── RUNNING
└── ENDED
```

### Player State

```text
PLAYER
├── ACTIVE
├── ELIMINATED
└── WINNER
```

Player yang kalah karena Game End **tidak dianggap Bankrupt**.

---

# 25. FINAL GAME FLOW

Master flow yang sudah diaudit:

```text
GAME START
    ↓
PLAYER TURN START
    ↓
PRE-ROLL
    ↓
ROLL
    ↓
DICE RESOLUTION
    ↓
DOUBLE CHECK
    │
    ├── Triple Double
    │       ↓
    │     JAIL
    │       ↓
    │    TURN END
    │
    └── Normal / Double
            ↓
        DESTINATION
            ↓
        MOVEMENT
            ↓
    MOVEMENT COMPLETE
            ↓
    START / FIRST LAP
            ↓
    LANDING RESOLUTION
            ↓
    SPECIAL RESOLUTION
            ↓
    ECONOMY / STATE UPDATE
            ↓
      GLOBAL VICTORY CHECK
            │
       ┌────┴────┐
       ↓         ↓
      WIN     CONTINUE
       ↓         ↓
 GAME ENDED  EXTRA ROLL?
                 │
            ┌────┴────┐
            ↓         ↓
           YES        NO
            ↓         ↓
           ROLL    TURN END
                       ↓
                 NEXT PLAYER
```

---

# 26. FULL GAME FLOW AUDIT RESULT

### Core Flow

* Turn Controller → ✅
* News Phase → ✅
* Roll → ✅
* Dice Resolution → ✅
* Double → ✅
* Triple Double → ✅
* Movement → ✅
* Start / First Lap → ✅
* Landing Resolution → ✅
* Resolution Chain → ✅
* Turn End → ✅

### Gameplay Systems

* Property → ✅
* Crown → ✅
* News → ✅
* Reward → ✅
* Transport → ✅
* Jail → ✅
* Economy → ✅
* Bankruptcy → ✅

### UI

* Blocking Gameplay UI → ✅
* Player Screen → ✅
* Modal Lock → ✅
* UI → Resolution Chain → Turn Controller → ✅

### Game End

* Crown Victory → ✅
* Set Victory → ✅
* L5 Victory → ✅
* Last Player Standing → ✅
* Dynamic L5 Threshold → ✅
* Elimination → ✅
* Game End → ✅
* Victory UI → ✅

---

# 27. HASIL AUDIT

**Full Game Flow Audit: PASS**

Tidak ditemukan benturan struktural besar pada core Turn Flow.

Prinsip arsitektur yang sekarang menjadi dasar Relopoli:

> **Turn Controller mengatur alur Turn.**

> **Movement Engine mengatur seluruh pergerakan.**

> **Landing Resolution mengarahkan Player ke sistem tile yang sesuai.**

> **Resolution Chain memungkinkan beberapa proses berjalan dalam satu Turn.**

> **Gameplay UI dapat pause Resolution Chain tanpa mengambil alih Turn State.**

> **Economy menangani konsekuensi finansial dan Bankruptcy.**

> **Global Victory Check menentukan apakah Game berakhir.**

> **Game End menghentikan seluruh gameplay dan menetapkan Winner.**

---

# 28. STATUS PROGRESS 19

> 🔒 **PROGRESS 19 — SYSTEM INTEGRATION & TURN FLOW AUDIT: LOCKED**

Seluruh sistem utama sekarang sudah tidak hanya berdiri sendiri, tetapi sudah memiliki hubungan yang jelas dari:

```text
GAME START
↓
TURN
↓
ROLL
↓
MOVEMENT
↓
LANDING
↓
RESOLUTION
↓
ECONOMY
↓
VICTORY / ELIMINATION
↓
GAME END
```

## Next

Tahap berikutnya adalah:

> **Progress 20 — Edge Case & Exploit Audit**

Fokusnya bukan menambah fitur, melainkan mencoba menemukan kondisi yang dapat membuat state game menjadi tidak valid, misalnya:

* Victory + Trade/Transaction
* Bankruptcy di tengah Resolution Chain
* Property/Crown berpindah ketika hampir memenuhi Win Condition
* Double + News + Movement Chain
* Jail + Bankruptcy
* Transport + News + Jail
* beberapa perubahan state dalam satu Resolution
* dan kondisi lain yang berpotensi menghasilkan exploit.

Tentu. Aku tambahkan bagian **Ringkasan Keputusan Utama** di akhir Progress 19 agar mudah dipakai sebagai referensi cepat untuk progress berikutnya.

# RELOPOLI — PROGRESS 19

# RINGKASAN KEPUTUSAN UTAMA

> Ringkasan keputusan final dari **System Integration & Turn Flow Audit**.

---

## 1. Turn Controller

**LOCKED**

Turn Controller menjadi **central authority** untuk seluruh Turn Flow.

```text
News Phase
↓
Roll
↓
Dice Resolution
↓
Movement
↓
Landing Resolution
↓
Special Resolution
↓
Victory Check
↓
Extra Roll / Turn End
```

System lain mengembalikan hasil Resolution kepada Turn Controller dan tidak mengambil alih pergantian Turn.

---

## 2. Resolution Chain

**LOCKED**

Satu Turn dapat memiliki beberapa Resolution.

```text
Resolution A
↓
Resolution B
↓
Resolution C
↓
Turn End
```

Movement tambahan umumnya kembali ke:

```text
Movement
↓
Start / First Lap
↓
Landing Resolution
```

kecuali effect memiliki aturan khusus yang mengakhiri atau mengubah flow.

---

## 3. News Phase

**LOCKED**

Player memiliki dua pilihan di awal Turn:

```text
Direct Roll
atau
Stored News → News Resolution → Roll
```

Aturan utama:

* Maximum 1 Stored News per Turn.
* Player boleh langsung Roll tanpa membuka News.
* News harus selesai sebelum Roll.
* Roll Again adalah Stored News.
* Roll Again bukan Double dan bukan bagian dari Double Chain.

---

## 4. Double & Triple Double

**LOCKED**

### Double

```text
Double
↓
Movement
↓
Landing Resolution
↓
Extra Roll
```

Double tidak menggandakan movement.

### Triple Double

```text
Double #3
↓
Jail
↓
Turn End
```

Tidak ada Movement, Landing Resolution, atau Extra Roll dari Double ketiga.

---

## 5. Movement

**LOCKED**

Semua jenis Movement menggunakan **Movement Engine yang sama**.

Berlaku untuk:

* Normal Roll
* Double
* Forced Movement
* News Movement
* Transport
* Jail Exit

Movement menggunakan official board path dan server sebagai source of truth.

---

## 6. Start / First Lap

**LOCKED**

Urutan setelah Movement:

```text
Movement Complete
↓
Start Detection
↓
First Lap Check
↓
Start Reward
↓
Landing Resolution
```

Crossing Start tetap terdeteksi walaupun Player tidak berhenti di Start.

---

## 7. Landing Resolution

**LOCKED**

Landing Resolution berfungsi sebagai router:

```text
Landing Resolution
├── Property
├── Crown
├── News
├── Reward
├── Transport
└── Jail
```

Tile yang dilewati tidak dianggap Landing.

---

## 8. Property Resolution

**LOCKED**

Property memiliki tiga kondisi utama:

```text
Unowned
→ Buy UI

Own
→ Upgrade UI jika tersedia

Other Player
→ Rent
→ Buy Property UI jika L1–L4 dan memenuhi syarat
```

Purchase dan Upgrade menggunakan confirmation serta atomic transaction.

---

## 9. Crown Resolution

**LOCKED**

Tiga kondisi:

```text
Unowned → Purchase
Own → Crown Reward
Other Player → Nothing
```

Memiliki seluruh 4 Crown:

```text
4 Crown
↓
WIN
```

Victory berdasarkan ownership aktual.

---

## 10. Reward

**LOCKED**

Landing Reward:

```text
Landing
↓
Reward Resolution
↓
Effect
↓
Resolution Complete
```

Destination dan activation dapat berbeda.

Contoh Golden Pass:

```text
Movement → Tile 20
↓
Reward belum aktif
↓
Turn End
↓
Reward aktif next turn
```

---

## 11. Transport

**LOCKED**

Transport bukan teleport.

```text
Tile 30
↓
Transport Privilege
↓
Next Turn
↓
Choose Destination
↓
Pay
↓
Movement Engine
↓
Destination
↓
Destination Resolution
```

Transport:

* hanya sekali;
* tidak stacking;
* menggunakan Movement Engine;
* tetap mendeteksi Start;
* destination menggunakan rules normal.

---

## 12. Jail

**LOCKED**

Jail memiliki tiga jalur utama:

```text
Double Dice
Pay 25K
Use News
```

Jail Exit kemudian:

```text
Jail Exit
↓
Movement
↓
Start
↓
Landing Resolution
↓
Turn End
```

Police/System Roll tidak masuk Double Chain normal.

---

## 13. Economy & Bankruptcy

**LOCKED**

Negative Balance memicu:

```text
Bankruptcy Check
↓
Second Life?
↓
Asset Liquidation
↓
Balance ≥ 0?
```

Jika berhasil:

```text
Resume Previous Resolution
```

Jika gagal:

```text
Final Bankruptcy
↓
Eliminated
↓
Spectator
```

Bankruptcy merupakan **sub-process**, bukan Turn baru.

---

## 14. UI State

**LOCKED**

Gameplay UI dapat memblokir Resolution Chain:

```text
Landing
↓
Blocking UI
↓
Player Decision
↓
Resolution Continue
```

Player Screen tidak mengambil alih Turn State.

Prinsip:

> **Gameplay UI dapat pause Resolution Chain, tetapi tidak menggantikan Turn Controller.**

---

# 15. Win Conditions

**LOCKED**

Relopoli memiliki **4 cara menang**:

### 1. Last Player Standing

Menjadi satu-satunya Player yang belum Bankrupt.

### 2. Crown Victory

Memiliki seluruh **4 Crown**.

### 3. Set Victory

Memiliki seluruh **4 Official Set**.

Setiap Set:

> **3 Property yang berdampingan.**

### 4. L5 Property Victory

Target berdasarkan jumlah Active Player:

| Active Player |    Target |
| ------------: | --------: |
|             4 | **18 L5** |
|             3 | **21 L5** |
|             2 | **23 L5** |

Yang dihitung adalah **current ownership**, bukan historical achievement.

---

## 16. Global Victory Check

**LOCKED**

Victory diperiksa secara global setelah State Change yang relevan.

```text
State Change
↓
Global Victory Check
├── Last Player Standing?
├── 4 Crowns?
├── 4 Sets?
└── L5 Threshold?
```

Jika salah satu terpenuhi:

```text
WIN
↓
GAME ENDED
```

---

## 17. Dynamic L5 Threshold

**LOCKED**

Threshold mengikuti jumlah Active Player saat ini.

```text
4 Players → 18 L5
3 Players → 21 L5
2 Players → 23 L5
```

Jika Player bangkrut dan jumlah Active Player berubah, threshold ikut berubah.

Perubahan threshold sendiri **tidak langsung memberikan kemenangan**.

---

## 18. Game End

**LOCKED**

Begitu Win Condition terpenuhi:

```text
Victory Validation
↓
Game State = ENDED
↓
Winner
↓
Turn Controller STOP
↓
Gameplay STOP
↓
Victory UI
```

Tidak ada Extra Roll atau Next Turn setelah Game End.

Player lain menjadi berada dalam kondisi Game Finished/Spectator, **bukan otomatis dianggap Bankrupt**.

---

# 19. Master Principle

Seluruh sistem sekarang mengikuti pola:

```text
PLAYER ACTION / EFFECT
        ↓
     RESOLUTION
        ↓
   STATE UPDATE
        ↓
 VICTORY CHECK
        ↓
CONTINUE / GAME END
```

Sedangkan Turn:

```text
TURN START
↓
PRE-ROLL
↓
ROLL
↓
MOVEMENT
↓
START
↓
LANDING
↓
RESOLUTION CHAIN
↓
VICTORY CHECK
↓
EXTRA ROLL / TURN END
```

---

# 20. Progress 19 Final Status

> 🔒 **SYSTEM INTEGRATION & TURN FLOW AUDIT — LOCKED**

Core flow sudah terintegrasi:

```text
GAME START
↓
TURN
↓
NEWS
↓
ROLL
↓
MOVEMENT
↓
START / FIRST LAP
↓
LANDING
↓
PROPERTY / CROWN / NEWS / REWARD / TRANSPORT / JAIL
↓
ECONOMY
↓
BANKRUPTCY / STATE UPDATE
↓
VICTORY CHECK
↓
WIN / NEXT TURN
↓
GAME END
```

### Next Progress

**Progress 20 — Edge Case & Exploit Audit**

Fokus:

* Victory + Trade / Transaction
* Bankruptcy di tengah Resolution Chain
* Ownership berubah saat hampir Win
* Double + News + Movement Chain
* Jail + Bankruptcy
* Transport + News + Jail
* Multiple State Change dalam satu Resolution
* Potensi state yang tidak valid atau exploit