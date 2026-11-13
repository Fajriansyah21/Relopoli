Berikut rekap final **Brainstorm Reward Tile 20** dalam format Markdown.

# 🎁 RELOPOLI — REWARD TILE 20

## 1. Fungsi Dasar

Ketika pemain **mendarat di Tile 20 (Reward)**:

1. Sistem menampilkan daftar/kartu seluruh properti milik pemain.
2. Pemain memilih **tepat 1 properti**.
3. Properti tersebut mendapatkan **Reward Rent Multiplier**.
4. Multiplier berlaku terhadap **final rent**, termasuk **Set Bonus** jika properti tersebut merupakan bagian dari Set.

---

## 2. Besaran Reward

Terdapat dua mode Reward:

| Kondisi Room           |  Multiplier |        Durasi |
| ---------------------- | ----------: | ------------: |
| Belum ada L5           | **2× Rent** | **3 putaran** |
| Sudah ada minimal 1 L5 | **3× Rent** | **3 putaran** |

### Catatan Penting

**3× tidak permanent.**

Awalnya sempat dibahas bahwa keberadaan L5 dapat membuat Reward menjadi 3× secara permanen, tetapi keputusan final adalah:

> **Reward 3× juga hanya berlangsung selama 3 putaran.**

---

## 3. Jika Pemain Mendapat Reward Lagi

Jika pemain kembali mendarat di Tile 20 sebelum Reward sebelumnya selesai:

* Pemain memilih **properti baru**.
* Multiplier berpindah dari properti lama ke properti baru.
* Properti lama kembali ke **Rent normal**.
* Durasi Reward **reset menjadi 3 putaran** sejak pemilihan properti baru.

### Contoh

```text
Reward aktif:
Pinewood = 2× selama 3 putaran

Pemain kembali ke Tile 20
↓
Memilih Maple
↓
Pinewood → kembali normal
Maple → mendapat Reward
↓
Timer Maple = 3 putaran
```

---

## 4. Properti yang Bisa Dipilih

Reward dapat diberikan kepada seluruh level properti:

* L1 → ✅
* L2 → ✅
* L3 → ✅
* L4 → ✅
* L5 → ✅

**L5 diperbolehkan menjadi target Reward.**

---

## 5. Hubungan dengan Set Bonus

Reward bekerja terhadap **final rent**.

Urutan perhitungan:

```text
Base Rent
↓
Set Bonus
↓
Reward Multiplier
↓
Final Rent
```

Artinya, Reward **tidak menggantikan Set Bonus**.

### Contoh

Jika:

```text
Rent normal = 10K
Set Bonus   = 12K
```

Dengan Reward 2×:

```text
12K × 2 = 24K
```

Dengan Reward 3×:

```text
12K × 3 = 36K
```

---

## 6. Jika Properti Dijual atau Berpindah Tangan

Jika properti yang sedang mendapatkan Reward:

* dijual ke Bank, atau
* berpindah kepemilikan ke pemain lain,

maka **Reward Multiplier pada properti tersebut hilang**.

Properti kembali menjadi properti normal sesuai status kepemilikan barunya.

---

# 🔒 STATUS FINAL REWARD TILE 20

| Mekanik                                     | Status        |
| ------------------------------------------- | ------------- |
| Tile Reward                                 | **Tile 20**   |
| Pemain memilih properti                     | ✅             |
| Hanya 1 properti aktif                      | ✅             |
| L1 bisa dipilih                             | ✅             |
| L2 bisa dipilih                             | ✅             |
| L3 bisa dipilih                             | ✅             |
| L4 bisa dipilih                             | ✅             |
| L5 bisa dipilih                             | ✅             |
| Reward normal                               | **2× Rent**   |
| Reward saat ada L5                          | **3× Rent**   |
| Durasi 2×                                   | **3 putaran** |
| Durasi 3×                                   | **3 putaran** |
| 3× permanent                                | ❌             |
| Reward mengikuti Set Bonus                  | ✅             |
| Kembali ke Reward → pilih properti baru     | ✅             |
| Reward lama hilang saat target berpindah    | ✅             |
| Timer reset saat memilih target baru        | ✅             |
| Reward hilang jika properti dijual/transfer | ✅             |
| Rent Cap                                    | **Tidak ada** |

---

## 🏁 Kesimpulan Final

**Reward Tile 20 memberikan pemain kesempatan untuk memilih satu properti miliknya dan memberikan multiplier Rent selama 3 putaran.**

* Kondisi normal → **2× Rent selama 3 putaran**
* Jika sudah ada minimal satu L5 di room → **3× Rent selama 3 putaran**
* L5 sendiri dapat menjadi target Reward.
* Reward diterapkan **setelah Set Bonus**, sehingga memperbesar final rent.
* Jika pemain mendapatkan Reward lagi, target dapat dipindahkan ke properti lain dan timer kembali menjadi 3 putaran.
* Jika properti berpindah kepemilikan atau dijual, Reward pada properti tersebut hilang.
* **Tidak ada Rent Cap.**

**Reward Tile 20 — FINAL 🔒**

Betul, ini perlu ditegaskan supaya **“3 putaran” tidak ambigu**.

### 🔄 Arti “3 Putaran” pada Reward

**3 putaran berarti 3 kali giliran milik pemain yang mendapatkan Reward.**

Jadi, **bukan 3 kali seluruh pemain di Room menyelesaikan giliran**, dan bukan pula 3 kali pemain mendarat di Tile 20.

Contoh:

```text
Pemain A mendarat di Tile 20
↓
Memilih Pinewood
↓
Reward 2× aktif
↓
┌─────────────────────────┐
│ Giliran A #1 → 2× aktif │
│ Giliran A #2 → 2× aktif │
│ Giliran A #3 → 2× aktif │
└─────────────────────────┘
↓
Reward berakhir
↓
Pinewood kembali ke Rent normal
```

Jadi selama **3 giliran berikutnya milik pemain tersebut**, properti yang dipilih mendapatkan multiplier.

### Jika pemain kembali ke Tile 20

Misalnya Reward masih aktif pada giliran ke-2:

```text
Giliran A #1 → Reward aktif
Giliran A #2 → Mendarat Tile 20
              → memilih properti baru
              → Timer RESET
Giliran A #3 → Reward aktif
Giliran A #4 → Reward aktif
Giliran A #5 → Reward aktif
Giliran A #6 → Reward berakhir
```

Dengan kata lain:

> **“3 putaran” = 3 giliran pemain pemilik Reward, dihitung setelah Reward diperoleh/diaktifkan.**

Ini juga berarti **giliran pemain lain tidak mengurangi durasi Reward milik pemain tersebut.**

L5 punya **dua peran berbeda** dalam sistem Reward:

1. **L5 menjadi pemicu mode 3×**

   * Jika di dalam Room sudah ada **minimal 1 properti L5**, Reward yang didapat pemain menjadi **3× Rent**.
   * 3× ini tetap hanya berlangsung **3 putaran**.

2. **L5 juga boleh dipilih sebagai target Reward**

   * Jadi pemain bisa memilih properti L5 miliknya sendiri ketika mendapatkan Reward.
   * L5 tersebut mendapatkan multiplier **2× atau 3×**, tergantung kondisi Reward saat itu.
   * Tidak ada pengecualian khusus untuk L5.
   * **Tidak ada Rent Cap.**

Contoh:

```text
Room sudah memiliki L5
↓
Pemain A mendarat di Tile 20
↓
Reward = 3× Rent
↓
Pemain A memilih L5 miliknya
↓
L5 tersebut mendapat 3× Rent
↓
Berlaku selama 3 giliran A
```

Jadi secara sederhana:

> **L5 bukan hanya pemicu 3×, tetapi L5 juga valid untuk menerima Reward 3×.**

Dan **harga/nilai L5 tidak berubah** karena Reward; yang berubah hanya multiplier rent-nya.