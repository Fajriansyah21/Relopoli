Siap. Berikut rekap **brainstorm Ownership Visual System** yang sudah kita kunci, dalam format Markdown.

# Relopoli — Rekap Brainstorm Ownership Visual System

## 1. Tujuan

Sistem ownership harus membuat pemain dapat mengenali **siapa pemilik sebuah Property dengan cepat**, tanpa menghilangkan identitas visual dari Property dan District itu sendiri.

Prinsip utama:

> **Property tetap memiliki identitasnya sendiri. Player Color menunjukkan ownership.**

---

## 2. Player Color

Setiap player memiliki warna ownership yang konsisten:

| Player   | Ownership Color |
| -------- | --------------- |
| Player 1 | 🔴 Red          |
| Player 2 | 🔵 Blue         |
| Player 3 | 🟢 Green        |
| Player 4 | 🟡 Yellow       |

Warna ini digunakan sebagai bagian dari **Ownership Frame**.

Namun, **warna bukan satu-satunya indikator ownership**, agar sistem tetap mudah dikenali secara visual.

---

# 3. Ownership Frame

Kita memilih:

## **Option C — Ownership Frame**

Property **tidak diwarnai penuh** mengikuti warna player.

Sebaliknya, Property memiliki sebuah **Ownership Frame** sebagai layer visual terpisah.

Konsepnya seperti sebuah **title deed / tanda kepemilikan** yang melekat pada Property.

### Karakteristik

* Mengikuti area/perimeter Property.
* Bersifat clean dan modern.
* Tidak terlalu tebal.
* Tidak menutupi artwork Property.
* Tetap terlihat dari jarak board.
* Menggunakan warna Player.
* Tetap berada sebagai layer terpisah dari visual bangunan.
* Tidak mengubah identitas visual Property atau District.

---

# 4. Style Ownership Frame — C2

Kita memilih:

## **C2 — Property Plaque**

Ownership Frame menggunakan sebuah **Property Plaque** sebagai area utama informasi kepemilikan.

Konsep visual:

```text
┌─────────────────────────┐
│                         │
│      PROPERTY ART       │
│                         │
│                         │
└─────────────────────────┘
      ┌───────────────┐
      │ 🔴 PlayerName │
      └───────────────┘
```

Plaque menjadi bagian dari Ownership Frame, bukan UI terpisah yang muncul di layar.

### Fungsi Plaque

Plaque menampilkan:

* **Player Emblem / Marker**
* **Nama Player Roblox**

---

# 5. Player Name

Tulisan ownership **tidak menggunakan "Player 1", "Player 2", dan seterusnya** sebagai teks yang tampil di game.

Sebaliknya, sistem akan menggunakan **nama Roblox player yang sedang memiliki Property**.

Contoh:

```text
🔴 RizkyGamer
```

atau:

```text
🔵 AditPlayz
```

Nama tersebut bersifat dinamis berdasarkan owner Property.

### Catatan

`Player 1–4` hanya merupakan identitas internal untuk menentukan ownership color:

```text
Player 1 → Red
Player 2 → Blue
Player 3 → Green
Player 4 → Yellow
```

Sedangkan yang ditampilkan kepada pemain adalah **nama Roblox player**.

---

# 6. Player Emblem / Marker

Ownership tidak boleh bergantung hanya pada warna.

Karena itu, Property Plaque juga memiliki **Player Emblem / Marker**.

Contoh:

```text
🔴 RizkyGamer
```

Emblem berfungsi sebagai secondary ownership cue.

Tujuannya agar:

* ownership lebih mudah dikenali,
* warna tidak menjadi satu-satunya indikator,
* informasi ownership tetap terbaca secara visual.

---

# 7. District Color vs Player Color

Keduanya memiliki fungsi berbeda.

### District Color

Menunjukkan:

> **Property ini termasuk District mana?**

### Player Color

Menunjukkan:

> **Property ini dimiliki siapa?**

Karena itu:

> **District Color tidak berubah ketika Property berpindah tangan.**

Contohnya:

```text
District Identity
      ↓
Tetap sama

Ownership
      ↓
Merah → Biru
```

Artwork Property juga tetap mempertahankan identitas District-nya.

---

# 8. Ownership Saat Upgrade

Ownership Frame **tidak berubah ketika Property naik level**.

Contoh:

```text
L1 → L2 → L3 → L4 → L5
```

Player tetap sama.

Maka:

```text
Property Artwork
     berubah

Ownership Frame
     tetap

Player Name
     tetap

Player Emblem
     tetap
```

Dengan demikian, pemain dapat langsung mengetahui bahwa bangunan yang berkembang tersebut masih dimiliki oleh player yang sama.

---

# 9. Ownership Saat Transfer

Jika Property berpindah kepemilikan:

```text
Player 1
Red
↓
Transfer
↓
Player 2
Blue
```

Yang berubah hanya **Ownership Layer**.

Property tetap mempertahankan:

* Level
* Artwork
* District Identity
* Kondisi Property
* Modifier yang memang mengikuti Property

Yang berubah:

* Ownership Color
* Player Emblem
* Player Name

Contoh:

```text
Sebelum

┌─────────────────┐
│   PROPERTY      │
└─────────────────┘
  ┌─────────────┐
  │ 🔴 Rizky    │
  └─────────────┘


Setelah Transfer

┌─────────────────┐
│   PROPERTY      │
└─────────────────┘
  ┌─────────────┐
  │ 🔵 Adit     │
  └─────────────┘
```

---

# 10. Saat Property Menjadi Unowned

Jika Property kehilangan owner:

```text
Owned
  ↓
Unowned
```

Maka:

* Ownership Frame menghilang.
* Property Plaque menghilang.
* Player Name menghilang.
* Player Emblem menghilang.
* Player Color menghilang.

Property kembali menjadi:

> **Unowned + L1 / Empty Land + clean state**

---

# 11. Animasi Ownership Saat Acquisition

Urutan visual setelah pembelian Property:

```text
Purchase Confirmed
        ↓
Property Transformation
        ↓
Building Settles
        ↓
Ownership Frame Appears
        ↓
Player Emblem Appears
        ↓
Rent Billboard Updates
```

Ownership tidak muncul sebelum bangunan selesai melakukan transformation.

Tujuannya agar visual board mengikuti prinsip:

> **UI menjelaskan keputusan. Board menunjukkan konsekuensinya.**

---

# 12. Animasi Ownership Saat Transfer

Untuk transfer ownership, animasinya dapat menggunakan urutan:

```text
Old Ownership Frame
       ↓
Retract / Fade Out
       ↓
Property Remains
       ↓
New Ownership Frame
       ↓
New Player Emblem
       ↓
New Player Name
```

Property sendiri **tidak perlu berubah atau melakukan transformation ulang**, karena yang berubah hanya owner.

---

# 13. Idle, Hover, dan Interaction State

Ownership Frame memiliki beberapa tingkat visual emphasis.

### Idle

* Subtle
* Tetap terlihat
* Tidak mendominasi Property

### Hover / Focus

* Frame menjadi sedikit lebih terang
* Plaque lebih mudah terbaca

### Interaction

* Ownership Frame dapat menjadi lebih prominent
* Player Name dan Emblem lebih mudah dikenali

Prinsipnya:

> **Terlihat jelas, tetapi tidak mengganggu artwork Property.**

---

# 14. Set Color

Set **tidak mendapatkan warna ownership tambahan**.

Set tetap menggunakan identitas sistem Set sendiri.

Ownership tetap ditunjukkan melalui:

> **Ownership Frame + Player Color + Player Emblem + Player Name**

---

# 15. Crown

Crown tetap mempertahankan identitas visual Crown masing-masing.

Jika Crown memiliki owner atau ownership layer, Player Color hanya menjadi **secondary ownership layer** dan tidak menggantikan identitas Crown.

Dengan demikian:

```text
Crown Identity
      +
Player Ownership
```

tetap dapat dibedakan.

---

# 16. Final Visual Direction

Sistem ownership Relopoli sekarang:

```text
                 PROPERTY
                    │
          ┌─────────┴─────────┐
          │                   │
    Property Identity    Ownership Identity
          │                   │
     District Color       Player Color
     Property Artwork     Player Emblem
     Property Level       Player Name
                              │
                       Property Plaque
                              │
                       Ownership Frame
```

### Final Decision

> **Ownership menggunakan Option C — Ownership Frame, dengan style C2 — Property Plaque.**

Property tetap mempertahankan artwork dan identitas District-nya, sementara kepemilikan ditampilkan melalui **Property Plaque** yang berisi **Player Emblem + nama Roblox player**, dengan warna berdasarkan player.

**Player 1 = Red, Player 2 = Blue, Player 3 = Green, Player 4 = Yellow.**

Nama player yang tampil nantinya menggunakan **nama Roblox aktual dari pemilik Property**, bukan label "Player 1/2/3/4".