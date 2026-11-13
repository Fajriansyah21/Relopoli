Siap. Berikut **rekap hasil brainstorming Movement System** dalam format Markdown, supaya bisa langsung kamu masukkan ke source Relopoli dan dipakai sebagai acuan dokumentasi.

````markdown
# RELOPOLI — MOVEMENT SYSTEM

> Status: **LOCKED**
> 
> Movement System adalah sistem utama yang menangani seluruh perpindahan karakter di board, baik dari Normal Roll maupun Forced Movement.

---

# 1. KONSEP UTAMA

Player bergerak menggunakan karakter 3D, bukan pawn/marker.

Movement harus terasa seperti karakter benar-benar:

> **berjalan mengelilingi board**

bukan berpindah secara teleport.

Semua movement yang sah menggunakan **Movement Engine** yang sama.

Termasuk:

- Normal Dice Movement
- Double Dice Movement
- Forced Movement
- Transport
- Jail Escape
- Movement dari News
- Movement dari efek tile lainnya

---

# 2. MOVEMENT SPEED

Movement menggunakan:

> **Fixed Movement Speed**

Kecepatan dasar karakter tetap konsisten.

Namun, jika destination sangat jauh:

> System dapat sedikit meningkatkan movement speed.

Tujuannya:

- tetap terlihat seperti karakter berjalan;
- perjalanan jauh tidak terasa terlalu lambat;
- tidak menggunakan teleport.

### Prinsip

```text
Jarak pendek
→ Normal Walking Speed

Jarak jauh
→ Slightly Faster Walking Speed
````

Perubahan speed harus tetap terasa natural.

---

# 3. MOVEMENT PATH

Karakter tidak berhenti di setiap tile.

Movement berjalan secara:

> **Continuous / Smooth Movement**

Contoh:

```text
Tile A
  ↓
  ↓
  ↓
Tile B
  ↓
  ↓
Tile C
```

Bukan:

```text
Tile A
STOP
Tile B
STOP
Tile C
STOP
```

Karakter bergerak mulus melewati seluruh tile menuju destination.

---

# 4. PATH LINE

Setiap tile memiliki posisi/path reference.

Movement menggunakan posisi tile tersebut sebagai acuan, tetapi karakter tidak bergerak dengan gerakan kaku dari satu titik ke titik berikutnya.

System menggunakan:

> **Smooth Path / Interpolated Path**

Tujuannya agar perjalanan terlihat natural.

Karakter tetap mengikuti jalur board yang benar.

---

# 5. BELOKAN 90°

Jika jalur berubah arah:

```text
→ → →
      ↓
      ↓
      ↓
```

karakter tidak langsung melakukan:

```text
→
↓
```

secara kaku.

Sebaliknya:

> **Smooth Turn**

Karakter melakukan rotasi secara bertahap mengikuti arah perjalanan.

---

# 6. ORIENTASI KARAKTER

Selama automatic movement:

> **Tubuh dan anggota badan karakter menghadap arah movement.**

Karakter terlihat benar-benar sedang berjalan menuju destination.

Kamera tidak dikunci.

Player tetap bebas menggerakkan kamera 3D third-person.

### Penting

Yang dikontrol oleh Movement System:

> **orientasi tubuh karakter**

Bukan:

> **kamera player**

---

# 7. PLAYER CONTROL SAAT MOVEMENT

Selama automatic movement:

> Player tidak dapat menggerakkan karakter secara manual.

Tujuannya untuk mencegah:

* movement conflict;
* teleport tidak sengaja;
* karakter keluar dari path;
* bug position;
* duplicate movement;
* desync antara client dan server.

Player tetap dapat:

> **menggerakkan kamera secara bebas.**

---

# 8. COLLISION SAAT MOVEMENT

Selama automatic movement:

> Tubuh fisik karakter dapat menembus player lain dan object.

Dengan demikian:

* player tidak saling menabrak;
* object tidak menghentikan movement;
* karakter tidak terdorong;
* movement tidak terganggu oleh player lain.

Setelah automatic movement selesai:

> Collision kembali normal.

### Prinsip

```text
MOVEMENT START
      ↓
Disable Character Collision
      ↓
Automatic Movement
      ↓
Movement Finished
      ↓
Restore Normal Collision
```

---

# 9. PLAYER DI DESTINATION

Jika terdapat player lain tepat di destination:

> Movement tetap berjalan sampai destination.

Tidak terjadi:

* pushing;
* blocking;
* bouncing;
* collision stop;
* movement cancellation.

Player yang sedang bergerak dapat overlap/pass-through selama automatic movement.

---

# 10. OBJECT DI JALUR

Object yang berada di sekitar jalur tidak boleh menyebabkan karakter:

* berhenti;
* terdorong;
* tersangkut;
* berubah arah secara tidak sengaja.

Movement Engine tetap menggunakan:

> **valid board path**

sehingga karakter tetap bergerak mengikuti jalur board.

---

# 11. MOVEMENT ARROW

Setelah dice berhenti dan destination sudah ditentukan:

> **Arrow muncul pada destination.**

Arrow menunjukkan tile yang akan dituju player.

Flow:

```text
Dice Stop
   ↓
System membaca hasil dice
   ↓
Calculate Destination
   ↓
Arrow muncul di Destination
   ↓
Movement dimulai
```

Arrow bukan indikator tile yang sedang dilewati.

---

# 12. ARROW SELAMA MOVEMENT

Arrow tetap digunakan sebagai indikator tujuan.

Movement tidak mengubah destination hanya karena karakter sedang berjalan.

Setelah player mencapai destination:

> Arrow dihapus.

---

# 13. MOVEMENT RESOLUTION

Tile yang dilewati selama movement:

> **Tidak di-resolve.**

Hanya destination yang menjadi Landing Tile.

Contoh:

```text
Tile 5
 ↓
6
 ↓
7
 ↓
8
 ↓
Tile 9
```

Jika destination adalah Tile 9:

> Hanya Tile 9 yang diproses sebagai landing.

Tile 6, 7, dan 8 tidak memicu landing effect.

---

# 14. START DAN MOVEMENT

Walaupun tile yang dilewati tidak dianggap landing:

> **Start tetap dapat terdeteksi sebagai event movement.**

Jika player melewati:

```text
39 → 0
```

maka:

> **Pass Start Event**

tetap terpicu.

Namun reward Start:

> **baru dibayarkan setelah movement selesai.**

Urutan:

```text
Movement
 ↓
Destination Reached
 ↓
Detect Start Event
 ↓
Check First Lap
 ↓
Calculate Start Reward
 ↓
Pay Reward
 ↓
Resolve Destination Tile
```

---

# 15. MOVEMENT TIDAK BOLEH DI-INTERRUPT

Automatic Movement tidak boleh dihentikan oleh player secara manual.

Selama movement:

> Destination sudah ditetapkan.

System menyelesaikan movement sampai destination.

Interrupt hanya dapat terjadi karena kondisi sistem tertentu, misalnya:

* character reset;
* character death;
* disconnect;
* server-side cancellation;
* invalid movement state.

---

# 16. CHARACTER RESET / DEATH

Jika player mati atau melakukan reset saat movement:

> **Movement dibatalkan.**

Position player kemudian:

> dikembalikan/ditetapkan ke **last valid state**.

Server tetap memproses:

> **Turn State**

agar player tidak mendapatkan keuntungan atau kerugian dari movement yang gagal.

---

# 17. PLAYER DISCONNECT

Jika player disconnect saat movement:

> Movement state harus dibersihkan oleh server.

Tidak boleh meninggalkan state:

```text
MOVING = true
```

secara permanen.

Server tetap menjadi sumber kebenaran terhadap:

* position state;
* movement state;
* turn state;
* destination;
* resolution state.

---

# 18. MOVEMENT DUPLICATION

Satu movement trigger:

> **hanya boleh menghasilkan satu Movement Execution.**

System tidak boleh memproses:

```text
Roll Event
+
Duplicate Roll Event
```

sebagai dua movement.

---

# 19. MOVEMENT STATE

Movement menggunakan state yang jelas.

Contoh:

```text
IDLE
 ↓
ROLLING
 ↓
DICE_RESOLVING
 ↓
DESTINATION_PREVIEW
 ↓
MOVING
 ↓
LANDING_RESOLUTION
 ↓
NEXT_ROLL / TURN_END
```

Ketika state:

> **MOVING**

movement baru tidak boleh dipicu secara bersamaan.

---

# 20. DOUBLE + MOVEMENT

Jika player mendapatkan Double:

> Player mendapatkan kesempatan Roll berikutnya.

Namun setiap Roll tetap memiliki movement sendiri.

Contoh:

```text
Roll 1
 ↓
Double
 ↓
Movement
 ↓
Landing Resolution
 ↓
Roll 2
 ↓
Double
 ↓
Movement
 ↓
Landing Resolution
```

Jika mendapatkan Double ketiga:

> Player masuk Jail sesuai aturan Triple Double.

Movement dari Double ketiga:

> **tidak dijalankan.**

---

# 21. FORCED MOVEMENT

Forced Movement menggunakan:

> **Movement Engine yang sama**

dengan Normal Movement.

Dengan demikian Forced Movement juga memiliki:

* smooth walking;
* fixed movement speed;
* smooth turning;
* collision pass-through;
* destination arrow;
* Start detection;
* destination resolution.

---

# 22. FORCED MOVEMENT PATH

Untuk Forced Movement menuju destination:

System menghitung:

```text
Forward Distance
vs
Backward Distance
```

Kemudian memilih:

> **jalur terpendek.**

Jika jaraknya sama:

> **Forward diprioritaskan.**

---

# 23. FORCED MOVEMENT + START

Jika Forced Movement melewati Start:

> **Pass Start tetap terdeteksi.**

Jika Forced Movement berhenti tepat di Start:

> **Landing Start terdeteksi.**

Jika movement tersebut menyelesaikan First Lap:

> **First Lap diproses.**

Reward tetap mengikuti aturan:

> **Reward dibayarkan setelah Forced Movement selesai.**

---

# 24. DOUBLE + FORCED MOVEMENT

Forced Movement tidak membuat Double Counter secara otomatis.

Forced Movement juga tidak dianggap sebagai Roll.

Jadi:

> Forced Movement ≠ Dice Roll.

Double Counter hanya berasal dari:

> **hasil Roll dice.**

---

# 25. TRANSPORT + MOVEMENT

Transport menggunakan:

> **Movement Engine**

yang sama.

Transport bukan teleport.

Flow:

```text
Transport Destination dipilih
 ↓
Bayar Transport
 ↓
Movement Engine
 ↓
Character berjalan
 ↓
Destination
 ↓
Transport selesai
 ↓
Destination Resolution
```

---

# 26. JAIL ESCAPE + MOVEMENT

Jika player keluar Jail menggunakan mekanisme yang menghasilkan Dice Roll:

```text
Jail Escape
 ↓
System Roll Physical Dice
 ↓
Check Result
 ↓
Jika valid
 ↓
Movement Engine
 ↓
Destination
 ↓
Landing Resolution
```

Movement tetap menggunakan Movement Engine.

---

# 27. MOVEMENT + NEWS

News yang menyebabkan perpindahan juga menggunakan:

> **Movement Engine**

Contoh:

```text
News
 ↓
Forced Movement Destination
 ↓
Movement Engine
 ↓
Destination
 ↓
News/Tile Resolution
```

Tidak dibuat sistem movement terpisah untuk News.

---

# 28. PHYSICAL MOVEMENT VS LOGICAL MOVEMENT

Movement Engine memiliki dua bagian:

### Logical Movement

Server menentukan:

* current tile;
* destination tile;
* direction/path;
* movement distance;
* Start crossing;
* final position;
* landing destination.

### Visual Movement

Client menampilkan:

* walking animation;
* character movement;
* smooth rotation;
* movement speed;
* camera view;
* destination arrow.

Server tetap menjadi:

> **source of truth.**

---

# 29. MOVEMENT COMPLETION

Movement dianggap selesai hanya ketika:

> Character mencapai destination yang telah ditentukan.

Setelah itu:

```text
MOVING
 ↓
MOVEMENT_COMPLETE
 ↓
START / FIRST LAP CHECK
 ↓
DESTINATION RESOLUTION
 ↓
LANDING EFFECT
 ↓
NEXT STATE
```

---

# 30. MASTER MOVEMENT FLOW

```text
MOVEMENT REQUEST
       ↓
Validate Request
       ↓
Check Current State
       ↓
Determine Destination
       ↓
Determine Path
       ↓
Create Movement State
       ↓
Disable Manual Character Movement
       ↓
Enable Movement Collision Rules
       ↓
Show Destination Arrow
       ↓
Start Automatic Movement
       ↓
Smooth Walking
       ↓
Smooth Turning
       ↓
Reach Destination
       ↓
Movement Complete
       ↓
Restore Normal Collision
       ↓
Restore Manual Character Control
       ↓
Remove Arrow
       ↓
Detect Start / First Lap
       ↓
Resolve Start Reward
       ↓
Resolve Destination Tile
       ↓
Landing Resolution
       ↓
Continue Turn / End Turn
```

---

# 31. CORE PRINCIPLES

Movement System Relopoli mengikuti prinsip:

> **1. Movement harus terlihat seperti karakter benar-benar berjalan.**

> **2. Semua movement menggunakan satu Movement Engine.**

> **3. Player tidak dapat mengontrol karakter selama automatic movement.**

> **4. Kamera tetap bebas dikontrol player.**

> **5. Tubuh karakter menghadap arah movement.**

> **6. Movement menggunakan smooth path dan smooth turning.**

> **7. Player/object tidak boleh mengganggu movement.**

> **8. Tile yang dilewati tidak di-resolve sebagai landing.**

> **9. Start tetap dapat terdeteksi ketika dilewati.**

> **10. Reward Start baru diproses setelah movement selesai.**

> **11. Movement tidak boleh dipicu dua kali.**

> **12. Server menjadi sumber kebenaran movement state.**

> **13. Forced Movement, Transport, Jail Escape, dan News menggunakan Movement Engine yang sama.**

> **14. Movement bukan teleport.**

---

# 32. STATUS FINAL

| Komponen                                 | Status     |
| ---------------------------------------- | ---------- |
| Fixed Movement Speed                     | 🔒 LOCKED  |
| Long Distance Speed Adjustment           | 🔒 LOCKED  |
| Smooth Movement                          | 🔒 LOCKED  |
| Smooth Turn                              | 🔒 LOCKED  |
| 90° Corner Handling                      | 🔒 LOCKED  |
| Free Camera                              | 🔒 LOCKED  |
| Character Manual Control During Movement | ❌ DISABLED |
| Character Body Faces Movement Direction  | 🔒 LOCKED  |
| Pass-through Player                      | 🔒 LOCKED  |
| Pass-through Object                      | 🔒 LOCKED  |
| Collision Restored After Movement        | 🔒 LOCKED  |
| Destination Arrow                        | 🔒 LOCKED  |
| Tile Passed ≠ Landing Resolution         | 🔒 LOCKED  |
| Start Crossing Detection                 | 🔒 LOCKED  |
| Forced Movement                          | 🔒 LOCKED  |
| Transport Movement                       | 🔒 LOCKED  |
| Jail Movement                            | 🔒 LOCKED  |
| News Movement                            | 🔒 LOCKED  |
| Duplicate Movement Prevention            | 🔒 LOCKED  |
| Reset/Death Handling                     | 🔒 LOCKED  |
| Disconnect Handling                      | 🔒 LOCKED  |
| Server Authority                         | 🔒 LOCKED  |

---

# FINAL MOVEMENT PRINCIPLE

> **Relopoli tidak memindahkan player dari Tile A ke Tile B secara instan. Player benar-benar berjalan melewati board menggunakan Movement Engine yang konsisten, smooth, dan server-authoritative.**

```
```

# RELOPOLI — MOVEMENT SYSTEM

## 1. Konsep Utama

Relopoli menggunakan **Movement Engine terpusat** untuk seluruh pergerakan karakter.

Movement Engine digunakan oleh:

* Normal Dice Movement
* Double Dice Movement
* Forced Movement
* Transport / Fast Travel
* Jail Escape
* Relopoli News yang menyebabkan perpindahan
* Efek sistem lain yang membutuhkan perpindahan karakter

Semua jenis movement menggunakan standar pergerakan yang sama agar perilaku karakter konsisten.

---

# 2. Karakter & Pergerakan

* Player menggunakan **karakter 3D**, bukan pion.
* Karakter berjalan secara otomatis mengikuti jalur board.
* Pergerakan berlangsung **smooth/continuous**, bukan berpindah tile satu per satu secara kaku.
* Posisi tile digunakan sebagai referensi jalur dan tujuan.
* Karakter tidak berhenti setiap kali melewati tile.
* Karakter melakukan rotasi secara halus ketika berbelok.
* Belokan 90° menggunakan smooth turning.
* Karakter menghadap mengikuti arah pergerakannya.

### Movement Speed

* Pergerakan menggunakan fixed movement speed.
* Untuk perjalanan yang sangat jauh, sistem dapat meningkatkan kecepatan sedikit agar durasi turn tidak terasa terlalu lama.
* Peningkatan tersebut tetap terlihat sebagai **berjalan**, bukan teleportasi.

---

# 3. Camera

Camera menggunakan sistem **free third-person camera**.

Selama karakter bergerak otomatis:

* Player tetap dapat mengontrol kamera secara bebas.
* Player tidak dapat mengontrol pergerakan karakter secara manual.
* Karakter tetap berjalan otomatis mengikuti Movement Engine.
* Camera tidak dipaksa mengikuti arah movement tertentu.

---

# 4. Collision Saat Movement

Selama automatic movement:

* Karakter dapat melewati karakter player lain.
* Karakter dapat melewati object yang tidak seharusnya menghalangi jalur.
* Player lain yang berada di destination tile tidak dapat menghalangi movement.
* Tidak ada push, bounce, atau blocking antar-player selama movement otomatis.

Collision normal dikembalikan setelah movement selesai.

---

# 5. Destination

Setelah sistem menentukan hasil movement:

1. Sistem menentukan destination tile.
2. Destination arrow muncul.
3. Arrow menunjukkan tile tujuan.
4. Karakter mulai bergerak menuju destination.
5. Karakter mengikuti jalur board secara otomatis.
6. Setelah destination tercapai, movement selesai.

### Destination Arrow

Arrow berfungsi sebagai **indikator tujuan**, bukan indikator pergerakan tile-by-tile.

Arrow:

* Muncul setelah destination diketahui.
* Menunjuk destination tile.
* Tetap menjadi referensi visual selama movement.
* Dihapus setelah movement selesai.

---

# 6. Landing Rule

Tile yang dilewati selama movement **tidak dianggap sebagai landing**.

Hanya tile terakhir yang dicapai yang dianggap sebagai landing.

Contoh:

```text
Tile 10
   ↓
Tile 11
   ↓
Tile 12
   ↓
Tile 13
   ↓
Tile 14 ← Destination
```

Player hanya melakukan **Landing Resolution pada Tile 14**.

Tile 11, 12, dan 13 tidak menjalankan efek landing.

---

# 7. Start Detection

Start merupakan pengecualian terhadap aturan landing.

Walaupun player tidak berhenti di Start, sistem tetap mendeteksi apabila jalur movement melewati Start.

Contoh:

```text
37 → 38 → 39 → 0 → 1 → 2 → ... → 10
```

Player tidak landing di Start, tetapi sistem tetap mendeteksi bahwa Start telah dilewati.

Namun:

> **Reward Start tidak langsung dibayarkan ketika karakter melewati Start.**

Reward diproses setelah movement selesai.

---

# 8. Urutan Setelah Movement

Setelah karakter mencapai destination:

1. **Movement selesai**
2. **Detect Start Event**
3. **Check First Lap**
4. **Determine Start Reward**
5. **Pay Start Reward**
6. **Resolve Destination Tile**
7. **Resolve Landing Effect**
8. **Continue / End Turn**

Dengan demikian, Start Event selalu diproses sebelum efek landing destination.

Contoh:

```text
Player bergerak
      ↓
Movement selesai
      ↓
Start terdeteksi?
      ↓
Check First Lap
      ↓
Bayar Reward Start
      ↓
Resolve Destination
      ↓
Landing Effect
      ↓
Lanjut / End Turn
```

---

# 9. Multiple Start Trigger

Start dapat terpicu lebih dari satu kali dalam satu turn apabila movement memang melewati Start beberapa kali.

Contohnya dapat terjadi melalui:

* Multiple Dice Movement
* Double
* Forced Movement
* Movement lain yang secara sah melewati Start beberapa kali

Setiap crossing Start yang valid tetap dihitung oleh sistem.

Namun seluruh reward Start tetap diproses setelah movement terkait selesai.

---

# 10. Forced Movement

Forced Movement menggunakan **Movement Engine yang sama**.

Artinya Forced Movement tetap:

* Menggunakan jalur board.
* Bergerak secara smooth.
* Menggunakan automatic movement.
* Menggunakan destination.
* Mendeteksi crossing Start.
* Menjalankan Landing Resolution pada destination.

### Pemilihan Jalur

Forced Movement menggunakan **shortest path**.

Jika jarak forward dan backward sama:

> **Forward dipilih sebagai default.**

---

# 11. Forced Movement & Dice

Forced Movement:

* Bukan hasil roll dice.
* Tidak menambah double counter.
* Tidak mereset double counter.
* Tidak dianggap sebagai normal dice roll.

Forced Movement hanya memindahkan karakter menggunakan Movement Engine.

---

# 12. Transport

Transport menggunakan Movement Engine yang sama.

Transport:

1. Menentukan destination.
2. Menampilkan destination.
3. Menggerakkan karakter secara otomatis.
4. Mendeteksi Start apabila dilewati.
5. Mencapai destination.
6. Menjalankan Landing Resolution.

Transport bukan teleportasi.

---

# 13. Jail Movement

Movement ketika player keluar Jail juga menggunakan Movement Engine.

Jika player berhasil keluar Jail melalui hasil double:

* Sistem menentukan hasil dice.
* Player bergerak sesuai hasil tersebut.
* Movement menggunakan Movement Engine.
* Destination tetap menjalankan Landing Resolution.

---

# 14. Relopoli News Movement

News yang menyebabkan player berpindah posisi juga menggunakan Movement Engine.

Dengan demikian News Movement tetap mengikuti:

* Jalur board
* Smooth movement
* Start detection
* Destination system
* Landing Resolution

Tidak ada sistem movement terpisah khusus untuk News.

---

# 15. Movement Tidak Dapat Dibatalkan Manual

Selama automatic movement berlangsung:

> Player tidak dapat menghentikan movement secara manual.

Movement hanya dapat berhenti apabila:

* Destination tercapai.
* Sistem membatalkan movement.
* Character reset/death.
* Player disconnect.
* Server membatalkan movement karena invalid state atau kondisi sistem lainnya.

---

# 16. Character Reset / Death

Jika character reset atau mengalami kondisi yang membuat movement tidak dapat dilanjutkan:

1. Movement dibatalkan.
2. Sistem mengembalikan player ke **last valid state**.
3. Movement state dibersihkan.
4. Server tetap melanjutkan pengelolaan turn state.

Tujuannya agar player tidak terjebak dalam status:

```text
MOVING
```

secara permanen.

---

# 17. Disconnect

Jika player disconnect ketika sedang bergerak:

* Server membersihkan movement state.
* Tidak boleh ada movement state yang tertinggal.
* Turn/state permainan harus tetap konsisten.
* Player tidak boleh membuat game terjebak karena disconnect.

---

# 18. Double Movement

Setiap roll memiliki movement dan landing resolution masing-masing.

Contoh:

```text
Roll 1
↓
Movement
↓
Landing Resolution
↓
Roll 2
↓
Movement
↓
Landing Resolution
```

Jika mendapatkan double:

* Player mendapatkan kesempatan roll berikutnya.
* Movement pertama tetap diselesaikan terlebih dahulu.
* Landing effect tetap diproses sebelum roll berikutnya.

### Third Double

Jika player mendapatkan **three consecutive doubles**:

> Player masuk Jail.

Roll ketiga **tidak menghasilkan movement**.

---

# 19. Movement State

Movement merupakan bagian dari state machine permainan.

Contoh alur:

```text
IDLE
  ↓
ROLLING
  ↓
DICE_RESOLVING
  ↓
DESTINATION_PREVIEW
  ↓
MOVING
  ↓
LANDING_RESOLUTION
  ↓
NEXT_ROLL / TURN_END
```

Movement tidak boleh berjalan apabila state permainan tidak mengizinkannya.

---

# 20. Server Authority

Server merupakan **source of truth** untuk movement.

Server menentukan:

* Apakah movement valid.
* Destination.
* Jalur movement.
* Start detection.
* Kapan movement dimulai.
* Kapan movement selesai.
* Landing resolution.
* Perubahan state player.

Client bertugas terutama untuk:

* Menampilkan pergerakan karakter.
* Menampilkan rotation.
* Menampilkan destination arrow.
* Menampilkan visual movement.

Client tidak menjadi sumber utama keputusan movement.

---

# 21. Master Movement Flow

Secara keseluruhan:

```text
Validate Movement Request
        ↓
Check Current Game State
        ↓
Determine Destination
        ↓
Determine Path
        ↓
Create Movement State
        ↓
Disable Manual Character Movement
        ↓
Enable Pass-Through Collision
        ↓
Show Destination Arrow
        ↓
Automatic Character Movement
        ↓
Reach Destination
        ↓
Restore Collision
        ↓
Restore Character Control
        ↓
Remove Destination Arrow
        ↓
Detect Start / First Lap
        ↓
Resolve Start Reward
        ↓
Resolve Destination Tile
        ↓
Resolve Landing Effect
        ↓
Continue Turn / End Turn
```

---

# 22. Prinsip Utama Movement System

Movement System Relopoli memiliki prinsip:

1. **Satu Movement Engine untuk seluruh jenis movement.**
2. **Character bergerak smooth, bukan teleport.**
3. **Player tidak mengontrol karakter selama automatic movement.**
4. **Camera tetap free third-person.**
5. **Tile yang dilewati tidak dianggap landing.**
6. **Hanya destination yang menjalankan Landing Resolution.**
7. **Start tetap terdeteksi ketika dilewati.**
8. **Reward Start dibayarkan setelah movement selesai.**
9. **Forced Movement menggunakan shortest path.**
10. **Tie distance → Forward.**
11. **Collision player/object tidak menghalangi automatic movement.**
12. **Server adalah sumber kebenaran movement.**
13. **Movement state harus selalu dibersihkan ketika movement selesai atau dibatalkan.**
14. **Semua sistem yang memindahkan player menggunakan Movement Engine yang sama.**

---

## Status

**Movement System — BRAINSTORM SELESAI / DIKUNCI UNTUK SEMENTARA**

Konsep utama Movement Engine, automatic movement, destination, Start detection, Forced Movement, collision, camera, state management, dan server authority sudah direkap sebagai dasar implementasi Relopoli.

# RELOPOLI — ATURAN JALUR & ARAH MOVEMENT

## 1. Movement Selalu Mengikuti Jalur Board

Setiap movement wajib mengikuti **jalur resmi board Relopoli**.

Karakter tidak boleh:

* Memotong melewati bagian dalam board.
* Berjalan diagonal langsung menuju destination.
* Melewati tile atau jalur yang tidak termasuk rute board.
* Menggunakan jalur di luar track untuk memperpendek perjalanan.

**Visual karakter mengikuti jalur board, bukan garis lurus antara posisi awal dan destination.**

---

## 2. Jalur Ditentukan Berdasarkan Urutan Tile

Setiap tile memiliki hubungan dengan tile berikutnya dalam jalur board.

Movement mengikuti koneksi antar-tile tersebut.

Contoh:

```text
Tile 10 → Tile 11 → Tile 12 → Tile 13
```

Jika player bergerak dari Tile 10 menuju Tile 13, karakter mengikuti:

```text
10 → 11 → 12 → 13
```

Bukan:

```text
10 ─────────→ 13
```

---

# 3. Dua Arah Movement

Board Relopoli memiliki dua kemungkinan arah movement:

* **Forward**
* **Backward**

### Forward

Forward berarti bergerak mengikuti **arah utama urutan tile board**.

Contoh:

```text
10 → 11 → 12 → 13 → 14
```

### Backward

Backward berarti bergerak berlawanan dengan arah utama urutan tile.

```text
14 → 13 → 12 → 11 → 10
```

Keduanya tetap mengikuti jalur board yang sama.

---

# 4. Movement Tidak Boleh Memilih Jalur Secara Bebas

Player tidak memilih sendiri jalur visual yang akan dilewati.

Sistem menentukan jalur berdasarkan:

1. Posisi tile awal.
2. Destination tile.
3. Arah movement yang berlaku.
4. Jalur resmi board.

Setelah jalur ditentukan, Character mengikuti jalur tersebut secara otomatis.

---

# 5. Normal Dice Movement

Untuk movement hasil dice normal:

> **Movement menggunakan arah Forward sesuai aturan board.**

Contoh:

```text
Player berada di Tile 10
Roll = 4

10 → 11 → 12 → 13 → 14
```

Destination:

```text
Tile 14
```

Player tidak dapat memilih bergerak backward.

---

# 6. Movement yang Memang Menentukan Arah

Beberapa sistem dapat menentukan movement secara eksplisit ke arah tertentu.

Contoh:

* Forced Movement Forward
* Forced Movement Backward
* Transport
* Relopoli News
* Movement khusus lainnya

Jika sistem telah menentukan arah, Movement Engine wajib mengikuti arah tersebut.

Contoh Forced Movement Backward:

```text
Tile 20
↓
19
↓
18
↓
17
↓
16
```

Destination:

```text
Tile 16
```

---

# 7. Shortest Path

Untuk movement yang memiliki **pilihan Forward atau Backward**, sistem membandingkan jarak kedua arah.

Contoh:

```text
Forward  = 8 tile
Backward = 15 tile
```

Maka sistem menggunakan:

```text
Forward
```

karena lebih pendek.

---

# 8. Jika Jarak Forward dan Backward Sama

Jika jarak Forward dan Backward memiliki jumlah tile yang sama:

> **Forward selalu menjadi pilihan default.**

Contoh:

```text
Forward  = 10 tile
Backward = 10 tile
```

Maka:

```text
Selected Path = Forward
```

Aturan ini berlaku agar sistem tidak menghasilkan pilihan jalur yang ambigu.

---

# 9. Jalur Saat Melewati Start

Start merupakan bagian dari jalur board.

Jika movement melewati Start, karakter benar-benar mengikuti jalur melewati tile Start tersebut.

Contoh:

```text
37 → 38 → 39 → Start → 1 → 2 → 3
```

Character secara visual melewati Start sebagai bagian dari movement.

Namun:

> Melewati Start bukan berarti landing di Start.

Start hanya menghasilkan **Start Event** yang diproses setelah movement selesai.

---

# 10. Arah Karakter

Character selalu menghadap ke arah jalur movement.

Saat bergerak:

* Character menghadap arah perjalanan.
* Saat jalur berbelok, Character melakukan rotasi secara smooth.
* Character tidak melakukan teleport rotation secara tiba-tiba.
* Arah badan dan movement tetap mengikuti jalur.

Contoh:

```text
        13
        ↑
        │
10 → 11 → 12
```

Saat melewati Tile 11 menuju Tile 12, Character bergerak ke kanan.

Saat kemudian berbelok menuju Tile 13, Character melakukan rotasi secara smooth untuk menghadap ke atas.

---

# 11. Movement Mengikuti Bentuk Jalur

Jalur movement tidak harus berupa garis lurus antar-tile.

Jika board memiliki:

* tikungan,
* sudut,
* lengkungan,
* perubahan arah,

Character mengikuti bentuk jalur tersebut secara smooth.

Tile berfungsi sebagai **node/referensi jalur**, sedangkan pergerakan Character menggunakan path yang halus di antara node tersebut.

---

# 12. Destination Bukan Garis Lurus

Destination Arrow hanya menunjukkan **tujuan akhir**.

Arrow tidak berarti Character bergerak langsung menuju tile tersebut secara garis lurus.

Contoh:

```text
Start
  │
  ↓
Tile 5 → Tile 6 → Tile 7
                   ↓
                Destination
```

Character tetap mengikuti:

```text
5 → 6 → 7
```

bukan:

```text
5 ─────────→ 7
```

---

# 13. Ringkasan Aturan Jalur

| Situasi                                   | Aturan                              |
| ----------------------------------------- | ----------------------------------- |
| Normal Dice Movement                      | Forward                             |
| Forced Movement dengan arah tertentu      | Ikuti arah yang ditentukan          |
| Movement dengan pilihan Forward/Backward  | Pilih shortest path                 |
| Forward & Backward sama jauh              | Forward                             |
| Melewati Start                            | Tetap mengikuti jalur board         |
| Destination                               | Hanya menentukan titik akhir        |
| Visual movement                           | Mengikuti jalur board secara smooth |
| Character direction                       | Menghadap arah movement             |
| Tikungan                                  | Smooth rotation                     |
| Memotong board                            | Tidak diperbolehkan                 |
| Bergerak diagonal langsung ke destination | Tidak diperbolehkan                 |
| Melewati jalur resmi                      | Tidak diperbolehkan                 |

---

# 14. Prinsip Final

> **Character selalu bergerak melalui jalur resmi board dari tile ke tile, mengikuti arah movement yang telah ditentukan sistem. Untuk movement yang memiliki pilihan arah, sistem menggunakan shortest path; jika Forward dan Backward sama jauh, Forward dipilih. Character tidak pernah memotong board atau bergerak langsung secara garis lurus menuju destination.**