Siap. Kita satukan semua aturan **Forced Movement** menjadi satu bagian supaya tidak tersebar di beberapa section.

# RELOPOLI — START SYSTEM

## Brainstorm Recap & Final Decision

### Status: 🔒 LOCKED

---

## 1. Starting Capital

Setiap pemain memulai permainan dengan:

> **250.000 Rels**

---

## 2. Bonus Start

Tile Start memiliki dua jenis bonus:

| Kondisi                |           Reward |
| ---------------------- | ---------------: |
| Melewati Start         | **+20.000 Rels** |
| Landing tepat di Start | **+30.000 Rels** |

Bonus diberikan berdasarkan movement yang benar-benar ditempuh pemain.

---

# 3. First Lap

Pemain mendapatkan **First Lap Bonus sebesar 100.000 Rels** ketika pertama kali menyelesaikan satu putaran penuh papan.

### First Lap = 100.000 Rels TOTAL

**100.000 Rels merupakan total reward untuk First Lap, bukan bonus tambahan di atas Bonus Start.**

| Kondisi First Lap                  |            Reward Rels |
| ---------------------------------- | ---------------------: |
| First Lap + melewati Start         | **100.000 Rels total** |
| First Lap + landing tepat di Start | **100.000 Rels total** |

Tidak boleh dihitung sebagai:

* 100.000 + 20.000 Rels
* 100.000 + 30.000 Rels

> **First Lap menggantikan bonus Rels Start pada movement tersebut.**

Namun, jika pemain **landing tepat di Start**, efek upgrade Landing Start tetap berlaku.

### First Lap + Landing Start

Pemain mendapatkan:

* **100.000 Rels total**
* **1× kesempatan upgrade property** dengan hidden discount ±10%

### First Lap + Melewati Start

Pemain mendapatkan:

* **100.000 Rels total**
* Tidak mendapatkan tambahan +20.000 Rels
* Tidak mendapatkan upgrade Start

Setelah First Lap pertama selesai, bonus Start kembali normal.

---

# 4. Landing Tepat di Start

Landing tepat di Tile Start memberikan:

> **+30.000 Rels**

Selain bonus Rels, pemain mendapatkan kesempatan melakukan **1× upgrade property secara langsung**.

### Aturan Upgrade

1. Sistem menampilkan property milik pemain.
2. Pemain memilih **1 property**.
3. Property tersebut dapat langsung di-upgrade.
4. Tidak perlu landing di tile property tersebut.
5. Hanya **1 property** yang dapat dipilih.
6. Hanya **1 level upgrade** yang dapat dilakukan.
7. Upgrade mengikuti progression normal:

**L1 → L2 → L3 → L4 → L5**

---

# 5. Hidden Discount Start Upgrade

Upgrade melalui Landing Start mendapatkan:

> **Hidden Discount ±10%**

Aturannya:

* Discount tidak ditampilkan sebagai mekanik khusus.
* Harga final dibulatkan ke **kelipatan 500 Rels**.
* Pemain hanya melihat harga final yang harus dibayar.

Konsep:

> Harga Upgrade Normal → Discount ±10% → Pembulatan ke 500 Rels

---

# 6. Tidak Ada Property yang Bisa Di-upgrade

Jika pemain landing tepat di Start tetapi:

* belum memiliki property, atau
* seluruh property miliknya sudah L5,

maka mekanik upgrade tidak dijalankan.

Pemain hanya mendapatkan bonus Rels Start.

---

# 7. Start Bisa Terpicu Lebih dari Sekali dalam Satu Turn

Start tidak dibatasi hanya satu kali per turn.

Start dapat terpicu beberapa kali apabila movement pemain memang melewati Start beberapa kali.

Hal ini dapat terjadi melalui:

* Multiple Double Roll
* Forced Movement
* Movement lain yang sah

Sistem mengikuti movement aktual pemain.

---

# 8. Forced Movement

Forced Movement menggunakan **Movement System yang sama dengan movement normal**.

Artinya, movement tetap:

* menggunakan jalur papan,
* bergerak secara aktual melewati tile,
* menghitung apakah Start dilewati,
* dapat berakhir tepat di Start,
* dan dapat memicu First Lap.

### Penentuan Jalur

Forced Movement menuju suatu destination menggunakan **jalur terpendek**, baik:

* maju, atau
* mundur.

Jika jarak maju dan mundur sama, digunakan:

> **Jalur maju.**

### Event Start

Event Start ditentukan berdasarkan jalur yang benar-benar ditempuh.

Jika jalur melewati Start:

> **Pass Start terpicu.**

Jika destination tepat di Start:

> **Landing Start terpicu.**

Jika movement tersebut merupakan penyelesaian First Lap pertama:

> **First Lap terpicu.**

---

## Contoh Forced Movement

### Contoh A — Tidak Melewati Start

Player berada di Tile 13.

Forced Movement menuju Jail di Tile 10.

Jalur terpendek:

**13 → 12 → 11 → 10**

Tidak melewati Start.

> Tidak mendapatkan Pass Start.

---

### Contoh B — Melewati Start

Player berada di Tile 37.

Forced Movement menuju Jail di Tile 10.

Jalur terpendek:

**37 → 38 → 39 → 0 → 1 → ... → 10**

Movement melewati Start.

> **Pass Start terpicu.**

Jika movement tersebut sekaligus menyelesaikan First Lap:

> Reward Rels = **100.000 Rels total**.

Bukan:

> 100.000 + 20.000 Rels.

---

## Forced Movement Landing di Start

Jika Forced Movement berakhir tepat di Tile 0 / Start:

### Jika merupakan First Lap pertama

> **100.000 Rels total**

dan:

> **1× kesempatan upgrade Start**

### Jika bukan First Lap

> **+30.000 Rels**

dan:

> **1× kesempatan upgrade Start**

Jadi:

> **First Lap menggantikan bonus Rels Start, tetapi tidak menghilangkan efek upgrade dari Landing Start.**

---

# 9. Ringkasan Start + First Lap + Forced Movement

| Situasi                          |               Reward Rels | Upgrade                   |
| -------------------------------- | ------------------------: | ------------------------- |
| Melewati Start setelah First Lap |                  **+20K** | ❌                         |
| Landing Start setelah First Lap  |                  **+30K** | ✅ 1×                      |
| First Lap + melewati Start       |            **100K total** | ❌                         |
| First Lap + landing Start        |            **100K total** | ✅ 1×                      |
| Forced Movement melewati Start   | Mengikuti kondisi di atas | Mengikuti kondisi di atas |
| Forced Movement landing Start    | Mengikuti kondisi di atas | ✅ 1×                      |

### Prinsip Utama

> **First Lap pertama memberikan 100.000 Rels total dan menggantikan bonus Rels Start pada movement tersebut.**

> **Jika movement berakhir tepat di Start, efek upgrade Landing Start tetap diberikan.**

> **Forced Movement mengikuti jalur movement aktual, sehingga Pass Start, Landing Start, dan First Lap tetap dapat terpicu.**

---

# 10. Nilai Final Start

| Mechanic               |                    Nilai |
| ---------------------- | -----------------------: |
| Starting Capital       |         **250.000 Rels** |
| Pass Start             |         **+20.000 Rels** |
| Landing Start          |         **+30.000 Rels** |
| First Lap              |   **100.000 Rels total** |
| Landing Start Upgrade  | **1 property / 1 level** |
| Start Upgrade Discount |         **±10%, hidden** |
| Discount Rounding      |   **Kelipatan 500 Rels** |
| Forced Movement Path   |      **Jalur terpendek** |
| Jika jarak sama        |                 **Maju** |

**STATUS: START SYSTEM — LOCKED 🔒**

Betul. Kita perlu menegaskan **reward dibayarkan setelah movement selesai**, bukan ketika pemain sekadar melewati Start di tengah perjalanan.

Bagian aturannya bisa kita ubah menjadi:

# WAKTU PEMBAYARAN REWARD START

Reward Start dibayarkan **setelah movement pemain selesai**, ketika destination tile sudah tercapai dan hasil movement sudah ditentukan.

## 1. Melewati Start

Jika pemain melewati Start tetapi **tidak berhenti di Start**:

1. Movement berjalan sampai destination.
2. Sistem menentukan bahwa Start telah dilewati.
3. Setelah pemain tiba di destination, reward dibayarkan.
4. Pemain menerima **+20.000 Rels**.

Jika movement tersebut menyelesaikan **First Lap pertama**:

> Pemain menerima **100.000 Rels total**, bukan +20.000 Rels.

---

## 2. Landing Tepat di Start

Jika destination pemain adalah Start:

1. Movement berjalan sampai Tile Start.
2. Pemain benar-benar berhenti di Start.
3. Sistem menentukan **Landing Start**.
4. Reward Rels dibayarkan.
5. Sistem kemudian menjalankan **efek Upgrade Start**.

### Normal

> **+30.000 Rels**

### First Lap

> **100.000 Rels total**

Kemudian tetap mendapatkan:

> **1× kesempatan upgrade property dengan hidden discount ±10%.**

---

## 3. Forced Movement

Aturan pembayaran yang sama berlaku untuk **Forced Movement**.

Reward tidak dibayarkan ketika pemain baru melewati Start di tengah perjalanan.

Reward dibayarkan **setelah Forced Movement selesai** dan destination sudah tercapai.

Contoh:

**Tile 37 → 38 → 39 → Start → 1 → 2 → 10**

Jika destination akhirnya Tile 10:

> Setelah sampai Tile 10 → **reward Pass Start dibayarkan.**

Jika movement tersebut menyelesaikan First Lap pertama:

> Setelah sampai Tile 10 → **100.000 Rels total dibayarkan.**

---

## 4. Prinsip Timing

> **Start Event terdeteksi berdasarkan jalur movement, tetapi Reward dibayarkan setelah movement selesai.**

Dengan demikian:

**Movement**
→ **Sampai Destination**
→ **Resolve Start / First Lap**
→ **Bayar Reward**
→ **Resolve Landing Effect**

Ini berlaku untuk:

* Normal Roll
* Double Roll
* Multiple Double Roll
* Forced Movement
* Movement lain yang menggunakan Movement Engine.

---

## 5. Ringkasan

| Kondisi                        | Kapan reward dibayar?           |            Reward |
| ------------------------------ | ------------------------------- | ----------------: |
| Melewati Start                 | Setelah movement selesai        |          **+20K** |
| Landing Start                  | Setelah tiba di Start           |          **+30K** |
| First Lap + melewati Start     | Setelah movement selesai        |    **100K total** |
| First Lap + Landing Start      | Setelah tiba di Start           |    **100K total** |
| Forced Movement melewati Start | Setelah forced movement selesai | Mengikuti kondisi |
| Forced Movement landing Start  | Setelah tiba di Start           | Mengikuti kondisi |

### Prinsip Final

> **Start hanya menentukan event berdasarkan movement yang terjadi, tetapi pembayaran reward selalu dilakukan setelah movement selesai.**

> **Jika movement berakhir di Start, Landing Start diproses setelah pemain benar-benar tiba di Tile Start.**

# RELOPOLI — START SYSTEM

## Brainstorm Recap & Final Decision

### Status: 🔒 LOCKED

---

## 1. Starting Capital

Setiap pemain memulai permainan dengan:

> **250.000 Rels**

---

## 2. Bonus Start

Tile Start memiliki dua jenis bonus:

| Kondisi                |           Reward |
| ---------------------- | ---------------: |
| Melewati Start         | **+20.000 Rels** |
| Landing tepat di Start | **+30.000 Rels** |

Bonus diberikan berdasarkan movement yang benar-benar ditempuh pemain.

---

# 3. First Lap Bonus

Pemain mendapatkan **First Lap Bonus sebesar 100.000 Rels** ketika pertama kali menyelesaikan satu putaran penuh papan.

### First Lap = 100.000 Rels TOTAL

**100.000 Rels merupakan total reward untuk First Lap, bukan bonus tambahan di atas Bonus Start.**

Artinya:

| Kondisi First Lap                  |            Reward Rels |
| ---------------------------------- | ---------------------: |
| First Lap + melewati Start         | **100.000 Rels total** |
| First Lap + landing tepat di Start | **100.000 Rels total** |

Tidak boleh dihitung sebagai:

* 100.000 + 20.000 Rels
* 100.000 + 30.000 Rels

### Prinsipnya

> **First Lap menggantikan bonus Rels Start pada movement tersebut.**

Namun, jika pemain **landing tepat di Start**, efek lain dari Landing Start tetap berlaku, yaitu kesempatan upgrade property.

---

## 4. First Lap + Landing Start

Jika pemain pertama kali menyelesaikan lap dan berhenti tepat di Start:

### Reward Rels

> **100.000 Rels total**

Bukan:

> 100.000 + 30.000 Rels.

### Upgrade Start

Pemain tetap mendapatkan:

> **1× kesempatan upgrade property**

dengan hidden discount sekitar **10%**.

Jadi First Lap hanya menggantikan **bonus Rels**, bukan efek upgrade dari Landing Start.

---

## 5. First Lap + Melewati Start

Jika pemain menyelesaikan First Lap dengan melewati Start tetapi tidak berhenti di Start:

> **100.000 Rels total**

Tidak mendapatkan tambahan +20.000 Rels.

---

# 6. Bonus Start Setelah First Lap

Setelah First Lap pertama selesai, sistem kembali menggunakan bonus Start normal.

| Kondisi                |           Reward |
| ---------------------- | ---------------: |
| Melewati Start         | **+20.000 Rels** |
| Landing tepat di Start | **+30.000 Rels** |

---

# 7. Landing Tepat di Start

Landing tepat di Tile Start memberikan:

> **+30.000 Rels**

Selain bonus Rels, pemain mendapatkan kesempatan melakukan **1× upgrade property secara langsung**.

### Aturan Upgrade

1. Sistem menampilkan property milik pemain.
2. Pemain memilih **1 property**.
3. Property tersebut dapat langsung di-upgrade.
4. Tidak perlu landing di tile property tersebut.
5. Hanya **1 property** yang dapat dipilih.
6. Hanya **1 level upgrade** yang dapat dilakukan.
7. Upgrade mengikuti progression normal:

**L1 → L2 → L3 → L4 → L5**

---

# 8. Hidden Discount Start Upgrade

Upgrade melalui Landing Start mendapatkan:

> **Hidden Discount ±10%**

Aturannya:

* Discount tidak ditampilkan sebagai mekanik khusus.
* Harga final dibulatkan ke **kelipatan 500 Rels**.
* Pemain hanya melihat harga final yang harus dibayar.

Konsep perhitungan:

> Harga Upgrade Normal → Discount ±10% → Pembulatan ke 500 Rels

---

# 9. Tidak Ada Property yang Bisa Di-upgrade

Jika pemain landing tepat di Start tetapi:

* belum memiliki property, atau
* seluruh property miliknya sudah L5,

maka mekanik upgrade tidak dijalankan.

Pemain hanya mendapatkan:

> **Bonus Rels Start**

---

# 10. Start Bisa Terpicu Lebih dari Sekali dalam Satu Turn

Start tidak dibatasi hanya satu kali per turn.

Start dapat terpicu beberapa kali apabila movement pemain memang melewati Start beberapa kali.

Hal ini dapat terjadi melalui:

* Multiple Double Roll
* Forced Movement
* Movement lain yang sah

Sistem mengikuti movement aktual pemain.

---

# 11. Start pada Forced Movement

Forced Movement menggunakan Movement System yang sama dengan movement normal.

Karena itu, event Start dihitung berdasarkan **jalur movement yang benar-benar ditempuh**.

### Jika melewati Start

> **Pass Start terpicu.**

### Jika berhenti tepat di Start

> **Landing Start terpicu.**

### Jika sekaligus merupakan First Lap

> **First Lap dihitung sesuai aturan First Lap.**

---

# 12. Contoh Forced Movement

### Contoh A — Tidak Melewati Start

Player berada di Tile 13.

Forced Movement menuju Jail di Tile 10.

Jalur terpendek:

**13 → 12 → 11 → 10**

Tidak melewati Start.

> Tidak mendapatkan Pass Start.

---

### Contoh B — Melewati Start

Player berada di Tile 37.

Forced Movement menuju Jail di Tile 10.

Jalur:

**37 → 38 → 39 → 0 → 1 → ... → 10**

Movement melewati Start.

> **Pass Start terpicu.**

Jika movement tersebut sekaligus menyelesaikan First Lap:

> Reward Rels menjadi **100.000 Rels total**, bukan +20.000 Rels.

---

# 13. Forced Movement ke Tile Start

Jika Forced Movement berakhir tepat di Tile 0 / Start:

* Jika movement tersebut merupakan First Lap pertama → **First Lap dihitung**.
* Jika bukan First Lap → **Landing Start biasa**.

Jadi, tidak setiap movement menuju Start otomatis dianggap sebagai First Lap.

---

# 14. Ringkasan Perhitungan

| Situasi                          |    Reward Rels | Upgrade |
| -------------------------------- | -------------: | ------- |
| Melewati Start setelah First Lap |       **+20K** | ❌       |
| Landing Start setelah First Lap  |       **+30K** | ✅ 1×    |
| First Lap + melewati Start       | **100K total** | ❌       |
| First Lap + landing Start        | **100K total** | ✅ 1×    |

**Catatan penting:**

> **100K First Lap selalu merupakan total reward Rels untuk First Lap tersebut. Tidak pernah ditambahkan lagi dengan +20K atau +30K.**

---

# 15. Nilai Final Start

| Mechanic               |                    Nilai |
| ---------------------- | -----------------------: |
| Starting Capital       |         **250.000 Rels** |
| Pass Start             |         **+20.000 Rels** |
| Landing Start          |         **+30.000 Rels** |
| First Lap              |   **100.000 Rels total** |
| Landing Start Upgrade  | **1 property / 1 level** |
| Start Upgrade Discount |         **±10%, hidden** |
| Discount Rounding      |   **Kelipatan 500 Rels** |

---

# 16. Prinsip Utama

**Start bukan hanya titik untuk mendapatkan uang.**

Start memiliki tiga fungsi utama:

1. **Income berkala**

   * Pass Start → +20K
   * Landing Start → +30K

2. **Milestone First Lap**

   * First Lap pertama → 100K total

3. **Kesempatan upgrade**

   * Landing tepat di Start → 1 property dapat di-upgrade
   * Hidden discount ±10%

### Prinsip First Lap

> **First Lap 100.000 Rels menggantikan bonus Rels Start pada movement pertama yang menyelesaikan lap, tetapi tidak menghilangkan efek upgrade dari Landing Start.**

**STATUS: START SYSTEM — LOCKED 🔒**

Iya. Kita tegaskan **urutan proses setelah movement selesai** supaya Start, First Lap, dan efek tile tidak saling tumpang tindih.

# URUTAN PROSES SETELAH MOVEMENT

Setelah pemain selesai bergerak dan **sudah mencapai destination tile**, sistem menjalankan proses secara berurutan.

### Urutan Final

```text
MOVEMENT SELESAI
       ↓
DESTINATION TERCAPAI
       ↓
1. DETEKSI EVENT START
       ↓
2. CEK FIRST LAP
       ↓
3. TENTUKAN REWARD START
       ↓
4. BAYARKAN REWARD
       ↓
5. RESOLVE LANDING TILE
       ↓
6. RESOLVE EFEK LANDING
       ↓
7. LANJUTKAN / AKHIRI TURN
```

---

## 1. Movement Selesai

Pemain harus benar-benar mencapai destination.

Selama movement:

* sistem mencatat jalur yang ditempuh,
* sistem mengetahui apakah Start dilewati,
* tetapi reward **belum dibayarkan**.

---

## 2. Deteksi Event Start

Setelah destination tercapai, sistem memeriksa jalur movement.

### Jika melewati Start

> **Pass Start terdeteksi.**

### Jika destination adalah Start

> **Landing Start terdeteksi.**

Landing Start dianggap terjadi hanya jika pemain benar-benar berhenti di Tile Start.

---

## 3. Cek First Lap

Sistem kemudian memeriksa apakah movement tersebut menyelesaikan **First Lap pertama pemain**.

Jika iya:

> **First Lap = 100.000 Rels total**

Jika tidak:

> Gunakan reward Start normal.

---

## 4. Tentukan Reward Start

### First Lap pertama

| Kondisi        |                 Reward |
| -------------- | ---------------------: |
| Melewati Start | **100.000 Rels total** |
| Landing Start  | **100.000 Rels total** |

Tidak ada tambahan +20K atau +30K.

### Bukan First Lap

| Kondisi        |           Reward |
| -------------- | ---------------: |
| Melewati Start | **+20.000 Rels** |
| Landing Start  | **+30.000 Rels** |

---

## 5. Bayarkan Reward

Setelah nilai reward ditentukan:

> **Reward langsung ditambahkan ke Balance pemain.**

Pembayaran dilakukan **sebelum proses efek landing tile**.

---

## 6. Resolve Landing Tile

Setelah reward Start dibayarkan, sistem memproses destination tile.

Contohnya:

* Property
* Jail
* Reward
* Transport
* Start
* Tile khusus lainnya

**Tile yang hanya dilewati tidak diproses.**

Hanya destination tile yang di-resolve sebagai Landing Tile.

---

## 7. Resolve Efek Landing

Jika destination adalah **Start**, maka setelah reward dibayarkan:

> **Landing Start Upgrade diproses.**

Pemain mendapatkan kesempatan:

* memilih 1 property,
* upgrade 1 level,
* menggunakan hidden discount ±10%.

Jika destination bukan Start, sistem menjalankan efek khusus tile tersebut sesuai aturan tile.

---

## 8. Contoh — Normal Landing Start

Player bergerak:

**35 → 36 → 37 → 38 → 39 → 0**

Movement selesai di Start.

Urutannya:

1. Movement selesai.
2. Destination = Start.
3. Landing Start terdeteksi.
4. First Lap dicek.
5. Jika bukan First Lap → reward **+30K**.
6. **+30K dibayarkan.**
7. Landing Start diproses.
8. UI Upgrade Start muncul.
9. Player memilih 1 property.
10. Upgrade dilakukan.
11. Turn dilanjutkan/diakhiri.

---

## 9. Contoh — First Lap + Landing Start

Player menyelesaikan lap pertama dan berhenti di Start.

Urutannya:

1. Movement selesai.
2. Destination = Start.
3. Landing Start terdeteksi.
4. First Lap terdeteksi.
5. Reward ditetapkan menjadi **100K total**.
6. **100K dibayarkan.**
7. Tidak ada tambahan +30K.
8. Landing Start diproses.
9. UI Upgrade Start muncul.
10. Player mendapatkan **1× kesempatan upgrade**.

---

## 10. Contoh — First Lap + Melewati Start

Player melewati Start dan berhenti di Tile 5.

Urutannya:

1. Movement selesai.
2. Jalur movement terdeteksi melewati Start.
3. Pass Start terdeteksi.
4. First Lap terdeteksi.
5. Reward ditetapkan menjadi **100K total**.
6. **100K dibayarkan.**
7. Tidak ada tambahan +20K.
8. Tile 5 diproses.
9. Turn dilanjutkan/diakhiri sesuai hasil landing.

---

## 11. Prinsip Penting

> **Event Start dideteksi dari jalur movement, tetapi reward baru ditentukan dan dibayarkan setelah movement selesai.**

> **Reward Start dibayarkan sebelum efek Landing Tile diproses.**

> **Jika destination adalah Start, efek Upgrade Start diproses setelah reward Start dibayarkan.**

Dengan demikian urutan sistem yang menjadi acuan adalah:

```text
MOVEMENT
   ↓
MOVEMENT SELESAI
   ↓
DETEKSI START
   ↓
CEK FIRST LAP
   ↓
TENTUKAN REWARD
   ↓
BAYAR REWARD
   ↓
RESOLVE DESTINATION TILE
   ↓
RESOLVE LANDING EFFECT
   ↓
NEXT TURN / NEXT ROLL
```