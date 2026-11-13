# 🚇 Relopoli — Transport System

## Final Brainstorm Recap

### 1. Konsep Utama

**Transport — Tile 30** adalah fasilitas **Fast Travel**.

Ketika player **landing di Tile 30**, player mendapatkan **1 kesempatan Fast Travel untuk turn berikutnya**.

Fast Travel **tidak langsung digunakan pada turn saat landing**.

---

## 2. Alur Transport

### Turn Saat Landing di Tile 30

1. Player bergerak menuju Tile 30 seperti movement normal.
2. Setelah sampai, Tile 30 terdeteksi sebagai **Transport**.
3. Player mendapatkan **1 Fast Travel privilege**.
4. Turn selesai secara normal.

### Turn Berikutnya

Pada awal turn:

* Player **tidak melakukan roll dadu normal**.
* Sistem membuka **Fast Travel UI**.
* Player memilih satu tile tujuan.
* Player membayar biaya Transport.
* Player bergerak menuju tujuan menggunakan **Movement System** biasa.
* Setelah sampai, efek Transport langsung selesai.
* Tile tujuan kemudian diproses seperti biasa.

---

# 3. Transport Destination UI

Destination ditampilkan dalam bentuk **card**.

Setiap card berisi:

* **Nomor Tile**
* **Nama Tile**
* **Jenis Tile**
* **Informasi Property** jika merupakan property
* **Owner** jika sudah dimiliki
* **Level Property** jika ada
* **Biaya Transport**

### Tile 30

**Tile 30 tidak dapat dipilih** sebagai tujuan Transport.

Card Tile 30 selalu **disabled**.

---

# 4. Biaya Fast Travel

Biaya ditentukan berdasarkan **jarak terpendek** antara posisi player dan tile tujuan.

|      Jarak |       Biaya |
| ---------: | ----------: |
|   1–5 Tile |  5.000 Rels |
|  6–10 Tile |  7.500 Rels |
| 11–15 Tile | 10.000 Rels |
| 16–20 Tile | 12.500 Rels |
| 21–25 Tile | 15.000 Rels |
| 26–30 Tile | 17.500 Rels |
| 31–35 Tile | 20.000 Rels |
| 36–39 Tile | 22.500 Rels |

Semua biaya menggunakan kelipatan **500 Rels**.

### Jika Jarak Sama

Jika jarak forward dan backward sama:

> **Prioritaskan forward.**

---

# 5. Kondisi Rels Tidak Cukup

Jika player memiliki saldo **kurang dari 5.000 Rels**, maka player tidak dapat menggunakan Fast Travel.

Destination UI **tidak ditampilkan**.

Sistem langsung menampilkan:

> **"Rels tidak cukup untuk menggunakan fasilitas ini."**

Tidak perlu tombol **Back/Close**.

Kesempatan Fast Travel dianggap selesai dan turn melanjutkan/berakhir sesuai alur turn.

---

## 6. Jika Saldo Cukup

Jika player memiliki minimal 5.000 Rels:

* Destination UI muncul.
* Semua tile yang tersedia ditampilkan.
* Card dengan biaya **lebih besar dari saldo player** dibuat **disabled**.
* Card yang biayanya mampu dibayar tetap dapat dipilih.

Contoh:

Player memiliki **12.000 Rels**:

* 5.000 → ✅ Bisa
* 7.500 → ✅ Bisa
* 10.000 → ✅ Bisa
* 12.500 → ❌ Disabled
* 15.000 → ❌ Disabled

---

# 7. Movement Transport

Transport **bukan teleport**.

Setelah memilih tujuan, player menggunakan **Movement System yang sama dengan movement normal**.

Karakter:

* berjalan secara smooth,
* mengikuti jalur tile,
* menghadap arah gerakan,
* melakukan smooth turn pada belokan 90°,
* tidak berhenti di setiap tile,
* manual movement player dinonaktifkan selama perjalanan,
* dapat melewati player lain,
* dapat melewati object di jalur,
* collision kembali normal setelah movement selesai.

Untuk perjalanan yang sangat jauh, movement dapat sedikit dipercepat agar turn tidak terasa terlalu lama.

---

# 8. Arrow / Destination Indicator

Transport menggunakan sistem indicator yang sama dengan movement normal.

Setelah tujuan ditentukan:

> **Arrow menunjukkan arah/tujuan perjalanan player.**

Player kemudian bergerak menuju tile tujuan secara otomatis.

---

# 9. Melewati Start

Transport **tidak melewati sistem Start**.

Jika jalur Transport melewati:

**Tile 39 → Tile 0**

maka event **Pass Start** tetap terjadi.

Artinya:

* bonus Pass Start tetap diberikan,
* jika kondisi First Lap terpenuhi, First Lap juga diproses sesuai aturan Start.

Transport hanya menentukan **tujuan perjalanan**.

---

# 10. Setelah Sampai Tujuan

Begitu player mencapai destination:

1. Biaya Transport telah dibayar.
2. Movement selesai.
3. **Fast Travel privilege langsung dikonsumsi.**
4. Tile tujuan diproses.
5. Efek tile berjalan seperti normal.

Tidak ada:

* pending Transport,
* Transport stacking,
* Transport privilege tambahan.

---

# 11. Tile Tujuan Tetap Menggunakan Rules Normal

Transport tidak mengubah fungsi tile tujuan.

### Jika tujuan Property

→ Jalankan sistem Property normal.

### Jika tujuan News

→ News diproses normal.

### Jika tujuan Jail

→ Jalankan sistem Jail normal.

### Jika tujuan Reward

→ Jalankan sistem Reward normal.

### Jika tujuan Crown

→ Jalankan sistem Crown normal.

Dan seterusnya.

Transport hanya mengatur **bagaimana player berpindah ke tile tersebut**.

---

# 12. Contoh Alur

### Contoh 1 — Transport ke Property

Player landing di **Tile 30**.

Turn berikutnya:

> Pilih Tile 15 → bayar biaya Transport → player berjalan menuju Tile 15 → sampai → property resolution berjalan.

---

### Contoh 2 — Transport ke News

Player memilih:

> **Tile 15 — News**

Player berjalan ke Tile 15.

Setelah sampai:

> Transport selesai → News diproses.

Jika News kemudian menyebabkan player masuk Jail, maka player masuk Jail seperti biasa.

**Transport sudah selesai terlebih dahulu.**

---

### Contoh 3 — Transport Melewati Start

Player berada di Tile 35 dan memilih destination yang membuat jalur terpendek melewati:

> 39 → 0 → ...

Maka:

> **Pass Start tetap terpicu.**

Transport tidak membuat player "melewati" event Start.

---

# 13. Batasan Transport

| Aturan                               | Status |
| ------------------------------------ | ------ |
| Fast Travel setelah landing Tile 30  | ✅      |
| Digunakan turn berikutnya            | ✅      |
| Langsung digunakan saat landing      | ❌      |
| Roll dadu saat menggunakan Transport | ❌      |
| Memilih tile tujuan                  | ✅      |
| Tile 30 sebagai tujuan               | ❌      |
| Menggunakan movement system normal   | ✅      |
| Teleport langsung                    | ❌      |
| Melewati Start tetap memicu Start    | ✅      |
| Transport bisa ditumpuk              | ❌      |
| Transport mengubah property          | ❌      |
| Transport mengubah rent              | ❌      |
| Transport mengubah ownership         | ❌      |
| Destination diproses normal          | ✅      |

---

# 🔒 Final Rule

> **Transport adalah Fast Travel sekali pakai yang diperoleh saat player landing di Tile 30 dan digunakan pada turn berikutnya. Player memilih destination berdasarkan biaya jarak terpendek, lalu bergerak menuju destination menggunakan Movement System normal. Setelah sampai, privilege Transport habis dan tile tujuan diproses menggunakan aturan normal.**

# 🚇 RELOPOLI — TRANSPORT SYSTEM

## Rekap Brainstorm

> **Status:** Brainstorm selesai / siap dikunci
> **Tile:** **Tile 30 — Transport**
> **Fungsi:** Fast Travel

---

## 1. Fungsi Utama

Transport merupakan fasilitas **Fast Travel**.

Ketika player **landing di Tile 30**:

> Player mendapatkan **1 kesempatan Fast Travel untuk turn berikutnya**.

Transport **tidak langsung digunakan pada turn saat player mendarat**.

Flow:

```text
Landing Tile 30
      ↓
Transport Privilege aktif
      ↓
Turn selesai
      ↓
Turn berikutnya
      ↓
Fast Travel UI
```

---

# 2. Destination

Pada turn berikutnya, player dapat memilih:

> **Tile mana saja di board**

Tidak ada batas jarak maksimum.

Destination ditampilkan dalam bentuk **kartu-kartu Tile**.

Setiap kartu menampilkan informasi seperti:

* Nomor Tile
* Nama Tile
* Jenis Tile
* Property yang berada di sana, jika ada
* Status kepemilikan Property
* Owner Property, jika ada
* Level Property, jika ada
* **Biaya Transport**

Dengan demikian player dapat mengetahui kondisi destination sebelum memilihnya.

---

# 3. Tile 30 Tidak Bisa Dipilih

**Tile 30 — Transport** sendiri:

> ❌ **Tidak dapat dipilih sebagai destination.**

Kartu Tile 30 tetap dapat ditampilkan, tetapi:

> **Disabled**

Alasannya:

> Player tidak boleh menggunakan Fast Travel untuk tetap berada di Transport yang sama.

---

# 4. Transport Fee

Transport menggunakan sistem:

> **Distance Tier Pricing**

Semakin jauh destination, semakin mahal biaya Fast Travel.

### Harga Final

| Jarak Terpendek | Biaya Transport |
| --------------: | --------------: |
|    **1–5 tile** |  **5,000 Rels** |
|   **6–10 tile** |  **7,500 Rels** |
|  **11–15 tile** | **10,000 Rels** |
|  **16–20 tile** | **12,500 Rels** |
|  **21–25 tile** | **15,000 Rels** |
|  **26–30 tile** | **17,500 Rels** |
|  **31–35 tile** | **20,000 Rels** |
|  **36–39 tile** | **22,500 Rels** |

Semua biaya:

> **Kelipatan 500 Rels**

---

# 5. Penentuan Jarak

System menghitung dua kemungkinan:

### Forward

Mengikuti arah normal board:

> Tile A → A+1 → A+2 → ...

### Backward

Mengikuti arah berlawanan:

> Tile A → A−1 → A−2 → ...

Kemudian:

> **Jalur terpendek dipilih.**

### Jika Jarak Sama

Jika Forward dan Backward memiliki jarak yang sama:

> **Forward diprioritaskan.**

Contoh:

```text
Forward  = 20 tile
Backward = 20 tile

→ System memilih Forward
```

---

# 6. Movement Fast Travel

Transport **tidak menggunakan teleport animation**.

Setelah player memilih destination dan membayar biaya:

> Movement Engine menjalankan perjalanan seperti movement normal.

Player:

* berjalan menuju destination;
* menggunakan fixed movement speed;
* menggunakan smooth movement;
* menggunakan smooth turn;
* tidak berhenti di setiap tile;
* tubuh karakter menghadap arah perjalanan;
* collision dengan player/object tetap menggunakan aturan Movement System.

Jadi secara visual:

> Player terasa seperti **sedang melakukan perjalanan jauh**, bukan tiba-tiba menghilang dan muncul di destination.

---

# 7. Arrow / Destination Indicator

Sebelum movement:

> Direction Arrow muncul menuju destination.

Arrow menunjukkan:

> **Tile tujuan Fast Travel**

Selama movement berlangsung, arrow dapat mengikuti progress movement sesuai aturan Movement System yang sudah ditetapkan.

---

# 8. Transport + Start

Fast Travel tetap menggunakan Movement Engine.

Karena itu, apabila jalur Fast Travel melewati:

> **39 → 0**

maka:

> **Start Pass Event tetap diproses.**

Contoh:

```text
Tile 37
 ↓
38
 ↓
39
 ↓
START
 ↓
1
 ↓
2
 ↓
Destination
```

Karena player benar-benar melewati Start:

> Start Event aktif.

Jadi Transport tidak membuat Start menjadi pengecualian.

---

# 9. Forced Movement dan Pathfinding

Transport menggunakan prinsip pathfinding yang sama dengan Forced Movement lainnya:

> **Nearest Path Rule**

System menghitung:

```text
Forward Distance
vs
Backward Distance
```

Kemudian memilih yang paling dekat.

Jika sama:

> **Forward**

Prinsip ini nantinya dapat digunakan bersama sistem:

* Transport
* News Forced Movement
* Go to Jail
* efek movement lainnya

Sehingga semua perpindahan player menggunakan logika yang konsisten.

---

# 10. Transport Fee Ditampilkan di Card

Biaya Transport ditampilkan langsung pada kartu destination.

Contoh:

```text
┌─────────────────────────────┐
│ Tile 19                     │
│ Skyline Suites              │
│ Property — L4               │
│ Owner: Player 2             │
│                             │
│ Transport Fee: 12,500 Rels  │
│                             │
│          [TRAVEL]            │
└─────────────────────────────┘
```

Player tidak perlu memilih destination terlebih dahulu hanya untuk mengetahui biayanya.

---

# 11. Destination Tidak Terjangkau

Jika biaya destination lebih besar daripada balance player:

> **Kartu Disabled.**

Player masih dapat melihat informasinya, tetapi tidak dapat memilih destination tersebut.

Contoh:

```text
Balance Player = 8,000 Rels

Tile 5
Fee = 5,000
→ ENABLED

Tile 19
Fee = 12,500
→ DISABLED
```

---

# 12. Rels Kurang dari Minimum Transport

Minimum biaya Transport:

> **5,000 Rels**

Jika:

> Player memiliki **< 5,000 Rels**

maka **Transport Destination UI tidak ditampilkan sama sekali**.

Sebagai gantinya, system langsung menampilkan keterangan:

> **"Rels tidak cukup untuk menggunakan fasilitas ini."**

Player tidak perlu:

* menekan Back;
* menekan Close;
* memilih destination.

Fast Travel opportunity selesai dan turn melanjutkan sesuai flow yang berlaku.

---

# 13. Transport Privilege Hanya Sekali

Transport hanya memberikan:

> **1 Fast Travel**

Contoh:

```text
Turn N
↓
Landing Tile 30
↓
Transport Privilege aktif

Turn N+1
↓
Pilih Tile 15
↓
Movement
↓
Tile 15 tercapai
↓
Transport Privilege HABIS
↓
Tile 15 di-resolve
```

Tidak ada Fast Travel kedua dalam turn yang sama.

---

# 14. Destination Resolution

Hal terpenting:

> **Transport selesai terlebih dahulu ketika destination tercapai.**

Setelah itu:

> **Tile tujuan menjalankan sistemnya sendiri.**

### Contoh: Destination Property

```text
Tile 30
 ↓
Fast Travel
 ↓
Tile 15
 ↓
Property Resolution
```

### Contoh: Destination News

```text
Tile 30
 ↓
Fast Travel
 ↓
Tile 15 — Relopoli News
 ↓
Transport Privilege HABIS
 ↓
News Resolution
```

Misalnya News tersebut:

> **Go to Jail**

Maka:

```text
News
 ↓
Player dipindahkan ke Jail
 ↓
Jail Resolution
 ↓
Turn selesai
```

Transport **tidak kembali aktif** setelah player masuk Jail.

---

# 15. Transport + Jail

Tidak ada konsep:

> "Transport Pending"

atau:

> "Transport disimpan karena player masuk Jail."

Karena privilege sudah otomatis habis ketika:

> **Fast Travel Movement selesai dan destination tercapai.**

Apapun yang terjadi setelah destination tercapai adalah bagian dari:

> **Destination Resolution**

---

# 16. Transport + News

Jika destination adalah News:

> News langsung dijalankan setelah player tiba.

Transport sudah selesai terlebih dahulu.

Contoh:

```text
Transport
 ↓
Fast Travel → News
 ↓
Transport selesai
 ↓
News aktif
 ↓
News Effect
```

---

# 17. Transport + Property

Jika destination adalah Property:

> Property Resolution dijalankan seperti landing biasa.

Jadi Fast Travel **tidak mengubah aturan Property**.

Jika Property milik player lain:

> Rent tetap diproses.

Jika cukup Rels:

> Opsi membeli Property tetap dapat muncul sesuai aturan Property.

Jika Property sendiri:

> Upgrade/Property Resolution berlaku sesuai sistem Property.

---

# 18. Transport + Crown / Special Tile

Jika destination merupakan:

* Crown
* Reward
* Jail
* News
* Property
* Start
* tile special lainnya

maka:

> **Sistem tile tersebut tetap dijalankan normal.**

Transport hanya menentukan:

> **bagaimana player mencapai destination.**

---

# 19. Transport Tidak Mengubah Destination

Fast Travel tidak:

* mengubah level Property;
* mengubah ownership;
* mengubah Rent;
* memberikan bonus khusus;
* mengubah status tile.

Transport hanya:

> **memindahkan player ke destination yang dipilih dengan biaya tertentu.**

---

# 20. Final Flow

```text
LAND ON TILE 30
       ↓
GET TRANSPORT PRIVILEGE
       ↓
TURN ENDS
       ↓
NEXT TURN
       ↓
CHECK BALANCE
       ↓
Balance < 5K?
   ↙          ↘
 YES           NO
  ↓             ↓
Show           Show
"Rels tidak    Destination
cukup..."      Cards
                 ↓
          Calculate Distance
                 ↓
       Calculate Transport Fee
                 ↓
       Affordable Destination?
          ↙             ↘
        NO              YES
         ↓                ↓
     Disabled          Enabled
                           ↓
                  Player selects
                           ↓
                    Pay Transport
                           ↓
                  Movement Engine
                           ↓
                    Destination
                           ↓
              Transport Privilege END
                           ↓
                Resolve Destination
                           ↓
                      Turn Flow
```

---

# 🔒 TRANSPORT STATUS

| Sistem                                | Status                                                  |
| ------------------------------------- | ------------------------------------------------------- |
| Tile Transport                        | **Tile 30**                                             |
| Fungsi                                | **Fast Travel**                                         |
| Aktif setelah landing                 | **Turn berikutnya**                                     |
| Jumlah penggunaan                     | **1×**                                                  |
| Destination                           | **Tile mana saja**                                      |
| Tile 30 sebagai destination           | ❌                                                       |
| Pricing                               | **Berdasarkan jarak**                                   |
| Minimum Fee                           | **5,000 Rels**                                          |
| Maximum Fee                           | **22,500 Rels**                                         |
| Semua fee                             | **Kelipatan 500**                                       |
| Distance tie                          | **Forward**                                             |
| Movement                              | **Movement System**                                     |
| Teleport                              | ❌                                                       |
| Start tetap aktif saat dilewati       | ✅                                                       |
| Destination tile tetap di-resolve     | ✅                                                       |
| Transport stack                       | ❌                                                       |
| Transport pending setelah destination | ❌                                                       |
| Rels < 5K                             | **UI tidak muncul**                                     |
| Pesan insufficient Rels               | **"Rels tidak cukup untuk menggunakan fasilitas ini."** |
| Kartu mahal                           | **Disabled**                                            |
| Harga ditampilkan di kartu            | ✅                                                       |

> **TRANSPORT — BRAINSTORM COMPLETE / READY TO LOCK.**