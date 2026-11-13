Iya. **Untuk Progress 13 — Player Screen, bagian utama yang kita inginkan sudah selesai kita brainstorm.** Kita bisa rekap sekarang dan menjadikannya baseline sebelum pindah ke sistem berikutnya.

# Progress 13 — Player Screen

## FINAL BRAINSTORM RECAP

**Status: 🔒 LOCKED**

---

## 1. Tujuan Player Screen

Player Screen adalah **UI kontrol pribadi Player** yang terpisah dari Board Gameplay UI.

Player Screen digunakan untuk:

* melihat identitas Player;
* melihat Balance Rels;
* mengakses News;
* mengakses Trade;
* mengakses Transaction;
* melihat Assets;
* membuka Settings;
* membuka Shop.

Player Screen **bukan bagian dari papan Relopoli**.

---

# 2. Struktur Besar

Player Screen terbagi menjadi dua bagian utama:

```text
PLAYER SCREEN
│
├── PLAYER IDENTITY
│
└── PLAYER ACTIONS
    │
    ├── Primary Actions
    │   ├── News
    │   ├── Trade
    │   ├── Transaction
    │   └── Assets
    │
    └── Utility
        ├── Settings
        └── Shop
```

Player Identity dan Player Actions **terpisah dan independen**.

---

# 3. Player Identity

### Posisi

**Pojok kiri bawah layar.**

### Isi

```text
┌──────────────────┐
│     [Avatar]     │
│   Player Name    │
│   250,000 Rels   │
└──────────────────┘
```

Menampilkan:

* Roblox Avatar Player
* Roblox Player Name
* Current Rels Balance

Nama menggunakan **nama Roblox Player**, konsisten dengan sistem Ownership.

### Visibility

Player Identity dapat:

> **Hide / Show secara independen.**

Ketika Hide:

* panel tidak langsung menghilang;
* panel collapse/slide menuju tepi layar;
* menyisakan kontrol kecil untuk membuka kembali.

Ketika Show:

* panel slide kembali keluar dari tepi layar.

**Hide Player Identity tidak memengaruhi Action Buttons.**

---

# 4. Player Action Buttons

Action Buttons berada di:

> **Sisi kanan layar.**

Style:

> **Icon + Label**

Kita tidak menggunakan icon-only.

---

## Primary Action

Empat tombol utama:

```text
📰 News
⇄ Trade
💰 Transaction
🏠 Assets
```

Keempatnya berada di dalam:

> **Action Dock**

---

# 5. Action Dock

Action Dock menggunakan:

> **Opsi B — Collapsible Action Dock**

Dalam keadaan tertutup, hanya ada:

```text
[ ☰ Menu ]
```

Ketika Menu ditekan:

```text
[ Shop ] [ Settings ] [ ✕ Menu ]
                              │
                              ▼
                       ┌───────────────┐
                       │ 📰 News       │
                       │ ⇄ Trade       │
                       │ 💰 Transaction│
                       │ 🏠 Assets     │
                       └───────────────┘
```

### Posisi

Action Dock muncul:

> **Tepat di bawah tombol Menu.**

### Animasi

Action Dock:

* muncul dengan **smooth flowing animation**;
* terasa seperti mengalir keluar dari tombol Menu;
* seluruh item muncul secara **bersamaan**;
* bukan cascade satu per satu.

Ini adalah:

> **Unified Flow**

Bukan:

```text
News
↓
Trade
↓
Transaction
↓
Assets
```

dengan delay panjang.

---

# 6. Menu Button

Menu berada di:

> **Pojok kanan atas.**

Urutan Utility Controls:

```text
[ Shop ] [ Settings ] [ Menu ]
```

Dari kiri ke kanan.

Ketika Action Dock tertutup:

```text
[ ☰ Menu ]
```

Ketika Action Dock terbuka:

```text
[ ✕ Menu ]
```

Icon berubah:

> `☰ → ✕`

Menu tetap berada di posisi yang sama.

Ketika Action Dock ditutup:

> Item mengalir kembali menuju Menu.

---

# 7. Settings

Settings **dipisahkan dari Action Dock**.

Posisinya:

> **Di sebelah kiri Menu.**

Jadi:

```text
[ Shop ] [ Settings ] [ Menu ]
```

Settings tidak dianggap sebagai Primary Gameplay Action.

---

# 8. Shop

Shop juga **dipisahkan dari Action Dock**.

Posisinya:

> **Di sebelah kiri Settings.**

Struktur final:

```text
┌──────────────────────────────────────────┐
│                 [Shop] [Settings] [Menu] │
└──────────────────────────────────────────┘
```

Shop adalah:

> **Toko khusus Robux.**

Ekonomi Shop tidak dicampurkan dengan Economy System Rels.

---

# 9. Kapan Player Screen Bisa Dibuka?

Player Screen:

> **Boleh dibuka kapan saja.**

Tetapi Player tidak dapat menggunakan Player Screen ketika sedang berada dalam proses otomatis seperti:

* Roll
* Movement

Aturan availability lebih spesifik akan mengikuti Game State.

---

# 10. Feature Panel

Ketika Player memilih salah satu fitur seperti News atau Assets, fitur tersebut membuka:

> **Feature Panel**

Feature Panel:

* berada di **tengah layar**;
* bukan di sisi kanan;
* bukan full-screen;
* hanya satu Feature Panel yang boleh aktif;
* memiliki tombol `[ X ]`;
* `X` hanya menutup panel.

Konsep:

```text
┌───────────────────────────────────────────────┐
│                         [Shop][Settings][Menu]│
│                                               │
│             ┌───────────────────┐             │
│             │                   │             │
│             │  FEATURE PANEL    │             │
│             │                   │             │
│             └───────────────────┘             │
│                                               │
│ [ PLAYER IDENTITY ]                           │
└───────────────────────────────────────────────┘
```

---

# 11. Board ketika Feature Panel terbuka

Board:

> **Tetap terlihat di belakang Feature Panel.**

Tetapi diberikan:

> **Blur ringan**

Tujuannya untuk mengarahkan fokus ke Feature Panel tanpa membuat Player kehilangan konteks bahwa mereka masih berada di Board.

---

# 12. Hanya Satu Feature Panel

Kita LOCK:

> **Hanya satu Feature Panel aktif dalam satu waktu.**

Tidak boleh:

```text
News
+
Assets
+
Trade
```

secara bersamaan.

Jika Player berpindah fitur:

```text
Assets
 ↓
Assets CLOSE
 ↓
News OPEN
```

Ini juga membantu menjaga UI tetap ringan dan mengurangi beban yang tidak diperlukan.

---

# 13. Menu Tetap Bisa Digunakan

Ketika Feature Panel terbuka:

> **Menu tetap dapat dibuka.**

Contoh:

```text
Assets Panel terbuka
        ↓
Player tekan Menu
        ↓
Action Dock muncul
        ↓
Player pilih News
        ↓
Assets ditutup
        ↓
News dibuka
```

Tetap hanya ada satu Feature Panel aktif.

---

# 14. Action Dock ketika Feature Panel dibuka

Saat Player memilih sebuah Action:

```text
Menu
 ↓
Assets
 ↓
Action Dock otomatis collapse
 ↓
Assets Panel muncul
```

Tetapi:

> **Menu tetap tersedia.**

Jadi Player tidak kehilangan navigasi.

---

# 15. Feature Panel Animation

Kita membedakan dua jenis animasi:

### Action Dock

Lebih expressive:

> **Smooth → Flowing → From Menu**

### Feature Panel

Lebih cepat dan fungsional:

> **Fast → Smooth → Settle**

Animasi tidak boleh menjadi gameplay delay.

> **Animation = feedback, bukan gameplay delay.**

---

# 16. News

News merupakan Primary Action.

```text
[ 📰 News ]
```

Jika Player memiliki Stored News:

> Membuka Stored News Panel.

Jika Player **tidak memiliki Stored News**:

```text
┌────────────────────────┐
│ NEWS              [X]  │
│                        │
│    No Stored News      │
│                        │
└────────────────────────┘
```

News **tidak disabled** hanya karena inventory kosong.

---

# 17. Trade

```text
[ ⇄ Trade ]
```

Trade:

> **Disabled apabila Player tidak memiliki Property/Crown yang bisa digunakan untuk Trade.**

Trade sendiri akan menjadi sistem terpisah yang kita brainstorm setelah Player Screen.

Konsepnya:

> **Property/Crown ↔ Property/Crown**

dengan persetujuan kedua pihak.

---

# 18. Transaction

```text
[ 💰 Transaction ]
```

Transaction:

> **Disabled apabila Player tidak memiliki aset yang dapat dijual.**

Transaction merupakan sistem terpisah.

Konsepnya:

> **Rels ↔ Property/Crown**

dengan persetujuan kedua pihak.

---

# 19. Assets

```text
[ 🏠 Assets ]
```

Assets adalah **information hub untuk aset Player**.

Kita memilih:

> **Level 2 — Asset Detail**

Jadi Assets dibuat lebih clean dan tidak menggunakan terlalu banyak lapisan UI.

---

## Property / Crown

Assets menggunakan dua tab:

```text
[ PROPERTIES ] [ CROWNS ]
```

### Properties

Menampilkan Property yang dimiliki Player.

### Crowns

Menampilkan Crown yang dimiliki Player.

---

# 20. Asset Detail

Ketika memilih sebuah Property, Player dapat melihat:

* Property Artwork
* Property Name
* District
* Level
* Property Value
* Rent
* Set Status
* Status / Modifier khusus
* Ownership

Kemudian tersedia:

```text
[ View on Board ]
[ Trade ]
[ Transaction ]
```

---

# 21. View on Board

`View on Board`:

> Menunjukkan lokasi Property di Board.

Tidak:

* memindahkan Player;
* menjalankan Movement;
* mengubah posisi karakter.

Fungsinya hanya membantu Player menemukan asetnya di papan.

---

# 22. Assets → Trade

Jika Player memilih:

```text
Property Detail
      ↓
[ Trade ]
```

maka:

> Membuka **Trade System** dengan aset tersebut sebagai aset yang dipilih.

Assets sendiri tidak menjalankan proses Trade.

---

# 23. Assets → Transaction

Jika Player memilih:

```text
Property Detail
      ↓
[ Transaction ]
```

maka:

> Membuka **Transaction System** dengan aset tersebut sebagai aset yang dipilih.

Assets sendiri tidak menjalankan proses Transaction.

---

# 24. Prinsip Arsitektur Final

Ini menurutku bagian paling penting dari Progress 13:

```text
                    PLAYER SCREEN
                         │
        ┌────────────────┴────────────────┐
        │                                 │
 PLAYER IDENTITY                    PLAYER ACTIONS
        │                                 │
    Avatar/Name/Rels              ┌───────┴────────┐
                                  │                │
                            Primary Actions      Utility
                                  │                │
                         ┌────────┼────────┐   ┌───┴────┐
                         │        │        │   │        │
                       News     Trade   Transaction Settings
                         │        │        │        │
                         │        │        │       Shop
                         │        │        │
                         └────────┼────────┘
                                  │
                                Assets
                                  │
                           Asset Information
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
              View on Board     Trade      Transaction
```

Dengan pembagian ini:

> **Player Screen = akses & navigasi**

> **Assets = informasi aset**

> **Trade = pertukaran aset**

> **Transaction = pembelian aset**

> **Board UI = gameplay interaction**

Masing-masing sistem memiliki tanggung jawab yang jelas dan tidak mengambil alih sistem lain.

---

# 🔒 STATUS PROGRESS 13

**PLAYER SCREEN — LOCKED**

| Komponen               | Status    |
| ---------------------- | --------- |
| Player Identity        | 🔒 LOCKED |
| Avatar / Name / Rels   | 🔒 LOCKED |
| Identity Hide/Show     | 🔒 LOCKED |
| Action Area            | 🔒 LOCKED |
| Action Dock            | 🔒 LOCKED |
| Menu                   | 🔒 LOCKED |
| News Button            | 🔒 LOCKED |
| Trade Button           | 🔒 LOCKED |
| Transaction Button     | 🔒 LOCKED |
| Assets Button          | 🔒 LOCKED |
| Settings               | 🔒 LOCKED |
| Shop                   | 🔒 LOCKED |
| Feature Panel          | 🔒 LOCKED |
| Feature Panel Position | 🔒 LOCKED |
| One Panel at a Time    | 🔒 LOCKED |
| Board Blur             | 🔒 LOCKED |
| Feature Panel Close    | 🔒 LOCKED |
| Assets Structure       | 🔒 LOCKED |
| Property/Crown Tabs    | 🔒 LOCKED |
| Asset Detail           | 🔒 LOCKED |
| View on Board          | 🔒 LOCKED |
| Assets → Trade         | 🔒 LOCKED |
| Assets → Transaction   | 🔒 LOCKED |

### Progress 13 selesai.

Yang **belum** kita detailkan bukan lagi Player Screen-nya, melainkan sistem yang memang sengaja kita pisahkan:

**Progress berikutnya: Trade System → Transaction System.**

Dan karena aturan dasar Trade dan Transaction tadi sudah kita sepakati, kita bisa langsung masuk brainstorming **Trade System** tanpa perlu mengubah struktur Player Screen lagi.