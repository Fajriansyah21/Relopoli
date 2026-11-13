# 🎲 Relopoli — Roll System

**Status: 🔒 LOCKED**

## 1. Aturan Dasar Roll

* Setiap **Normal Turn** selalu dimulai dengan melakukan roll.
* Roll menggunakan **2 dadu fisik**.
* Dadu harus benar-benar berhenti sebelum hasil dibaca.
* Sistem membaca hasil dadu menggunakan **raycast dari atas**.
* Area roll memiliki pembatas fisik agar dadu tidak keluar dari area valid.
* Hasil dadu harus dapat diidentifikasi dengan valid sebelum digunakan.

### Jika Hasil Dadu Tidak Valid

Jika sistem tidak dapat memastikan hasil dadu, misalnya:

* dadu belum berhenti,
* posisi dadu ambigu,
* raycast gagal,
* sisi atas tidak dapat diidentifikasi,

maka hasil tersebut **tidak boleh digunakan** untuk movement maupun Double.

Sistem harus melakukan validasi ulang sampai mendapatkan hasil yang valid.

---

## 2. Nilai Roll

Dengan 2 dadu, kemungkinan total roll adalah:

| Dadu 1 | Dadu 2 | Total |
| -----: | -----: | ----: |
|      1 |      1 |     2 |
|      1 |      2 |     3 |
|    ... |    ... |   ... |
|      6 |      5 |    11 |
|      6 |      6 |    12 |

**Total Roll: 2–12**

Total hasil roll digunakan untuk menentukan jarak movement.

---

## 3. Penentuan Destination

Setelah hasil kedua dadu berhasil dibaca:

1. Sistem mendapatkan nilai kedua dadu.
2. Sistem menghitung **total roll**.
3. Sistem menghitung **destination tile**.
4. Sistem menampilkan **Destination Arrow** pada tile tujuan.
5. Movement Engine menjalankan movement menuju destination.

### Destination Arrow

* Muncul setelah destination berhasil dihitung.
* Berada di atas destination tile.
* Menunjukkan **tile tujuan**, bukan jalur movement.
* Menghilang setelah movement selesai.

---

# 🎲 4. Double

**Double** terjadi ketika kedua dadu menunjukkan angka yang sama.

Contoh:

* 1 + 1 = Double
* 2 + 2 = Double
* 3 + 3 = Double
* 4 + 4 = Double
* 5 + 5 = Double
* 6 + 6 = Double

### Efek Double

Double **tetap menggunakan total kedua dadu sebagai jarak movement**.

Contoh:

> 4 + 4 = 8

Player tetap bergerak **8 tile**.

Setelah movement dan seluruh landing resolution selesai, player mendapatkan **1 roll tambahan**.

---

# 🔁 5. Multiple Double

Double dapat terjadi berkali-kali dalam satu turn.

Contoh:

```text
Roll 1 → Double
   ↓
Movement
   ↓
Landing Resolution
   ↓
Roll 2 → Double
   ↓
Movement
   ↓
Landing Resolution
   ↓
Roll 3 → Double
```

Double Counter dihitung **per turn**.

Counter akan reset ketika turn berakhir.

---

# 🚔 6. Third Consecutive Double

Jika player mendapatkan **Double sebanyak 3 kali berturut-turut dalam satu turn**, terjadi **Triple Double**.

### Triple Double

Pada Double ketiga:

* Double tetap terdeteksi.
* **Tidak melakukan movement.**
* **Tidak melakukan landing resolution.**
* **Tidak mendapatkan extra roll.**
* Player langsung masuk **Jail**.
* Turn langsung berakhir.

Flow:

```text
Roll
 ↓
Double Counter +1
 ↓
Jika Counter = 3
 ↓
TRIPLE DOUBLE
 ↓
Jail
 ↓
Turn End
```

---

# 🧭 7. Hubungan Roll dengan Movement

Roll System tidak menangani proses berjalan karakter.

Roll System bertanggung jawab terhadap:

* Physical Dice Roll
* Dice Stop Detection
* Raycast Dice Reading
* Dice Validation
* Dice Value
* Total Roll
* Double Detection
* Triple Double Detection
* Destination Calculation Trigger
* Destination Arrow Trigger

Sedangkan **Movement Engine** bertanggung jawab terhadap:

* Path
* Direction
* Character Movement
* Movement Speed
* Smooth Turning
* Destination
* Arrival
* Movement Completion

---

# 🛣️ 8. Hubungan dengan Jalur Movement

Normal dice movement selalu menggunakan **Forward Direction**.

Destination dihitung berdasarkan jalur resmi board, kemudian Movement Engine menjalankan karakter mengikuti jalur tersebut.

Movement **tidak menggunakan garis lurus langsung** menuju destination.

```text
Roll
 ↓
Dice Result
 ↓
Calculate Destination
 ↓
Destination Arrow
 ↓
Movement Engine
 ↓
Official Board Path
 ↓
Destination
```

---

# ⭐ 9. Start dan Roll

Start tidak diselesaikan langsung oleh Roll System.

Jika movement melewati Start:

* Start event terdeteksi berdasarkan **jalur movement aktual**.
* Reward Start tidak langsung dibayarkan ketika Start dilewati.
* Reward diproses setelah movement selesai.
* First Lap juga diperiksa pada tahap tersebut.

Dengan demikian, Double maupun normal roll tetap menggunakan aturan Start yang sama.

---

# 🔄 10. Flow Normal Roll

```text
ROLL
  ↓
Baca Dadu
  ↓
Validasi Hasil
  ↓
Detect Double
  ↓
Hitung Destination
  ↓
Tampilkan Destination Arrow
  ↓
Movement
  ↓
Movement Complete
  ↓
Start / First Lap Check
  ↓
Landing Resolution
  ↓
Apakah Double?
 ┌───────────────┐
 │               │
YA              TIDAK
 │               │
 ↓               ↓
Roll Lagi      Turn End
```

---

# 🚔 11. Flow Third Double

```text
ROLL
  ↓
Baca Dadu
  ↓
Validasi Hasil
  ↓
Detect Double
  ↓
Double Counter = 3
  ↓
TRIPLE DOUBLE
  ↓
JAIL
  ↓
TURN END
```

**Tidak ada movement dan landing resolution pada Double ketiga.**

---

# 🎮 12. State Flow

Roll System terintegrasi dengan state turn sebagai berikut:

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

Untuk Triple Double:

```text
DICE_RESOLVING
 ↓
TRIPLE_DOUBLE
 ↓
JAIL
 ↓
TURN_END
```

---

# ⚠️ 13. Aturan Penting

1. Setiap normal turn selalu dimulai dengan roll.
2. Roll menggunakan 2 dadu fisik.
3. Hasil dadu harus valid sebelum diproses.
4. Total roll menentukan jarak movement.
5. Double menggunakan total normal untuk movement.
6. Double memberikan 1 extra roll setelah movement dan landing resolution.
7. Double Counter berlaku hanya dalam satu turn.
8. Third consecutive Double langsung menyebabkan Jail.
9. Third Double **tidak melakukan movement**.
10. Third Double **tidak melakukan landing resolution**.
11. Destination Arrow menunjukkan tujuan, bukan path.
12. Normal dice movement selalu menggunakan Forward Direction.
13. Semua movement dijalankan oleh Movement Engine.
14. Start tetap mengikuti aturan Start System.
15. Double tidak melewati proses Start, First Lap, maupun Landing Resolution.
16. **Nama dan efek khusus untuk “News Double Dice” belum dikunci** dan akan ditentukan terpisah agar tidak membingungkan dengan Double biasa.

---

## 🔒 Final Status

**Roll System: LOCKED**

Roll System sudah memiliki aturan dasar untuk:

* Physical Dice
* Dice Detection
* Dice Validation
* Roll Calculation
* Double
* Multiple Double
* Triple Double
* Destination Calculation
* Destination Arrow
* Integrasi dengan Movement
* Integrasi dengan Start
* Integrasi dengan Landing Resolution
* Turn Flow

Siap. Berikut **rekap Brainstorm Roll System** dalam Markdown, dengan fokus hanya pada keputusan yang kita bahas untuk mekanik dadu dan alur Roll.

````markdown
# RELOPOLI — ROLL SYSTEM

> Status: **BRAINSTORM SELESAI**
>
> Roll System menangani physical dice, pembacaan hasil dadu, Double, destination preview, dan hubungan Roll dengan Movement System.

---

# 1. NORMAL TURN SELALU DIMULAI DENGAN ROLL

Setiap **normal turn** selalu dimulai dengan:

> **Roll dadu**

Tidak ada pilihan untuk melewati Roll pada awal normal turn.

Flow dasar:

```text
TURN START
    ↓
ROLL DICE
    ↓
DICE STOP
    ↓
READ DICE RESULT
    ↓
CALCULATE MOVEMENT
    ↓
SHOW DESTINATION ARROW
    ↓
PLAYER MOVEMENT
````

---

# 2. PHYSICAL DICE

Relopoli menggunakan:

> **Physical Dice**

Dadu benar-benar dilempar secara fisik di area Roll.

Hasil dadu kemudian dibaca oleh sistem.

---

# 3. KAPAN HASIL DADU DIBACA?

System **tidak langsung membaca hasil ketika dice masih bergerak**.

Urutannya:

```text
Dice Roll
   ↓
Dice bergerak / bouncing
   ↓
Dice semakin melambat
   ↓
Dice benar-benar berhenti
   ↓
System memastikan dice stationary
   ↓
Raycast
   ↓
Baca hasil masing-masing dice
```

Jadi:

> **Dice harus benar-benar berhenti sebelum hasilnya dibaca.**

---

# 4. MEMBACA PHYSICAL DICE

System membaca sisi atas dice menggunakan:

> **Raycast dari atas**

Raycast dilakukan setelah dice benar-benar berhenti.

Secara sederhana:

```text
       RAYCAST
          ↓
       ┌─────┐
       │ DICE│
       └─────┘
          ↓
       BOARD
```

Raycast menentukan face yang menghadap ke atas.

Hasil kedua dice kemudian dijumlahkan.

Contoh:

```text
Dice A = 4
Dice B = 5

Total = 9
```

---

# 5. DICE VALIDATION

Sebelum hasil digunakan untuk movement, system melakukan validasi.

Hasil dianggap valid jika:

* Dice sudah benar-benar berhenti.
* Raycast berhasil membaca dice.
* Face atas dapat diidentifikasi.
* Kedua dice memiliki hasil valid.

Jika valid:

> Hasil diterima dan digunakan.

---

# 6. FAILSAFE UNTUK HASIL DICE AMBIGU

Walaupun board dan area dice dirancang agar dice tidak berdiri miring atau menghasilkan posisi ambigu, system tetap memiliki fallback.

Jika:

* Raycast gagal membaca face;
* hasil tidak dapat ditentukan;
* dice belum benar-benar stationary;

maka:

> **Hasil tidak boleh langsung digunakan untuk movement.**

System menunggu/validasi ulang.

Jika tetap tidak valid:

> Dice dapat di-reset dan dilakukan Roll ulang secara otomatis.

Prinsip utama:

> **Invalid dice result tidak boleh menghasilkan movement yang tidak jelas.**

---

# 7. DICE TIDAK AKAN KELUAR AREA VALID

Area board/Roll akan memiliki:

> **Physical Barrier**

Tujuannya agar dice tidak keluar dari area Roll.

Raycast berasal dari atas sehingga posisi dice tetap dapat dibaca selama dice berada dalam area valid.

Kasus dice keluar area dianggap:

> **Tidak menjadi kasus normal.**

---

# 8. HASIL DUA DADU

Karena menggunakan dua dadu:

```text
Minimum = 1 + 1 = 2
Maximum = 6 + 6 = 12
```

Semua hasil normal yang mungkin:

```text
2
3
4
5
6
7
8
9
10
11
12
```

merupakan hasil movement yang valid.

Tidak ada hasil 1 karena dua dadu digunakan.

---

# 9. DICE RESULT → MOVEMENT

Setelah kedua dice dibaca:

```text
Dice A
  +
Dice B
  ↓
TOTAL
  ↓
MOVEMENT DISTANCE
```

Contoh:

```text
Dice A = 3
Dice B = 4

Total = 7
```

Player bergerak:

> **7 tile**

Movement kemudian ditangani oleh **Movement System**.

---

# 10. DESTINATION CALCULATION

Setelah total dice diketahui:

> System menghitung destination tile.

Contoh:

```text
Current Tile = 12
Dice Total   = 7

12 → 13 → 14 → 15 → 16 → 17 → 18 → 19

Destination = Tile 19
```

---

# 11. DESTINATION ARROW

Sebelum player mulai bergerak:

> **Destination Arrow muncul.**

Arrow berada di atas destination tile dan menunjuk tile tersebut.

Flow:

```text
Dice berhenti
    ↓
System membaca hasil
    ↓
Total dice dihitung
    ↓
Destination dihitung
    ↓
Arrow muncul di destination
    ↓
Player bergerak
```

Tujuannya agar player dapat melihat:

> **"Player akan berhenti di tile ini."**

---

# 12. ARROW BUKAN MOVEMENT

Arrow hanya merupakan:

> **Destination Indicator**

Arrow tidak mengubah movement.

Arrow tidak menentukan jalur.

Jalur tetap ditentukan oleh:

> **Movement System**

Movement tetap mengikuti jalur resmi board dan aturan arah movement.

---

# 13. DOUBLE

Jika kedua dice menunjukkan angka yang sama:

> **DOUBLE**

Contoh:

```text
4 + 4 = 8
```

Maka:

* Movement tetap dilakukan sebanyak 8 tile.
* Setelah movement dan landing resolution selesai:

  > Player mendapatkan kesempatan **Roll lagi dalam turn yang sama**.

---

# 14. DOUBLE TIDAK MENAMBAH NILAI MOVEMENT

Double bukan:

> 4 + 4 lalu dikalikan 2.

Double tetap dihitung normal:

```text
4 + 4 = 8
```

Player bergerak:

> **8 tile**

Efek Double adalah:

> **Extra Roll**

bukan tambahan movement.

---

# 15. MULTIPLE DOUBLE

Jika player mendapatkan Double lagi setelah Roll berikutnya:

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
↓
Roll 3
```

Double Counter terus dihitung selama masih berada dalam turn yang sama.

---

# 16. TRIPLE DOUBLE

Jika player mendapatkan:

```text
Double #1
↓
Double #2
↓
Double #3
```

maka:

> **Player langsung masuk Jail.**

Hasil Roll ketiga **tidak menghasilkan movement**.

Artinya:

```text
Third Double
     ↓
Triple Double Detected
     ↓
JAIL
     ↓
TURN END
```

Tidak dilakukan:

* Movement dari Roll ketiga.
* Landing Resolution dari Roll ketiga.
* Extra Roll berikutnya.

---

# 17. DOUBLE COUNTER

Double Counter hanya berlaku dalam:

> **Turn yang sedang berlangsung**

Counter:

```text
Turn Start
↓
Double Counter = 0
```

Jika Double:

```text
Double #1
→ Counter = 1

Double #2
→ Counter = 2

Double #3
→ Triple Double
→ Jail
```

Setelah turn berakhir:

> **Double Counter di-reset.**

---

# 18. URUTAN DOUBLE NORMAL

Untuk Double pertama atau kedua:

```text
ROLL
 ↓
READ DICE
 ↓
DOUBLE DETECTED
 ↓
CALCULATE DESTINATION
 ↓
SHOW ARROW
 ↓
MOVEMENT
 ↓
MOVEMENT COMPLETE
 ↓
START / FIRST LAP CHECK
 ↓
LANDING RESOLUTION
 ↓
ROLL AGAIN
```

Jadi Double tidak langsung menyebabkan Roll berikutnya.

Player harus terlebih dahulu:

> **menyelesaikan movement dan landing resolution.**

---

# 19. THIRD DOUBLE

Untuk Double ketiga:

```text
ROLL
 ↓
READ DICE
 ↓
DOUBLE DETECTED
 ↓
DOUBLE COUNTER = 3
 ↓
TRIPLE DOUBLE
 ↓
JAIL
 ↓
TURN END
```

Tidak ada:

> Destination Arrow

dan tidak ada:

> Movement

untuk Roll ketiga.

---

# 20. INVALID DICE RESULT

Jika hasil physical dice tidak valid:

> **Roll belum dianggap selesai.**

System tidak boleh:

* menghitung movement;
* menampilkan destination;
* menggerakkan player;
* mengaktifkan Double;
* memicu Triple Double.

System terlebih dahulu harus mendapatkan:

> **Valid Dice Result**

---

# 21. ROLL DAN MOVEMENT

Roll System dan Movement System memiliki pembagian tugas yang jelas.

### Roll System

Bertanggung jawab atas:

* Physical Dice Roll
* Dice Stop Detection
* Raycast
* Dice Result Validation
* Dice Value
* Total Dice
* Double Detection
* Triple Double Detection
* Destination Calculation Trigger
* Destination Arrow Trigger

### Movement System

Bertanggung jawab atas:

* Path
* Direction
* Character Movement
* Movement Speed
* Smooth Turning
* Destination Arrival
* Movement Completion

---

# 22. ROLL → MOVEMENT FLOW

Master flow:

```text
NORMAL TURN START
       ↓
PHYSICAL DICE ROLL
       ↓
WAIT FOR BOTH DICE TO STOP
       ↓
VALIDATE DICE
       ↓
READ TOP FACE
       ↓
CALCULATE TOTAL
       ↓
CHECK DOUBLE
       ↓
CHECK TRIPLE DOUBLE
       ↓
IF THIRD DOUBLE
       └──────────────→ JAIL → TURN END

IF NOT THIRD DOUBLE
       ↓
CALCULATE DESTINATION
       ↓
SHOW DESTINATION ARROW
       ↓
MOVEMENT ENGINE
       ↓
MOVEMENT COMPLETE
       ↓
START / FIRST LAP
       ↓
LANDING RESOLUTION
       ↓
DOUBLE?
   ↙          ↘
 YES           NO
  ↓             ↓
ROLL AGAIN    TURN END
```

---

# 23. DOUBLE + START

Double tidak mengubah aturan Start.

Jika movement dari Double melewati Start:

> **Start Event tetap terdeteksi.**

Jika movement dari Double berakhir di Start:

> **Landing Start tetap diproses.**

Jika movement tersebut menyelesaikan First Lap:

> **First Lap tetap diproses.**

Reward Start dibayarkan:

> **setelah movement selesai.**

---

# 24. DOUBLE + LANDING RESOLUTION

Double tidak melewati Landing Resolution.

Contoh:

```text
Roll
↓
Double
↓
Movement
↓
Start / First Lap
↓
Landing Tile
↓
Landing Resolution
↓
Extra Roll
```

Jadi player tidak bisa:

> mendapatkan Double → langsung Roll lagi

sebelum landing sebelumnya selesai diproses.

---

# 25. ROLL AGAIN NEWS

News yang sebelumnya sementara disebut **"News Double Dice"** tidak menggunakan nama tersebut sebagai nama final.

Nama final:

> **Belum ditentukan.**

Efek News tetap dibedakan dari mekanik Double biasa.

Prinsip yang sudah disepakati:

* News tersebut **bukan Double**.
* Nama News tidak boleh membuat player mengira efeknya sama dengan Double Dice.
* Efeknya akan didokumentasikan sebagai mekanik tersendiri ketika nama final ditentukan.

---

# 26. PHYSICAL DICE — MASTER RULE

Prinsip utama:

> **System hanya menerima hasil physical dice setelah kedua dice benar-benar berhenti dan hasil top face dapat dibaca secara valid.**

Jika hasil tidak valid:

> **Tidak ada movement.**

Jika hasil valid:

> **Total dice digunakan sebagai movement distance.**

---

# 27. STATUS ROLL SYSTEM

| Komponen                                | Status               |
| --------------------------------------- | -------------------- |
| Normal Turn selalu dimulai Roll         | 🔒 LOCKED            |
| Physical Dice                           | 🔒 LOCKED            |
| Dice harus benar-benar berhenti         | 🔒 LOCKED            |
| Raycast dari atas                       | 🔒 LOCKED            |
| Physical Barrier                        | 🔒 LOCKED            |
| Semua total 2–12 valid                  | 🔒 LOCKED            |
| Invalid Result tidak langsung digunakan | 🔒 LOCKED            |
| Destination dihitung setelah Roll       | 🔒 LOCKED            |
| Destination Arrow                       | 🔒 LOCKED            |
| Arrow menunjuk final destination        | 🔒 LOCKED            |
| Double = Extra Roll                     | 🔒 LOCKED            |
| Double tetap menggunakan total normal   | 🔒 LOCKED            |
| Multiple Double                         | 🔒 LOCKED            |
| Third Double → Jail                     | 🔒 LOCKED            |
| Third Double tidak melakukan movement   | 🔒 LOCKED            |
| Landing Resolution sebelum Extra Roll   | 🔒 LOCKED            |
| Double Counter per turn                 | 🔒 LOCKED            |
| Double Counter reset setelah turn       | 🔒 LOCKED            |
| News "Double Dice"                      | **Nama belum final** |

---

# FINAL PRINCIPLE

> **Setiap normal turn selalu dimulai dengan physical dice roll. Sistem menunggu kedua dice benar-benar berhenti, membaca top face menggunakan raycast dari atas, memvalidasi hasil, menjumlahkan kedua dice, lalu menentukan destination. Destination Arrow muncul terlebih dahulu sebagai indikator tujuan, kemudian Movement Engine menggerakkan karakter menuju destination.**

> **Double memberikan Extra Roll setelah movement dan landing resolution selesai. Tiga Double berturut-turut dalam satu turn menyebabkan player masuk Jail, dan Roll ketiga tidak menghasilkan movement.**

**ROLL SYSTEM — BRAINSTORM SELESAI / SIAP DIKUNCI.**