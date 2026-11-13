Siap. Berikut **rekap final brainstorming Assets Panel** dalam format Markdown, dengan keputusan yang sudah kita lock sejauh ini.

# Relopoli — Progress 14: Assets Panel

## Status

**Status: LOCKED — Brainstorming & UI Specification**

Assets Panel merupakan bagian dari **Player Screen** dan berfungsi sebagai **Information Hub** untuk melihat aset yang dimiliki Player.

Assets Panel bukan tempat utama untuk menjalankan proses Trade atau Transaction. Panel hanya menyediakan informasi aset dan menjadi entry point menuju sistem tersebut.

---

# 1. Konsep Utama

Assets Panel menggunakan struktur:

```text
Player Screen
    ↓
Assets
    ↓
Assets Panel
    ├── Properties
    └── Crowns
```

Assets Panel memiliki dua tab:

```text
[ PROPERTIES ] [ CROWNS ]
```

### Prinsip utama

* Assets = **Information Hub**
* Menggunakan **Asset Detail** sebagai level informasi.
* Property dan Crown memiliki struktur informasi yang berbeda sesuai karakter aset.
* Trade dan Transaction bukan diproses langsung di Assets Panel.
* Assets Panel hanya menjadi entry point menuju sistem Trade/Transaction.
* UI menggunakan struktur yang clean dan information-oriented.

---

# 2. Struktur Assets Panel

Assets Panel menggunakan layout:

```text
┌────────────────────────────────────────────────────────┐
│ ASSETS                                             X  │
│                                                        │
│ [ PROPERTIES ]             [ CROWNS ]                 │
├───────────────────────┬────────────────────────────────┤
│                       │                                │
│ Asset List            │ Asset Detail                  │
│                       │                                │
│                       │                                │
└───────────────────────┴────────────────────────────────┘
```

## Layout

Menggunakan **List + Detail secara bersamaan**.

### Sisi kiri

**Asset List**

* Vertical List
* Berisi daftar aset yang dimiliki Player.

### Sisi kanan

**Asset Detail**

* Menampilkan detail aset yang sedang dipilih.

Player tidak perlu membuka halaman detail baru.

---

# 3. Asset List

Asset List menggunakan:

**Vertical List**

Bukan grid.

Alasan desain:

* Player dapat memiliki banyak Property.
* Maksimal terdapat 28 Property.
* Vertical List lebih cocok untuk management/information interface.
* Memungkinkan Player melakukan scanning aset dengan cepat.

---

# 4. Property Asset Card

## Ukuran

Menggunakan:

**Medium Card**

Bukan Compact dan bukan Large.

## Layout

Card menggunakan layout horizontal:

```text
┌──────────────────────────────────────────┐
│▌                                         │
│▌ ┌─────────┐  Maple Row           [Lv.2]│
│▌ │         │  District 1                │
│▌ │ ARTWORK │  Set #1                    │
│▌ │         │                             │
│▌ └─────────┘                        ◆   │
└──────────────────────────────────────────┘
```

## Informasi Property Card

Property Card menampilkan:

* Property Artwork
* Property Name
* District
* Set
* Level

Tidak menampilkan:

* Property Value
* Rent
* Upgrade Cost

Informasi tersebut berada di Property Detail.

---

# 5. Property Ownership Visual

Property Card tidak menggunakan Ownership Plaque C2 penuh.

Sebagai gantinya menggunakan:

**Ownership Accent**

Contoh:

```text
▌
```

Accent menggunakan warna Player.

Ownership tetap menggunakan sistem warna Player yang sudah ditentukan.

Nama Player menggunakan **nama Roblox player**, bukan "Player 1", "Player 2", dan sebagainya.

---

# 6. Property Level

Property Card menggunakan:

**Level Badge**

Contoh:

```text
[Lv.2]
```

Level yang ditampilkan adalah level aktual Property:

* Lv.1
* Lv.2
* Lv.3
* Lv.4
* Lv.5

---

# 7. Property Modifier Indicator

Modifier tidak ditulis panjang di Property Card.

Jika Property memiliki modifier/status khusus, card dapat menampilkan **icon kecil**.

Contoh:

```text
◆
```

Detail lengkap modifier baru dilihat pada Property Detail.

Jika tidak ada modifier, icon tidak perlu ditampilkan.

---

# 8. Property Card Interaction

## Normal

Card berada pada kondisi normal.

## Hover

Hover memberikan feedback ringan:

* subtle highlight
* sedikit elevation

Tidak menggunakan efek besar.

## Selected

Property yang dipilih mendapatkan:

* outline/highlight lebih kuat
* Ownership Accent tetap terlihat
* sedikit elevation/glow
* tidak mengubah artwork secara drastis

Tujuannya agar Player langsung mengetahui Property mana yang sedang ditampilkan pada Detail Panel.

---

# 9. Property Detail Panel

Property Detail menggunakan:

**Information Stack**

Contoh struktur:

```text
┌─────────────────────────────────────┐
│▌ Maple Row                       [Lv.2]
│▌ District 1                         │
│                                     │
│          [ L2 ARTWORK ]             │
│                                     │
│ Property Value     75,000 Rels      │
│ Rent                7,500 Rels      │
│                                     │
│ SET #1                         2 / 3│
│ ✓ Willow Café                       │
│ ✓ Sunny Market                      │
│ ○ Bloom Gardens                     │
│                                     │
│ Status              Normal          │
│                                     │
│ Ownership                           │
│ ▌ [PlayerName]                      │
│                                     │
│ ┌───────────────────────────────┐   │
│ │       View on Board           │   │
│ └───────────────────────────────┘   │
│                                     │
│       [ Trade ] [ Transaction ]     │
└─────────────────────────────────────┘
```

---

# 10. Property Detail Header

Header menggunakan:

**Ownership Accent + Property Name + Level**

Contoh:

```text
▌ Maple Row                       [Lv.2]
▌ District 1
```

Ownership Accent tetap menggunakan warna Player.

---

# 11. Property Detail Artwork

Artwork menggunakan:

**Visual Property aktual sesuai Level**

Contoh:

```text
L1 → L1 Artwork
L2 → L2 Artwork
L3 → L3 Artwork
L4 → L4 Artwork
L5 → L5 Artwork
```

Artwork harus merepresentasikan Property yang benar-benar ada di Board.

Tidak menggunakan artwork generik.

Dengan demikian:

**Board → Upgrade UI → Assets Panel**

menggunakan visual Property yang konsisten.

---

# 12. Property Value & Rent

Property Value dan Rent menggunakan:

**Simple Information Rows**

Contoh:

```text
Property Value        75,000 Rels
Rent                   7,500 Rels
```

Tidak menggunakan:

* Information Cards
* Value Badge
* angka besar sebagai centerpiece

Tujuannya menjaga Information Stack tetap clean.

---

# 13. Property Set Status

Set menggunakan:

**Progress + daftar seluruh anggota Set**

Contoh:

```text
SET #1                         2 / 3

✓ Willow Café
✓ Sunny Market
○ Bloom Gardens
```

Aturan:

* `✓` = Property dimiliki Player.
* `○` = Property merupakan anggota Set tetapi belum dimiliki.
* Seluruh anggota Set ditampilkan.
* Progress ditampilkan sebagai `X / 3`.
* Tidak menggunakan progress bar.

---

# 14. Property Status / Modifier

Status menggunakan:

**Simple Information Row**

Contoh normal:

```text
Status              Normal
```

Jika terdapat modifier:

```text
Status              Landing Start Upgrade
```

Tidak menggunakan badge tambahan atau deskripsi panjang pada Property Detail.

---

# 15. Property Ownership

Ownership menggunakan:

**Ownership Accent**

Format:

```text
Ownership

▌ [PlayerName]
```

Aturan:

* Menggunakan Roblox player name.
* Warna accent mengikuti Player.
* Tidak menggunakan Ownership Plaque C2 penuh.
* Tetap konsisten dengan Property Card.

---

# 16. Property Action Buttons

Hierarchy:

### Primary Action

```text
┌─────────────────────────────┐
│       View on Board         │
└─────────────────────────────┘
```

### Secondary Actions

```text
[ Trade ] [ Transaction ]
```

View on Board mendapatkan visual hierarchy paling tinggi.

Trade dan Transaction menjadi entry point menuju sistem masing-masing.

---

# 17. Disabled Action

Jika Trade atau Transaction tidak tersedia:

* Button tetap terlihat.
* Button menjadi disabled.
* Button tidak menghilang.
* Button tidak dapat ditekan.
* Hover/tap memberikan alasan singkat.

Contoh:

```text
[ Trade ]  ← Disabled

Trade unavailable
```

atau:

```text
[ Transaction ]  ← Disabled

No sellable assets
```

Feedback dibuat singkat dan tidak berupa tooltip besar.

---

# 18. View on Board

View on Board tidak menyebabkan Player bergerak.

Fungsinya hanya untuk membawa perhatian Player ke lokasi aset pada Board.

Setelah ditekan:

```text
Assets Panel
     ↓
View on Board
     ↓
Assets Panel minimize
     ↓
Board menjadi fokus
```

Assets Panel menggunakan:

**Minimize Button**

Player dapat menekan tombol kecil tersebut untuk mengembalikan Assets Panel.

---

# 19. Property Selection Behavior

Ketika Player memilih Property lain:

```text
Property A
    ↓
Player memilih Property B
    ↓
Detail langsung berubah menjadi Property B
```

Tidak menggunakan animasi besar.

Transisi dibuat ringan atau langsung.

Tujuannya menghindari beban performa/lag yang tidak diperlukan.

---

# 20. Assets Panel Close

Tombol:

```text
X
```

berfungsi untuk:

**Menutup seluruh Assets Panel.**

`X` bukan tombol Back dari Detail ke List.

Karena List dan Detail berada pada panel yang sama.

---

# 21. Crown Asset Card

Crown menggunakan:

**Medium Premium Card**

Crown dibuat sedikit lebih premium daripada Property, tetapi tetap menggunakan bahasa visual Assets Panel.

Contoh:

```text
┌──────────────────────────────────────┐
│                                      │
│ [ CROWN ART ]   Grand Crown          │
│                 District 1           │
│                 Crown Value          │
│                 150,000 Rels         │
│                                      │
└──────────────────────────────────────┘
```

Crown hanya memiliki 4 aset, sehingga artwork dapat dibuat sedikit lebih menonjol.

---

# 22. Crown Card Information

Crown Card menampilkan:

* Crown Artwork
* Crown Name
* District
* Crown Value

Tidak menampilkan:

* Level
* Rent
* Set
* Status/Modifier

---

# 23. Crown Value

Crown Value menggunakan:

**Simple Information Row**

Contoh:

```text
Crown Value          150,000 Rels
```

Tidak menggunakan badge atau visual value yang berlebihan.

---

# 24. Crown Ownership

Crown menggunakan sistem Ownership yang sama dengan Property:

```text
Ownership

▌ [PlayerName]
```

Menggunakan:

* Roblox player name
* Player-color Ownership Accent
* Tidak menggunakan Ownership Plaque khusus Crown.

---

# 25. Crown Status pada Card

Crown Card **tidak menampilkan Status/Modifier**.

Card tetap clean.

Status/Modifier hanya ditampilkan ketika Crown dipilih dan Crown Detail dibuka.

---

# 26. Crown Selected State

Crown memiliki treatment selected yang lebih premium dibanding Property.

Ketika selected:

* Outline lebih kuat
* Subtle glow
* Artwork sedikit lebih emphasized
* Ownership Accent tetap terlihat
* Tidak menggunakan animasi besar

Hover tetap menggunakan feedback ringan.

---

# 27. Crown Detail Panel

Crown Detail juga menggunakan:

**Information Stack**

Contoh:

```text
┌─────────────────────────────────────┐
│▌ Grand Crown                      X │
│▌ District 1                         │
│                                     │
│          [ CROWN ART ]              │
│                                     │
│ Crown Value       150,000 Rels      │
│                                     │
│ Status             Normal           │
│                                     │
│ Ownership                           │
│ ▌ [PlayerName]                      │
│                                     │
│ ┌───────────────────────────────┐   │
│ │       View on Board           │   │
│ └───────────────────────────────┘   │
│                                     │
│       [ Trade ] [ Transaction ]     │
└─────────────────────────────────────┘
```

---

# 28. Crown Detail Header

Header menggunakan:

```text
▌ Grand Crown
▌ District 1
```

Ownership Accent tetap terlihat.

---

# 29. Crown Detail Artwork

Menggunakan **Crown Artwork yang sama dengan Board**.

Namun framing/crop dapat disesuaikan untuk Assets Panel.

Jadi:

* Tidak membuat artwork kedua.
* Asset dasarnya sama.
* Presentation pada Assets Panel dapat dibuat lebih premium.

---

# 30. Crown Status / Modifier

Menggunakan **Dynamic Status Section**.

### Normal

```text
Status              Normal
```

### Special Modifier

```text
STATUS

Special Modifier

[Effect / information]
```

Section hanya berkembang ketika memang diperlukan.

---

# 31. Crown Actions

Crown menggunakan struktur action yang sama dengan Property:

```text
┌─────────────────────────────┐
│       View on Board         │
└─────────────────────────────┘

       [ Trade ] [ Transaction ]
```

Status button mengikuti validitas Game Rules.

---

# 32. Crown Economy — Trade & Transaction

Crown:

* **Bisa di-Trade**
* **Bisa di-Transaction**

Crown memiliki aturan harga:

```text
Crown Price = Crown Value × 2.5
```

Contoh:

```text
Crown Value     150,000 Rels
× 2.5
────────────────────────
Transaction Price 375,000 Rels
```

Namun:

> **Crown Price tidak ditampilkan di Assets Panel.**

Assets Panel hanya menampilkan:

```text
Crown Value
```

Harga transaksi baru muncul setelah Player menekan:

```text
[ Transaction ]
```

Trade/Transaction System bertanggung jawab menampilkan dan menggunakan harga tersebut.

---

# 33. Empty State

Jika Player belum memiliki Property:

```text
No Properties Owned
```

Jika Player belum memiliki Crown:

```text
No Crowns Owned
```

Empty State menggunakan **Text Only**.

Tidak ada tombol tambahan seperti:

* Buy Property
* Find Property
* Acquire Crown

Assets Panel tetap menjadi Information Hub.

---

# 34. Scroll Behavior

Assets Panel menggunakan:

**Fixed Header + Fixed Tabs + Scrollable Content**

```text
┌───────────────────────────────┐
│ ASSETS                    X   │ ← FIXED
│ [PROPERTIES] [CROWNS]        │ ← FIXED
├───────────────────────────────┤
│                               │
│       CONTENT AREA ↕          │
│                               │
└───────────────────────────────┘
```

Header dan tab tidak ikut bergerak ketika Player melakukan scroll.

---

# 35. Asset List & Detail Scrolling

List dan Detail memiliki area content masing-masing.

Dengan demikian:

```text
┌────────────────┬────────────────────┐
│ Asset List  ↕  │ Detail          ↕  │
│                │                    │
│ Property A     │ Property info      │
│ Property B     │                    │
│ Property C     │ Set                │
│ Property D     │                    │
│ ...            │ Actions            │
└────────────────┴────────────────────┘
```

Scroll pada Asset List tidak menggeser Detail.

Scroll pada Detail tidak menggeser Asset List.

---

# 36. Crown Scrolling

Crown List hanya menggunakan scrolling jika memang diperlukan.

Jika seluruh Crown dapat terlihat:

* Tidak perlu scrollbar.

Jika konten melebihi area:

* Scroll tersedia secara otomatis.

Scrolling bersifat **content-driven**.

---

# 37. Default Tab

Ketika Assets Panel pertama kali dibuka:

```text
[ PROPERTIES ] [ CROWNS ]
       ↑
     DEFAULT
```

**PROPERTIES** menjadi default tab.

Assets tidak otomatis pindah ke Crown meskipun Property kosong.

---

# 38. Auto-Select Asset

Jika Player memiliki aset:

```text
Open Assets
    ↓
Properties
    ↓
Property pertama otomatis selected
    ↓
Property Detail langsung tampil
```

Tidak perlu klik tambahan.

Behavior yang sama berlaku untuk Crown:

```text
Crown Tab
    ↓
Crown pertama otomatis selected
    ↓
Crown Detail tampil
```

---

# 39. Selection Memory

Selection terakhir diingat **selama Assets Panel masih terbuka**.

Contoh:

```text
Properties
→ Maple Row selected

Crown
→ Grand Crown selected

Properties
→ Maple Row masih selected
```

Ketika Assets Panel ditutup dan dibuka kembali, selection dapat kembali ke default behavior.

---

# 40. Keseluruhan Flow

```text
PLAYER SCREEN
     ↓
ASSETS
     ↓
ASSETS PANEL
     │
     ├───────────────┐
     ↓               ↓
PROPERTIES         CROWNS
     │               │
     ↓               ↓
Asset List         Asset List
     │               │
     ↓               ↓
Select Asset       Select Asset
     │               │
     ↓               ↓
Property Detail    Crown Detail
     │               │
     ├───────┬───────┤
     ↓       ↓       ↓
View      Trade   Transaction
Board
```

---

# 41. Prinsip UX Assets Panel

Assets Panel mengikuti prinsip:

1. **Information First**
2. **Clean Information Stack**
3. **List + Detail**
4. **No unnecessary animation**
5. **Disabled actions remain visible**
6. **Explain why an action is unavailable**
7. **Assets represent the actual Board state**
8. **Ownership uses Player identity**
9. **Trade/Transaction remain separate systems**
10. **Assets Panel does not invent new Game Rules**

---

# Status Akhir Progress 14

## LOCKED

* Assets Panel concept
* Properties/Crowns tabs
* Vertical Asset List
* Property Card
* Property Detail
* Crown Card
* Crown Detail
* Ownership visualization
* Level visualization
* Set information
* Status/Modifier behavior
* Action hierarchy
* View on Board behavior
* Empty State
* Scroll behavior
* Default tab
* Auto-selection
* Selection memory
* Crown Trade
* Crown Transaction
* Crown `Value × 2.5` transaction pricing
* Crown Price visibility rule

## Belum dibahas secara mendalam

* Detail behavior **Assets → View on Board**
* Detail integration **Assets → Trade**
* Detail integration **Assets → Transaction**
* Final animation specification Assets Panel
* Final responsive/layout constraints
* Edge cases ketika aset berubah/dijual/ditrade saat Assets Panel sedang terbuka
* Final complete flow & validation

Siap. Ini rekap final **Assets Panel — Trade, Transaction & View on Board** dalam format Markdown yang bisa langsung kamu masukkan ke dokumentasi Relopoli.

# Progres #14 — Assets Panel: Trade, Transaction & View on Board

## 1. Prinsip Utama Assets Panel

**Assets = Information Hub**

Assets Panel bertugas untuk menampilkan dan mengelola informasi mengenai asset milik Player.

Assets Panel **tidak membuat sistem Trade atau Transaction baru**.

Jika Player memilih:

```text
[ Trade ]
```

maka langsung dipindahkan ke **Trade System** yang sudah ada.

Jika Player memilih:

```text
[ Transaction ]
```

maka langsung dipindahkan ke **Transaction System** yang sudah ada.

Dengan demikian:

```text
Assets Panel
     │
     ├── View on Board
     │
     ├── Trade ──────────→ Trade System
     │
     └── Transaction ────→ Transaction System
```

Assets hanya menjadi **entry point** menuju sistem yang sudah ada.

---

# 2. View on Board

## Tujuan

Fungsi **View on Board** digunakan untuk membantu Player menemukan lokasi Property atau Crown yang sedang dilihat pada Board.

View on Board **tidak melakukan movement** dan **tidak memindahkan Camera**.

---

## 3. Mekanisme View on Board

Saat Player menekan:

```text
[ View on Board ]
```

maka:

1. Assets Panel diminimize.
2. Camera tetap pada posisi Player saat ini.
3. Target Property/Crown diberikan **Outline**.
4. Muncul **Floating 3D Arrow** di atas target tile.
5. Arrow menunjuk langsung ke tile target.
6. Outline dan Arrow aktif secara bersamaan.
7. Keduanya bertahan selama **Extended Fixed Duration**.
8. Setelah durasi selesai:

   * Outline menghilang.
   * Arrow menghilang.
9. Assets Panel tetap dalam kondisi minimize.

---

# 4. Visual View on Board

Target akan terlihat seperti:

```text
              ▼
             ↕
       ┌─────────────┐
       │   PROPERTY  │
       │     TILE    │
       └─────────────┘
       ╚═════════════╝
            Outline
```

### Floating 3D Arrow

Arrow:

* Berbentuk **3D Floating Arrow**
* Mengambang sedikit di atas tile
* Menunjuk ke tile target
* Bergerak naik-turun dengan sangat halus
* Tidak berputar secara agresif
* Tidak menutupi artwork Property/Crown
* Tidak menggunakan glow berlebihan
* Bersifat sementara

---

# 5. Shared Arrow System

Floating 3D Arrow untuk **View on Board** menggunakan sistem visual yang sama dengan Arrow yang digunakan pada **Movement**.

Tidak dibuat dua jenis Arrow yang berbeda.

### Movement

Arrow menunjukkan:

```text
Player
  │
  │ Movement
  ▼
Floating 3D Arrow
  │
  ▼
Destination Tile
```

### View on Board

Arrow menunjukkan:

```text
Assets
  │
  │ View on Board
  ▼
Floating 3D Arrow
  │
  ▼
Property / Crown Tile
```

---

# 6. Perbedaan Fungsi Arrow

| System            | Fungsi Arrow                                          |
| ----------------- | ----------------------------------------------------- |
| **Movement**      | Menunjukkan destination tile yang akan dituju Player  |
| **View on Board** | Menunjukkan lokasi Property/Crown yang sedang dilihat |

Visual dan behaviour Arrow tetap sama.

Yang berbeda hanya **target dan konteks penggunaannya**.

---

# 7. Prinsip Konsistensi Arrow

Semua penggunaan Floating 3D Arrow mengikuti prinsip yang sama:

* Floating di atas tile
* Menunjuk ke tile
* Gerakan naik-turun sangat halus
* Tidak agresif
* Tidak mengganggu artwork
* Tidak menjadi marker permanen

Dengan demikian, Player akan mengenali Floating 3D Arrow sebagai:

> **indikator lokasi/destination pada Board.**

---

# 8. View on Board vs Movement

| Aspek             | Movement               | View on Board  |
| ----------------- | ---------------------- | -------------- |
| Floating 3D Arrow | ✅                      | ✅              |
| Smooth up/down    | ✅                      | ✅              |
| Menunjuk tile     | ✅                      | ✅              |
| Camera bergerak   | Sesuai sistem Movement | ❌              |
| Player bergerak   | ✅                      | ❌              |
| Outline           | ❌                      | ✅              |
| Temporary         | ✅                      | ✅              |
| Target            | Destination            | Property/Crown |

---

# 9. Assets → Trade

Property/Crown Detail Panel memiliki:

```text
[ View on Board ]
[ Trade ] [ Transaction ]
```

Saat:

```text
[ Trade ]
```

ditekan:

**Assets Panel → Trade System**

Tidak ada Trade UI khusus yang dibuat di dalam Assets Panel.

Trade System menangani seluruh proses Trade.

---

# 10. Assets → Transaction

Saat:

```text
[ Transaction ]
```

ditekan:

**Assets Panel → Transaction System**

Tidak ada Transaction UI khusus yang dibuat di dalam Assets Panel.

Transaction System menangani seluruh proses Transaction.

---

# 11. Final Flow

### View on Board

```text
Assets Panel
     │
     ▼
Property / Crown Detail
     │
     ▼
[ View on Board ]
     │
     ▼
Assets Minimize
     │
     ▼
Floating 3D Arrow + Outline
     │
     ▼
Target Tile ditunjukkan
     │
     ▼
Extended Fixed Duration
     │
     ▼
Arrow + Outline Hilang
```

### Trade

```text
Assets Panel
     │
     ▼
Property / Crown Detail
     │
     ▼
[ Trade ]
     │
     ▼
Trade System
```

### Transaction

```text
Assets Panel
     │
     ▼
Property / Crown Detail
     │
     ▼
[ Transaction ]
     │
     ▼
Transaction System
```

---

# 12. Locked Decisions

* 🔒 Assets tidak membuat sistem Trade baru.
* 🔒 Assets tidak membuat sistem Transaction baru.
* 🔒 Trade langsung membuka **Trade System**.
* 🔒 Transaction langsung membuka **Transaction System**.
* 🔒 View on Board tidak memindahkan Camera.
* 🔒 View on Board tidak melakukan movement.
* 🔒 View on Board menggunakan **Outline**.
* 🔒 View on Board menggunakan **Floating 3D Arrow**.
* 🔒 Floating 3D Arrow menggunakan sistem visual yang sama dengan Movement.
* 🔒 Arrow memiliki gerakan naik-turun yang sangat halus.
* 🔒 Outline + Arrow menggunakan **Extended Fixed Duration**.
* 🔒 Setelah durasi selesai, Outline dan Arrow menghilang.
* 🔒 Assets Panel minimize ketika View on Board digunakan.
* 🔒 Floating 3D Arrow menjadi **shared visual system** untuk indikator lokasi/destination di Board.