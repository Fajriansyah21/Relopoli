# RELOPOLI --- MASTER SOURCE OF TRUTH

## Final Game Rules & System Architecture

> **Status:** MASTER DRAFT --- CONSOLIDATED\
> **Scope:** Progress 1--20\
> **Purpose:** Satu referensi utama untuk Game Rules, System
> Integration, Edge Case, Exploit Prevention, dan implementasi.

------------------------------------------------------------------------

# 0. SOURCE OF TRUTH POLICY

## 0.1 Latest Explicit Decision Wins

Jika keputusan baru secara eksplisit menggantikan keputusan lama:

``` text
OLD RULE
↓
SUPERSEDED

NEW RULE
↓
FINAL
```

History Progress lama tidak dihapus.

## 0.2 System Rule \> UI Rule

UI tidak menentukan gameplay rule.

``` text
CORE / SYSTEM RULE
↓
GAME STATE
↓
UI REPRESENTATION
```

Jika UI documentation berbeda dengan System Rule, System Rule menjadi
authority.

## 0.3 Master Flow

Master Flow mengatur integrasi antar-system.

System Progress tetap menjadi authority untuk detail mekanik sistemnya.

## 0.4 Audit Rule

Keputusan Edge Case / Exploit Audit menjadi final untuk kondisi yang
sebelumnya belum aman atau berpotensi menghasilkan invalid state.

------------------------------------------------------------------------

# 1. CORE ARCHITECTURE

Relopoli menggunakan arsitektur:

``` text
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

### Locked Principles

-   **Turn Controller** adalah central authority Turn.
-   System lain menyelesaikan resolution dan mengembalikan result.
-   System lain tidak boleh mengambil alih Turn End secara diam-diam.
-   Resolution Chain dapat menjalankan beberapa proses berurutan.
-   Blocking UI dapat pause Resolution Chain tetapi tidak menggantikan
    Turn State.
-   Server adalah source of truth untuk gameplay state.

------------------------------------------------------------------------

# 2. PLAYER & GAME STATE

## Game State

``` text
RUNNING
ENDED
```

## Player State

``` text
ACTIVE
ELIMINATED
WINNER
```

Player yang kalah karena Game End tidak dianggap Bankrupt.

## Game State Gate

Setiap gameplay action:

``` text
Incoming Action
↓
Game State Check
```

Jika:

``` text
Game State = ENDED
```

maka action ditolak.

Tidak ada gameplay State Change setelah Game End.

------------------------------------------------------------------------

# 3. TURN FLOW

## Normal Turn

``` text
Turn Start
↓
News Phase
↓
Roll
↓
Dice Resolution
↓
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
↓
Special Resolution / Blocking UI
↓
Victory Check
↓
Extra Roll Check
↓
Turn End
```

## Resolution Result

Resolution dapat menghasilkan:

``` text
CONTINUE
EXTRA_ROLL
TURN_END
PLAYER_ELIMINATED
GAME_END
```

Priority:

``` text
GAME_END
>
PLAYER_ELIMINATED
>
TURN_END
>
EXTRA_ROLL
>
CONTINUE
```

------------------------------------------------------------------------

# 4. NEWS PHASE

News Phase terjadi sebelum Roll.

Player dapat:

-   langsung Roll;
-   menggunakan Stored News terlebih dahulu.

Maximum:

> **1 Stored News per Turn.**

News harus selesai sebelum Roll normal dimulai.

## Roll Again

Roll Again adalah Stored News.

Flow:

``` text
Roll #1
↓
Player memilih Roll Again
↓
Roll #1 menjadi VOID
↓
Roll #2
↓
Roll #2 WAJIB digunakan
```

Roll #1 tidak menghasilkan:

-   Movement;
-   Double;
-   Double Counter;
-   Triple Double;
-   Landing;
-   Extra Roll.

Roll #2 diproses sebagai normal Roll.

Roll Again bukan Double dan bukan bagian dari Double Chain.

------------------------------------------------------------------------

# 5. ROLL & DOUBLE

Normal Turn selalu dimulai dengan Roll kecuali ada Special Turn Flow
seperti Transport atau Jail.

## Dice

-   2 physical dice.
-   Dice result harus valid.
-   Invalid result tidak menghasilkan Movement, Double, Triple Double,
    atau Landing.

## Double

Jika kedua dice sama:

``` text
Double
↓
Movement = SUM kedua dice
↓
Start / First Lap
↓
Landing Resolution
↓
Extra Roll
```

Double Counter reset pada Turn Start.

``` text
Double #1 → Counter 1
Double #2 → Counter 2
Double #3 → Triple Double
```

## Triple Double

``` text
Double #3
↓
TRIPLE DOUBLE
↓
JAIL
↓
TURN END
```

Triple Double tidak melakukan:

-   Movement;
-   Landing;
-   Extra Roll.

------------------------------------------------------------------------

# 6. MOVEMENT ENGINE

Semua movement menggunakan satu Movement Engine:

-   Normal Dice Movement
-   Double Movement
-   Forced Movement
-   News Movement
-   Transport Movement
-   Jail Exit Movement

Server adalah source of truth.

Movement Engine menangani:

-   Path
-   Direction
-   Character Movement
-   Movement Speed
-   Smooth Turning
-   Destination
-   Arrival
-   Movement Completion

## Movement → Start → Landing

``` text
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

Tile yang dilewati bukan Landing.

Crossing Start tetap terdeteksi walaupun Player tidak berhenti di Start.

------------------------------------------------------------------------

# 7. LANDING RESOLUTION

Landing Resolution adalah router:

``` text
Landing Resolution
├── Property
├── Crown
├── News
├── Reward
├── Transport
└── Jail
```

Destination menentukan system yang diproses.

------------------------------------------------------------------------

# 8. PROPERTY SYSTEM

## Ownership State

``` text
Unowned
Own
Other Player
```

## Unowned

``` text
Landing
↓
Buy Property UI
↓
Choose L1 / L2 / L3
↓
Confirm
↓
Atomic Purchase
↓
Ownership Update
↓
UI Close
↓
Property Animation
↓
Resolution Continue
```

L4 dan L5 tidak dapat dibeli langsung saat initial purchase.

## Own Property

``` text
Landing
↓
Upgrade Available?
├── No → Resolution Complete
└── Yes → Upgrade UI
```

Upgrade:

``` text
Confirm
↓
UI Close
↓
Property Animation
↓
Resolution Continue
```

Maximum:

> **1 Upgrade per Turn**

Upgrade path:

``` text
L1 → L2
L1 → L3
L2 → L3
L3 → L4
L4 → L5
```

L4 membutuhkan L3.

L5 membutuhkan L4.

## Other Player

``` text
Landing
↓
Calculate Rent
↓
Pay Rent
↓
Economy Resolution
↓
Property L1–L4?
├── Yes → Buy Property UI jika memenuhi syarat
└── L5 → Resolution Complete
```

Property L5 tidak dapat dibeli melalui landing.

## Property Value

-   L4 Value = Buy L3 + Upgrade L3→L4
-   L5 Value = L4 Value + Upgrade L4→L5

## Set

Setiap district memiliki:

> **1 Official Set**

Set terdiri dari:

> **3 designated adjacent Properties**

Set complete memberikan sekitar 20% rent increase, dengan direct value
rounding ke 500 Rels.

Set break jika salah satu dari 3 property keluar dari ownership.

------------------------------------------------------------------------

# 9. CROWN SYSTEM

Ada:

> **4 Crown --- satu per district.**

Crown Victory:

``` text
Memiliki seluruh 4 Crown
↓
WIN
```

Victory menggunakan current ownership.

## Crown Landing

### Unowned

``` text
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

### Own

``` text
Landing
↓
Crown Reward
↓
Feedback
↓
Resolution Complete
```

### Other Player

``` text
Landing
↓
Nothing
↓
Resolution Complete
```

## Crown Transfer

Crown dapat:

-   Trade;
-   Transaction.

Saat Crown berpindah ownership:

``` text
Ownership → New Owner
Status → CLEAN
```

Ini menggantikan aturan lama yang menyatakan status tetap mengikuti
Crown.

## Crown Transaction Minimum

FINAL:

``` text
Minimum Price = 3 × Crown Value
```

Aturan lama:

``` text
Crown Value × 2.5
```

adalah **SUPERSEDED**.

## Crown Liquidation

``` text
Liquidation
↓
100% Crown Value
↓
Crown Destroyed
↓
Unowned + Clean
```

------------------------------------------------------------------------

# 10. ECONOMY & BANKRUPTCY

Semua transaksi/effect ekonomi:

``` text
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

## Negative Balance

``` text
Negative Balance
↓
Bankruptcy Check
↓
Second Life?
├── Yes → Second Life
└── No → Asset Liquidation
```

## Second Life

Jika aktif:

``` text
Second Life Consumed
↓
Balance = 0
↓
+50,000 Rels
↓
Final Balance = 50,000 Rels
↓
Give 1 Shield
↓
Skip Asset Liquidation
```

Second Life hanya dapat digunakan satu kali.

## Asset Liquidation

Jika tidak terselamatkan:

``` text
Asset Liquidation
↓
Sell Asset
↓
Balance Check
```

Jika balance tetap negatif:

``` text
Sell Asset lagi
```

Jika tidak ada asset lagi dan balance tetap negatif:

``` text
Final Bankruptcy
↓
Eliminated
↓
Spectator
↓
Abort Current Resolution / Turn
↓
Global Victory Check
```

Jika Second Life atau liquidation menyelamatkan Player:

> Resume Previous Resolution.

Tidak mengulang payment/effect yang sudah selesai.

------------------------------------------------------------------------

# 11. JAIL SYSTEM

Jail adalah Player State khusus.

## Enter Jail

Triple Double:

``` text
Triple Double
↓
Jail
↓
Turn End
```

## Jail Turn Choices

``` text
Double Dice
Pay 25K
Use News
```

## Double Dice

Jika Double:

``` text
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

Tidak ada Extra Roll.

Police/System Roll tidak menggunakan Double Chain normal.

## Pay 25K

-   Button disabled jika Balance \<25K.
-   Payment tidak boleh menciptakan Negative Balance.
-   Setelah pembayaran:

``` text
Jail Exit
↓
Police/System Roll
↓
Movement
↓
Landing Resolution
↓
Turn End
```

## Use News

Direct Jail Break dari Jail UI.

Bukan News Phase.

``` text
News Consumed
↓
Jail Exit
↓
Return to Tile 10 — Jail
↓
Attempt Counter Reset
↓
Police/System Roll
↓
Movement
↓
Landing Resolution
↓
Turn End
```

## Forced Payment 50K

Pada Attempt #5:

``` text
Police/System Roll
↓
Non-Double
↓
Forced Payment 50K
↓
Economy / Bankruptcy
```

Forced Payment boleh menghasilkan Negative Balance.

## Jail + Bankruptcy

Final Bankruptcy:

``` text
Eliminated
↓
Abort Jail Resolution
↓
Abort Turn
↓
Global Victory Check
```

Jail Exit tidak memberikan Extra Roll.

------------------------------------------------------------------------

# 12. TRANSPORT SYSTEM

Tile:

> **30 --- Transport**

Landing Tile 30 memberikan:

> **1 Fast Travel privilege untuk Turn berikutnya.**

Turn saat landing berakhir.

## Next Turn

``` text
Fast Travel UI
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

-   bukan teleport;
-   menggunakan official board path;
-   menggunakan Movement Engine;
-   tetap mendeteksi Start;
-   hanya sekali;
-   tidak stacking.

Tile 30 tidak dapat menjadi destination.

## Transport Cost

    Distance     Cost
  ---------- --------
        1--5    5,000
       6--10    7,500
      11--15   10,000
      16--20   12,500
      21--25   15,000
      26--30   17,500
      31--35   20,000
      36--39   22,500

Jarak:

``` text
Forward Distance
vs
Backward Distance
↓
Shortest Path
```

Jika sama:

> Forward diprioritaskan.

Jika Balance \<5,000:

> Fast Travel UI tidak ditampilkan.

Jika Balance cukup:

-   destination yang biaya \> Balance disabled;
-   destination yang mampu dibayar enabled.

## Transport + Special Tile

Destination diproses menggunakan rules normal.

Transport → News masuk Landing Resolution, bukan News Phase.

Transport → Jail masuk Jail.

Jika destination menyebabkan Special Movement yang memiliki Turn End,
tidak boleh menghasilkan same-turn loop.

------------------------------------------------------------------------

# 13. NEWS SPECIAL MOVEMENT

## Express Route

``` text
News
↓
Movement → Tile 30
↓
Transport active next turn
↓
Turn End
```

## Golden Pass

``` text
News
↓
Movement → Tile 20
↓
Reward active next turn
↓
Turn End
```

Special News Movement adalah terminal untuk Turn jika flow secara
eksplisit menetapkan Turn End.

Tidak boleh otomatis kembali ke Landing Resolution.

------------------------------------------------------------------------

# 14. TRADE SYSTEM

Trade bersifat:

> **Asset ↔ Asset**

Tradeable:

-   Property
-   Crown

Tidak tradeable:

-   Rels
-   News
-   Item lain

## Proposal

-   Kedua pihak memberikan minimal 1 asset.
-   Maximum 3 asset per sisi.
-   Tidak ada Asset Lock.
-   Multiple proposal dapat menggunakan asset yang sama.
-   Asynchronous.
-   Tidak terikat Turn.
-   Expiration 30 menit.
-   Maximum 1 Counter Offer.

## Final Validation

``` text
Accept
↓
Asset ID
+
Current Ownership
↓
Valid?
├── Yes → Atomic Transfer
└── No → Invalid
```

Jika asset sudah tidak dimiliki expected owner:

> Trade Invalid.

Property Level Change:

> Tidak membatalkan Trade selama Asset ID + Ownership tetap valid.

## Disconnect

Disconnect salah satu pihak:

``` text
Pending Trade
↓
Cancelled
```

Trade yang sudah Completed tidak di-rollback.

------------------------------------------------------------------------

# 15. TRANSACTION SYSTEM

Transaction:

> **Asset ↔ Rels**

Buyer memilih:

-   Property;
-   Crown milik Player lain.

## Property

``` text
Minimum Price = Current Property Value
```

## Crown

``` text
Minimum Price = 3 × Crown Value
```

Crown Unowned tidak dapat dibeli melalui Transaction.

## Offer

``` text
Buyer
↓
Select Asset
↓
Set Price
↓
Send Offer
↓
Seller
├── Accept
├── Decline
└── Negotiate
```

Maximum:

> **1 Counter Offer**

Buyer tidak dapat Counter balik setelah Seller membuat Counter.

## Balance

Saat offer dibuat:

> Buyer harus memiliki Balance cukup.

Rels tidak di-reserve.

Saat Accept:

> Live / Final Balance Validation.

Jika Balance tidak cukup:

> Accept disabled / Final Validation gagal.

## Final Validation Failure

Transaction langsung berakhir.

Tidak ada retry pada proposal yang sama.

## Atomic Transaction

``` text
Buyer Balance - Price
Seller Balance + Price
Asset Ownership Seller → Buyer
```

Semua harus terjadi sebagai satu operasi.

Tidak boleh partial transaction.

## Pending Property Transaction

  Change                   Result
  ------------------------ -------------
  Ownership berubah        Invalid
  Property Level berubah   Invalid
  Modifier berubah         Tetap Valid
  Set berubah              Tetap Valid
  Set Complete → Break     Tetap Valid
  Set Break → Complete     Tetap Valid

## Pending Crown Transaction

Validitas terutama:

``` text
Crown ID
+
Ownership
```

Crown Status/Modifier tidak meng-invalidasi proposal selama Crown dan
Ownership tetap valid.

## Multiple Pending Transaction

Tidak ada Asset Lock.

Jika satu Transaction berhasil:

``` text
Ownership Change
↓
Other active Transaction for same Asset
↓
INVALID
```

## Expiration

``` text
Pending
↓
30 Minutes
↓
Expired
```

Expired tidak dapat diterima, dinegosiasikan, atau dieksekusi.

------------------------------------------------------------------------

# 16. UI / PLAYER SCREEN / ASSETS

## Blocking UI

``` text
Gameplay
↓
Blocking UI
↓
Player Decision
↓
Resolution Continue
```

UI dapat pause Resolution Chain tetapi tidak menggantikan Turn State.

## Assets Panel

Assets adalah:

> **Information Hub**

Assets tidak membuat Game Rules baru.

Tabs:

``` text
[ PROPERTIES ] [ CROWNS ]
```

Properties menjadi default.

Asset Detail dapat menampilkan:

-   Artwork
-   Name
-   District
-   Level
-   Value
-   Rent
-   Set
-   Status / Modifier
-   Ownership

Actions:

``` text
View on Board
Trade
Transaction
```

`View on Board` hanya menunjukkan lokasi asset.

Tidak memindahkan Player dan tidak menjalankan Movement.

Trade / Transaction dibuka sebagai system terpisah.

------------------------------------------------------------------------

# 17. VICTORY SYSTEM

Ada 4 Win Conditions.

## 1. Last Player Standing

Menjadi satu-satunya Player yang belum eliminated.

## 2. Crown Victory

Memiliki seluruh:

> **4 Crown**

## 3. Set Victory

Memiliki seluruh:

> **4 Official Set**

Setiap Set terdiri dari 3 designated adjacent Properties.

## 4. L5 Victory

Dynamic threshold:

    Active Players   L5 Required
  ---------------- -------------
                 4            18
                 3            21
                 2            23

Threshold menggunakan:

> **Current Active Player Count**

L5 Victory menggunakan:

> **Current L5 Ownership**

Bukan historical ownership.

## Global Victory Check

Setiap important State Change:

``` text
State Change
↓
Global Victory Check
├── Last Player Standing?
├── 4 Crowns?
├── 4 Sets?
└── L5 Threshold?
```

Jika ditemukan:

``` text
Victory Validation
↓
Game State = ENDED
↓
Winner Set
↓
Turn Controller STOP
↓
Gameplay STOP
↓
Victory UI
```

Tidak ada Extra Roll, Turn End normal, Next Player, atau Movement
setelah Game End.

------------------------------------------------------------------------

# 18. STATE CHANGE & ATOMICITY

## Sequential State Change

Server memproses gameplay State Changes sequentially.

``` text
State Change A
↓
Global Victory Check
↓
State Change B
```

Tidak boleh:

``` text
A ─────┐
       ├── simultaneous
B ─────┘
```

## Atomic Operation

Atomic Operation tidak boleh terputus di tengah oleh Victory Check.

Contoh:

``` text
Atomic Trade
↓
Complete Transfer
↓
Victory Check
```

Bukan:

``` text
Transfer A
↓
Victory Check
↓
Transfer B
```

## Game End During Chain

Jika State Change menghasilkan Game End:

``` text
Game End
↓
Resolution Chain Abort
↓
Pending gameplay action rejected
```

Pending Trade / Transaction dibatalkan ketika Game End terjadi.

Completed Trade / Transaction tidak dibatalkan.

------------------------------------------------------------------------

# 19. SERVER AUTHORITY & ANTI-EXPLOIT

## Client Intent

Client hanya mengirim:

> **Intent**

Client tidak menentukan authoritative state.

## Standard Action Pipeline

``` text
Incoming Request
↓
Game State Check
↓
Actor Validation
↓
Turn / Player State Check
↓
Action Validation
↓
Current State Read
↓
Final Validation
↓
Atomic State Change
↓
Update Authoritative State
↓
Global Victory Check
↓
Resolution Result
```

## Duplicate Request

Double click / replay tidak menghasilkan duplicate State Change.

Proposal/action yang sudah selesai tidak dapat dieksekusi ulang.

## Race Condition

Jika dua request bersamaan:

> server ordering menentukan request yang diproses lebih dahulu.

Request berikutnya harus membaca latest state.

## Stale UI

UI boleh stale.

Server tidak boleh menggunakan stale state.

## Invalid Action

``` text
Invalid Request
↓
NO STATE CHANGE
```

Rejected / Invalid Action memiliki:

> **Zero Gameplay Side Effect**

## UI Lock

UI disabled / modal lock adalah UX protection, bukan security mechanism.

Server-side validation selalu wajib.

------------------------------------------------------------------------

# 20. FINAL EXPLOIT RULES

### Economy

-   Economic effect tidak dapat diaplikasikan dua kali.
-   Payment tidak dapat di-double submit.
-   Liquidation atomic.
-   Second Life hanya sekali.

### Property

-   Asset hanya dapat dibeli sekali.
-   Confirm hanya menghasilkan satu purchase.
-   Upgrade Confirm hanya menghasilkan satu upgrade.
-   Rent harus selesai sebelum Buy Property.
-   Ownership/Level changes diproses sequentially.

### Crown

-   Current ownership adalah authority.
-   Crown #4 langsung memicu Victory Check.
-   Crown yang sudah menghasilkan Game End tidak dapat ditransaksikan
    lagi.

### Roll

-   Roll Again membatalkan Roll #1.
-   Triple Double tidak Movement.
-   Triple Double tidak Landing.
-   Triple Double tidak Extra Roll.
-   Jail Double tidak masuk Double Chain normal.

### News

-   Special Movement tidak membuat same-turn infinite loop.
-   Express Route dan Golden Pass dapat menjadi terminal Turn.

### Transport

-   Satu privilege hanya satu penggunaan.
-   Tile 30 bukan destination.
-   Payment memakai latest Balance.
-   Consumed privilege tidak dapat dipakai ulang.

### Jail

-   Jail memblokir Normal Roll.
-   Jail Exit tidak Extra Roll.
-   Final Bankruptcy menghentikan Jail Resolution.

### Victory

-   Victory memakai latest state.
-   Victory Check dilakukan setelah Atomic State Change.
-   Game End adalah hard stop.
-   Dynamic L5 threshold memakai Active Player Count terbaru.

### Server

-   Client tidak authoritative.
-   Actor harus valid.
-   Turn ownership harus valid.
-   Duplicate request ditolak.
-   Replay request ditolak.
-   Stale state ditolak melalui Final Validation.
-   Invalid action = zero side effect.

------------------------------------------------------------------------

# 21. KNOWN SUPERSEDED RULES

## Superseded #1 --- Crown Transaction Price

### Old

``` text
Crown Value × 2.5
```

### Final

``` text
3 × Crown Value
```

Source of truth:

> Progress 16 + Progress 18.

------------------------------------------------------------------------

## Superseded #2 --- Crown Transfer Status

### Old

``` text
Status / Modifier mengikuti Crown saat transfer
```

### Final

``` text
Crown Transfer
↓
Status = CLEAN
```

Source of truth:

> Progress 18.

------------------------------------------------------------------------

# 22. SOURCE HIERARCHY

Untuk implementasi:

``` text
MASTER SOURCE OF TRUTH
        ↓
Progress 19 — Master Flow
        ↓
Progress 20 — Edge Case & Exploit Audit
        ↓
Latest Locked System Progress
        ↓
Older Progress History
        ↓
UI Documentation
```

Namun:

> Detail mekanik tetap diambil dari System Progress yang relevan.

Contoh:

``` text
Jail
→ Progress 9

Transport
→ Progress 3

Property
→ Progress 8

Trade
→ Progress 15

Transaction
→ Progress 16

News
→ Progress 17

Crown
→ Progress 18

Integration
→ Progress 19

Edge Case / Exploit
→ Progress 20
```

------------------------------------------------------------------------

# 23. IMPLEMENTATION PRINCIPLE

Implementasi tidak boleh menebak rule.

Jika implementasi menemukan:

``` text
Rule A
vs
Rule B
```

maka gunakan:

``` text
Latest Explicit Locked Decision
```

Jika tidak ada keputusan yang mendukung behavior:

> **Jangan invent rule baru sebagai gameplay mechanic.**

Catat sebagai:

``` text
UNRESOLVED / NEEDS DESIGN DECISION
```

------------------------------------------------------------------------

# 24. MASTER ARCHITECTURE

``` text
                         RELOPOLI
                            │
                    ┌───────┴───────┐
                    │  GAME STATE   │
                    └───────┬───────┘
                            │
                     TURN CONTROLLER
                            │
       ┌────────────┬───────┼────────┬─────────────┐
       ↓            ↓       ↓        ↓             ↓
     NEWS          ROLL  MOVEMENT  LANDING       ECONOMY
                              │        │             │
                              │        ├─ Property  │
                              │        ├─ Crown     │
                              │        ├─ News      │
                              │        ├─ Reward    │
                              │        ├─ Transport │
                              │        └─ Jail      │
                              │
                              ↓
                       STATE CHANGE
                              │
                              ↓
                    GLOBAL VICTORY CHECK
                              │
                     ┌────────┴────────┐
                     ↓                 ↓
                  GAME END           CONTINUE
                     │                 │
                     ↓                 ↓
                VICTORY UI        EXTRA ROLL?
                                       │
                                  ┌────┴────┐
                                  ↓         ↓
                                ROLL      TURN END
```

------------------------------------------------------------------------

# 25. MASTER STATUS

> 🔒 **RELOPOLI MASTER SOURCE OF TRUTH --- LOCKED**

Progress 1--20 telah dikonsolidasikan.

Dokumen ini menjadi referensi utama untuk:

-   Game Rules;
-   System Architecture;
-   Turn Flow;
-   Economy;
-   Property;
-   Crown;
-   News;
-   Transport;
-   Jail;
-   Trade;
-   Transaction;
-   Victory;
-   Bankruptcy;
-   UI integration;
-   Edge Cases;
-   Exploit Prevention;
-   Server Authority.

Historical Progress tetap dipertahankan sebagai dokumentasi proses
design.

Jika terdapat konflik:

> **Latest Explicit Locked Decision wins.**