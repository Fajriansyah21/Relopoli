# Relopoli — Rekap Brainstorm Sistem Jail

> **Status:** Brainstorm selesai untuk tahap ini. Aturan di bawah merupakan hasil keputusan selama pembahasan Jail dan menjadi dasar untuk tahap berikutnya.

---

## 1. Konsep Dasar Jail

* Jail merupakan **state khusus Player**, bukan sekadar tile biasa.
* Ketika Player masuk Jail:

  * Player **langsung di-teleport** ke **Jail Cell**.
  * Player tidak berjalan melalui board untuk masuk ke Cell.
  * Setelah berada di Cell, Player dapat **bergerak bebas di dalam Cell**.
  * Player **tidak dapat keluar dari batas Jail Cell**.
  * Kamera Player berubah menjadi **First Person**.
* Jail Cell dan pergerakan bebas di dalamnya merupakan bagian dari pengalaman Jail, bukan Board Movement biasa.
* Ketika Player masuk Jail, **turn tersebut berakhir**.

---

# 2. Penyebab Masuk Jail

Jail dapat terjadi dari berbagai efek sistem, termasuk:

* **Triple Double**
* News yang memberikan efek masuk Jail.
* Efek lain yang secara eksplisit mengirim Player ke Jail.

### Triple Double

```text
Double #1
↓
Movement
↓
Landing Resolution
↓
Double #2
↓
Movement
↓
Landing Resolution
↓
Double #3
↓
JAIL
↓
Turn End
```

Triple Double **tidak menghasilkan movement dari roll ketiga** dan tidak menjalankan Landing Resolution dari roll tersebut.

---

# 3. Jail Turn

Ketika giliran Player kembali sementara Player masih berada di Jail:

> Player menjalani **Jail Turn**, bukan Normal Turn.

Player mendapatkan **3 pilihan utama**:

```text
┌─────────────────────────┐
│          JAIL           │
│                         │
│  🎲 Double Dice         │
│  💰 Pay 25K             │
│  🃏 Use News             │
└─────────────────────────┘
```

---

# 4. Jail Exit #1 — Double Dice

Player dapat memilih **Double Dice** untuk mencoba keluar dari Jail.

### Flow

```text
Jail Turn
↓
Double Dice
↓
Player melakukan Physical Dice Roll
↓
Check Double
```

### Jika mendapatkan Double

Contoh:

> 3 + 3 = 6

Maka:

```text
Double
↓
Jail dibebaskan
↓
Movement = 6 tile
↓
Landing Resolution
↓
Turn End
```

### Aturan penting

* Double digunakan sebagai **syarat untuk keluar Jail**.
* Total kedua dadu tetap menentukan jarak movement.
* **Tidak mendapatkan Extra Roll.**
* Double Jail berbeda dengan Double pada Normal Turn.
* Setelah berhasil keluar Jail, **Jail Attempt Counter di-reset menjadi 0**.

---

# 5. Jail Attempt Counter

Counter digunakan untuk mencatat jumlah percobaan Double yang gagal selama berada di Jail.

### Awal masuk Jail

```text
Attempt Counter = 0
```

### Gagal Double

```text
Non-Double
↓
Attempt Counter +1
↓
Turn End
```

Contoh:

```text
Attempt #1 → gagal
Attempt #2 → gagal
Attempt #3 → gagal
Attempt #4 → gagal
Attempt #5 → gagal
```

---

# 6. Percobaan Double ke-5

Pada **percobaan kelima**, Player **tetap melakukan Roll terlebih dahulu**.

Bukan langsung dipaksa membayar.

```text
Attempt #5
↓
Player Roll
↓
Double?
```

### Jika Double

```text
Double
↓
Jail Exit
↓
Movement
↓
Landing Resolution
↓
Turn End
```

### Jika gagal

```text
Non-Double
↓
Forced Payment 50K
```

Jadi:

> **50.000 Rels bukan pilihan normal Player.**

50K hanya menjadi **Forced Payment** setelah Player gagal mendapatkan Double sebanyak 5 kali.

---

# 7. Jail Exit #2 — Pay 25K

Player dapat memilih:

> **Pay 25K**

Biaya:

**25.000 Rels**

### Syarat

Jika Balance Player kurang dari 25.000 Rels:

> **Button Pay 25K disabled.**

Pembayaran normal ini **tidak boleh membuat Balance menjadi negatif**.

### Flow

```text
Jail
↓
Pay 25K
↓
-25,000 Rels
↓
Jail dibebaskan
↓
Attempt Counter = 0
↓
System / Police Roll
↓
Dice Result
↓
Movement
↓
Landing Resolution
↓
Turn End
```

---

# 8. Police/System Roll

Untuk jalur:

* **Pay 25K**
* **Use News**

Roll tidak dilakukan oleh Player.

Roll dilakukan oleh:

> **System / Police**

Setelah Roll:

```text
Dice Result
↓
Movement
↓
Landing Resolution
↓
Turn End
```

### Jika Police Roll mendapatkan Double

Double **hanya dianggap sebagai hasil movement biasa**.

Contoh:

> 4 + 4 = 8

Maka:

```text
Police Roll
↓
4 + 4
↓
Movement 8 tile
↓
Landing Resolution
↓
Turn End
```

Tidak ada:

* Extra Roll
* Double Counter
* Triple Double

Police Roll adalah **movement roll khusus**, bukan bagian dari Double Chain normal.

---

# 9. Jail Exit #3 — Use News

Jail Break News digunakan langsung melalui tombol:

> **Use News**

Player **tidak perlu membuka Stored News terlebih dahulu**.

### Flow

```text
Jail
↓
Use News
↓
News dikonsumsi
↓
Player dibebaskan
↓
Kembali ke Tile 10 — Jail
↓
Attempt Counter = 0
↓
System / Police Roll
↓
Dice Result
↓
Player bergerak
↓
Landing Resolution
↓
Turn End
```

Jail Break menggunakan **Physical Dice Roll oleh sistem**, kemudian hasilnya diteruskan ke Movement Engine.

---

# 10. Tiga Jalur Jail Exit

Secara keseluruhan:

| Jalur           | Roll dilakukan oleh |             Biaya | Double Effect                             | Hasil    |
| --------------- | ------------------- | ----------------: | ----------------------------------------- | -------- |
| **Double Dice** | Player              |            Gratis | Double = bebas Jail, **tanpa Extra Roll** | Movement |
| **Pay 25K**     | System / Police     |          25K Rels | Double hanya hasil movement               | Movement |
| **Use News**    | System / Police     | 1 Jail Break News | Double hanya hasil movement               | Movement |

Ketiganya akhirnya menggunakan:

```text
Jail Exit
↓
Movement
↓
Landing Resolution
↓
Turn End
```

---

# 11. Forced Payment 50K

Jika Player telah melakukan **5 percobaan Double** dan percobaan kelima gagal:

> **Forced Payment = 50.000 Rels**

Pembayaran ini berbeda dari Pay 25K.

### Pay 25K

* Voluntary payment.
* Button disabled jika tidak cukup Rels.
* Tidak boleh menghasilkan Negative Balance.

### Forced Payment 50K

* Dipaksakan oleh sistem.
* Balance **boleh menjadi negatif**.
* Jika menjadi negatif, mengikuti sistem Economy.

```text
Negative Balance
↓
Bankruptcy Check
↓
Second Life?
├─ Yes → Second Life
└─ No
    ↓
Asset Liquidation
    ↓
Masih negatif?
├─ Yes → Liquidate lagi
└─ No → selesai
    ↓
Tidak ada aset lagi
↓
Bankruptcy
```

---

# 12. Reset Jail Attempt Counter

**Attempt Counter selalu kembali ke 0 ketika Player berhasil keluar Jail.**

Berlaku untuk:

```text
Double berhasil
→ Counter = 0

Pay 25K
→ Counter = 0

Use News
→ Counter = 0
```

Ketika Player masuk Jail lagi di kemudian hari:

> **Attempt Counter dimulai kembali dari 0.**

---

# 13. Movement Setelah Jail Exit

Semua movement setelah Jail Exit menggunakan **Movement Engine yang sama**.

Tidak dibuat Movement Engine khusus untuk Jail.

```text
Jail Exit
↓
Determine Dice Result
↓
Movement Engine
↓
Official Board Path
↓
Start Detection
↓
Movement Complete
↓
Start Reward
↓
Landing Resolution
↓
Turn End
```

Karena movement tetap menggunakan Movement Engine, aturan umum seperti **melewati Start** tetap berlaku.

---

# 14. Jail dan Start

Jika Police/System Roll atau Double Jail menyebabkan Player melewati Start:

> **Start tetap terdeteksi dan diproses sesuai aturan Start.**

Jail tidak memberikan pengecualian terhadap Start.

Urutannya tetap:

```text
Movement
↓
Start Detection
↓
Movement Complete
↓
Start Reward
↓
Landing Resolution
```

---

# 15. Jail dan Transport

Jika Transport membawa Player ke suatu destination dan efek destination kemudian menyebabkan Player masuk Jail:

```text
Transport
↓
Movement
↓
Destination
↓
Destination Effect
↓
Jail
```

Transport dianggap sudah selesai/terpakai.

Tidak ada **Transport Pending** yang disimpan setelah Player masuk Jail.

---

# 16. Jail dan Modifier Berbasis Waktu

Perlu dibedakan antara **Turn** dan **Round**.

* Efek yang berdurasi **Turn** tetap mengikuti Turn.
* Modifier seperti **Premium Listing** menggunakan **Round**, bukan Turn.
* Round ditentukan berdasarkan crossing **Tile 39 → Tile 0**.
* Jadi menghabiskan beberapa Turn di Jail **tidak otomatis mengurangi modifier yang berbasis Round**.

Contoh:

> Premium Listing 3 Rounds

Player berada di Jail selama beberapa Turn, tetapi belum menyelesaikan Round:

> Timer Premium Listing tidak berkurang hanya karena Player berada di Jail.

---

# 17. Prinsip Utama Jail

Secara desain, Jail sekarang memiliki tiga karakter berbeda:

### 🎲 Double Dice

**Coba keberuntungan.**

### 💰 Pay 25K

**Gunakan uang untuk keluar.**

### 🃏 Use News

**Gunakan resource Jail Break yang sudah dimiliki.**

Dan jika Player terus gagal:

### 💸 Forced Payment 50K

**Konsekuensi otomatis setelah 5 kegagalan.**

---

## Master Flow Jail

```text
                    PLAYER MASUK JAIL
                           ↓
                 Teleport → Jail Cell
                           ↓
              First Person + Free Movement
                  (tidak bisa keluar Cell)
                           ↓
                       Turn End
                           ↓
                     JAIL TURN
                           ↓
          ┌────────────────┼────────────────┐
          ↓                ↓                ↓
     DOUBLE DICE        PAY 25K          USE NEWS
          ↓                ↓                ↓
     Player Roll       Police Roll      Police Roll
          ↓                └───────┬────────┘
          ↓                        ↓
       Double?                 Dice Result
       /    \                      │
     YES     NO                    │
      ↓       ↓                    │
   Jail Exit  Counter +1           │
      ↓       ↓                    │
      │    Turn End                │
      │                            │
      └────────────┬───────────────┘
                   ↓
              Jail Exit
                   ↓
            Counter = 0
                   ↓
               Movement
                   ↓
          Start Detection
                   ↓
           Start Reward
                   ↓
        Landing Resolution
                   ↓
               Turn End
```

**Pengecualian:**

```text
Double Attempt #5
↓
Roll
↓
Non-Double
↓
Forced Payment 50K
↓
Economy / Bankruptcy Flow jika diperlukan
```

Ini sudah mencakup seluruh hasil brainstorming Jail kita sampai titik ini.

# Relopoli — Rekap Brainstorm Sistem Jail

> **Status:** Brainstorm Jail tahap ini selesai.
> Rekap ini menggabungkan aturan Jail, tiga metode Jail Exit, Jail Cell, UI, State, dan transisi setelah keluar Jail yang sudah dibahas.

---

# 1. Konsep Dasar Jail

Jail merupakan **state khusus Player**, bukan sekadar tile biasa.

Ketika Player masuk Jail:

* Player **langsung di-teleport** ke **Jail Cell**.
* Tidak menggunakan Board Movement untuk masuk ke Cell.
* Player dapat **bergerak bebas di dalam Jail Cell**.
* Player **tidak dapat keluar dari batas Jail Cell**.
* Kamera berubah menjadi **First Person**.
* Setelah masuk Jail, **turn berakhir**.

### Jail Cell

```text
JAIL TRIGGER
     ↓
TELEPORT
     ↓
JAIL CELL
     ↓
First Person
     ↓
Free Movement di dalam Cell
     ↓
Tidak dapat keluar Cell
     ↓
Turn End
```

---

# 2. Jail Turn

Pada giliran berikutnya, jika Player masih Jail:

```text
TURN START
     ↓
JAIL STATE ACTIVE
     ↓
JAIL TURN
```

Player **tidak menjalankan Normal Roll**.

Sebagai gantinya, Jail UI menyediakan tiga pilihan:

```text
┌───────────────────────────┐
│           JAIL            │
│                           │
│   🎲 DOUBLE DICE          │
│   💰 PAY 25K              │
│   🃏 USE NEWS              │
└───────────────────────────┘
```

Tiga pilihan tersebut adalah:

1. **Double Dice**
2. **Pay 25K**
3. **Use News**

---

# 3. Jail Exit #1 — Double Dice

Player memilih:

> **Double Dice**

Kemudian Player melakukan **Physical Dice Roll**.

```text
JAIL TURN
   ↓
DOUBLE DICE
   ↓
Player Roll
   ↓
Check Double
```

## Jika mendapatkan Double

Contoh:

> 3 + 3 = 6

Maka:

```text
Double
 ↓
Jail Exit
 ↓
Attempt Counter = 0
 ↓
Movement = 6
 ↓
Movement Engine
 ↓
Landing Resolution
 ↓
Turn End
```

### Aturan penting

* Double menjadi **syarat keluar Jail**.
* Total dadu tetap menentukan jumlah movement.
* **Tidak mendapatkan Extra Roll.**
* Setelah berhasil keluar, Attempt Counter di-reset menjadi 0.

---

# 4. Jail Attempt Counter

Attempt Counter digunakan secara internal untuk menghitung **kegagalan Double**.

Ketika masuk Jail:

```text
Attempt Counter = 0
```

Setiap gagal Double:

```text
Non-Double
 ↓
Attempt Counter +1
 ↓
Turn End
```

### Counter tidak ditampilkan di UI

Tidak ada:

> `Attempts: 2/5`

atau indikator sejenis.

Player sendiri yang menghitung berapa kali sudah gagal.

Sistem tetap menyimpan counter secara internal untuk menentukan kapan Forced Payment berlaku.

---

# 5. Percobaan Double ke-5

Pada percobaan kelima, Player **tetap melakukan Roll terlebih dahulu**.

```text
Attempt #5
 ↓
Player Roll
 ↓
Double?
```

### Jika Double

```text
Double
 ↓
Jail Exit
 ↓
Attempt Counter = 0
 ↓
Movement
 ↓
Landing Resolution
 ↓
Turn End
```

### Jika Non-Double

```text
Non-Double
 ↓
Forced Payment 50K
```

Jadi:

> **50.000 Rels bukan pilihan normal Player.**

50K hanya terjadi setelah Player gagal mendapatkan Double sebanyak **5 kali**.

---

# 6. Jail Exit #2 — Pay 25K

Player dapat memilih:

> **Pay 25K**

Biaya:

**25.000 Rels**

### Kondisi Button

* Balance ≥ 25K → **Button aktif**
* Balance < 25K → **Button disabled**

Pay 25K merupakan voluntary payment sehingga **tidak boleh membuat Balance negatif**.

### Flow

```text
Jail
 ↓
Pay 25K
 ↓
-25,000 Rels
 ↓
Jail Exit
 ↓
Attempt Counter = 0
 ↓
Return to Tile 10
 ↓
Police/System Roll
 ↓
Movement
 ↓
Landing Resolution
 ↓
Turn End
```

---

# 7. Jail Exit #3 — Use News

Player tidak perlu membuka Inventory atau Stored News.

Di Jail UI langsung tersedia:

> **Use News**

### Jika memiliki Jail Break

Button:

> **ACTIVE**

### Jika tidak memiliki Jail Break

Button:

> **DISABLED**

News tidak perlu dicari secara manual.

### Flow

```text
Jail
 ↓
Use News
 ↓
Jail Break News dikonsumsi
 ↓
Jail Exit
 ↓
Attempt Counter = 0
 ↓
Return to Tile 10
 ↓
Police/System Roll
 ↓
Movement
 ↓
Landing Resolution
 ↓
Turn End
```

Mekanisme Jail Break dari News memang sudah ditetapkan menggunakan System Physical Dice Roll setelah Jail dilepas. 

---

# 8. Police / System Roll

**Police Roll bukan sistem Roll baru.**

Ia menggunakan **Roll System yang sama dengan Roll Player**:

* Physical Dice.
* Dadu benar-benar dilempar.
* Kedua dadu harus berhenti.
* Sistem membaca top face.
* Hasil divalidasi.
* Total dadu dihitung.
* Destination ditentukan.
* Movement Engine menjalankan movement.

Perbedaannya hanya:

> **Roll dipicu oleh sistem, bukan Player.**

---

## Double pada Police Roll

Police Roll **boleh menghasilkan Double**.

Contoh:

> 4 + 4 = 8

Maka:

```text
Police Roll
 ↓
4 + 4
 ↓
Movement = 8
 ↓
Landing Resolution
 ↓
Turn End
```

Double hanya dianggap sebagai **hasil movement**.

Tidak ada:

* Extra Roll
* Double Counter
* Triple Double

---

# 9. Label Police Roll

Tidak ada animasi polisi yang mengambil atau melempar dadu.

Cukup tampilkan label:

> **POLICE ROLL**

Kemudian sistem menjalankan Physical Dice Roll seperti biasa.

Contoh:

```text
       POLICE ROLL

          🎲   🎲

        Rolling...
```

Setelah hasil valid:

```text
Police Roll
↓
Dice Result
↓
Movement
```

---

# 10. Attempt Counter Reset

Attempt Counter selalu kembali ke:

> **0**

ketika Player berhasil keluar Jail.

Berlaku untuk semua metode:

```text
Double berhasil
→ Counter = 0

Pay 25K
→ Counter = 0

Use News
→ Counter = 0
```

Jika Player masuk Jail lagi di kemudian hari:

> Counter kembali dimulai dari 0.

---

# 11. Transisi Jail Cell → Tile 10

Jail Cell dan Tile 10 merupakan dua konteks lokasi yang berbeda.

### Saat Jail

```text
Physical Location
→ Jail Cell

Board Position
→ Tile 10
```

Ketika keluar Jail, Player tidak perlu berjalan dari Jail Cell menuju Tile 10.

Untuk transisi visual, konsep yang dibahas:

```text
Jail Cell
 ↓
Fade Out
 ↓
Jail State OFF
 ↓
Position → Tile 10
 ↓
Camera → Normal Third Person
 ↓
Fade In
 ↓
Police Roll
```

Dengan demikian Player tidak melihat perpindahan fisik yang terasa seperti teleport mendadak.

---

# 12. Camera State

### Saat Jail

```text
Camera
→ First Person
```

### Saat Jail Exit

```text
Jail Exit
 ↓
First Person OFF
 ↓
Normal Camera
 ↓
Police/System Roll
```

Kamera kembali ke mode normal **sebelum Board Movement dimulai**.

---

# 13. Free Movement di Jail Cell

Saat berada di Jail Cell:

```text
Manual Movement = ON
```

Player dapat berjalan bebas di dalam Cell.

Tetapi:

```text
Jail Cell Boundary
 ↓
Player tidak dapat keluar
```

Begitu Jail Exit diproses:

```text
Jail Cell Free Movement
→ OFF

Board Automatic Movement
→ ON
```

---

# 14. Pay 25K UI

Tidak perlu membuat indikator khusus untuk biaya.

Button cukup menampilkan:

> **PAY 25K**

Balance tetap terlihat pada HUD.

Contoh:

```text
┌───────────────────────────┐
│           JAIL            │
│                           │
│   🎲 DOUBLE DICE          │
│                           │
│   💰 PAY 25K              │
│                           │
│   🃏 USE NEWS              │
└───────────────────────────┘

             Rels: 87,500
```

Jika Balance <25K:

> **PAY 25K disabled.**

Tidak perlu menambahkan tulisan:

> "Requires 25,000 Rels"

karena angka 25K sudah terlihat pada button dan Balance sudah tersedia di HUD.

---

# 15. Master Flow Jail

```text
                         JAIL TRIGGER
                              ↓
                    TELEPORT TO JAIL CELL
                              ↓
                    First Person Camera
                              ↓
                  Free Movement in Cell
                              ↓
                    Cell Boundary Limit
                              ↓
                          TURN END
                              ↓
                         JAIL TURN
                              ↓
             ┌────────────────┼────────────────┐
             ↓                ↓                ↓
        DOUBLE DICE        PAY 25K          USE NEWS
             ↓                ↓                ↓
        Player Roll       System Roll      System Roll
             ↓                │                │
        Check Double          │                │
        /          \          │                │
      YES           NO        │                │
       ↓             ↓        │                │
   Jail Exit      Counter+1   │                │
       ↓             ↓        │                │
       │          Turn End    │                │
       │                       │                │
       └───────────┬───────────┘                │
                   │                            │
                   └────────────┬───────────────┘
                                ↓
                           Jail Exit
                                ↓
                        Counter = 0
                                ↓
                           Fade Out
                                ↓
                       Return to Tile 10
                                ↓
                       Normal Camera
                                ↓
                           Fade In
                                ↓
                        POLICE ROLL
                                ↓
                      Physical Dice Roll
                                ↓
                         Dice Result
                                ↓
                        Movement Engine
                                ↓
                      Start / Round Check
                                ↓
                     Landing Resolution
                                ↓
                           TURN END
```

### Pengecualian: Double Attempt #5

```text
Attempt #5
 ↓
Player Physical Dice Roll
 ↓
Non-Double
 ↓
Forced Payment 50K
 ↓
Economy / Bankruptcy Flow
```

---

# 16. Ringkasan Tiga Jail Exit

| Exit            | Cara                   | Roll            | Movement            | Extra Roll |
| --------------- | ---------------------- | --------------- | ------------------- | ---------- |
| **Double Dice** | Mendapatkan Double     | Player          | Hasil Roll tersebut | ❌          |
| **Pay 25K**     | Membayar 25K           | System / Police | Police Roll         | ❌          |
| **Use News**    | Menggunakan Jail Break | System / Police | Police Roll         | ❌          |

### Forced Payment

| Kondisi                | Hasil                  |
| ---------------------- | ---------------------- |
| Gagal Double #1–#4     | Tetap Jail             |
| Gagal Double #5        | **Forced Payment 50K** |
| Double pada Attempt #5 | Bebas Jail + Movement  |

---

## 17. Prinsip Utama Jail

Sistem Jail pada akhirnya memiliki pola sederhana:

> **Masuk Jail → berada di Jail Cell → menunggu Jail Turn → pilih salah satu dari tiga metode keluar → kembali ke Tile 10 → Roll → Movement → Landing Resolution → Turn selesai.**

Tiga metode keluar memberikan tiga pendekatan berbeda:

* **Double Dice** → keberuntungan.
* **Pay 25K** → menggunakan Rels.
* **Use News** → menggunakan Jail Break.

Sedangkan **50K Forced Payment** merupakan konsekuensi otomatis apabila lima percobaan Double gagal.