Siap. Berikut **rekap final Progress 15 — Trade System** dalam format Markdown, dengan seluruh keputusan yang sudah kita lock.

# Relopoli — Progress 15: Trade System

## 1. Status

**Status:** 🔒 FINAL / LOCKED

Trade System memungkinkan Player melakukan pertukaran aset secara langsung melalui Player Screen.

Trade bersifat **asynchronous** dan tidak terikat dengan Turn. Proposal dapat berjalan selama Player masih online dan belum mencapai kondisi pembatalan/expired.

---

# 2. Trade Initiation

Semua Player dapat mengajukan Trade.

Trade **tidak terbatas pada Player yang sedang mendapatkan Turn**.

Player juga tetap dapat mengirim Trade kepada Player lain meskipun sudah memiliki Trade Proposal aktif.

Contoh:

```text
Player A
├── Trade → Player B [Pending]
├── Trade → Player C [Pending]
└── Trade → Player D [Pending]
```

Tidak ada batas jumlah **Outgoing Trade Proposal**.

---

# 3. Trade Target

Saat Player memilih:

```text
Player Screen
↓
Trade
```

Sistem menampilkan seluruh Player lain di dalam game.

Player sendiri tidak dapat dipilih sebagai target.

### Player dengan aset Tradeable

* Ditampilkan.
* Dapat dipilih.
* Dapat menjadi target Trade.

### Player tanpa aset Tradeable

* Tetap ditampilkan.
* Berstatus **Disabled**.
* Tidak dapat dipilih.

Sistem tidak menghilangkan Player tanpa aset dari daftar.

Contoh:

```text
TRADE WITH

[ Player 2 ]
Available

[ Player 3 ]
No Tradeable Asset
Disabled

[ Player 4 ]
Available
```

---

# 4. Tradeable Assets

Aset yang dapat diperdagangkan:

* **Property**
* **Crown**

Aset yang tidak dapat diperdagangkan:

* **Rels**
* News
* Item/asset lain di luar Property dan Crown

## Tidak Ada Trade Restriction

Semua Property dan Crown yang dimiliki Player dapat diperdagangkan **tanpa pengecualian**.

Tidak peduli:

* Property Level L1
* Property Level L2
* Property Level L3
* Property Level L4
* Property Level L5
* Property yang merupakan bagian dari Set
* Property dengan modifier/status tertentu
* Crown apa pun

Prinsip:

> **Ownership = Tradeable**

Tidak ada sistem **Trade Locked Asset**.

---

# 5. Asset Limit

Setiap pihak dapat memasukkan:

* **Minimum:** 1 aset
* **Maximum:** 3 aset

Jumlah aset kedua pihak **tidak harus sama**.

Contoh valid:

```text
Player A Offers
└── Crown #1

Player B Offers
├── Property L5
├── Property L4
└── Property L4
```

Ini merupakan Trade **1 ↔ 3** dan valid.

Kombinasi yang diperbolehkan:

```text
1 ↔ 1
1 ↔ 2
1 ↔ 3

2 ↔ 1
2 ↔ 2
2 ↔ 3

3 ↔ 1
3 ↔ 2
3 ↔ 3
```

Tidak diperbolehkan:

```text
0 ↔ 1
1 ↔ 0
0 ↔ 0
```

Trade bukan mekanisme gifting.

---

# 6. Trade Proposal

Player yang menginisiasi Trade disebut **Initiator**.

Initiator memiliki kendali penuh untuk menyusun proposal awal.

Initiator menentukan:

* Aset yang dia tawarkan.
* Aset yang diminta dari pihak lain.

Contoh:

```text
TRADE PROPOSAL

PLAYER A OFFERS
├── Crown #1
└── Property L3

PLAYER B OFFERS
├── Property L5
├── Property L4
└── Property L4
```

## Send Offer

Tidak ada Confirmation Panel tambahan sebelum proposal dikirim.

Alurnya:

```text
Susun Proposal
↓
[ SEND OFFER ]
↓
Proposal langsung dikirim
```

Tombol **Send Offer** dianggap sebagai konfirmasi dari Initiator.

---

# 7. Trade Proposal Expiration

Setiap Trade Proposal memiliki masa berlaku:

> **30 menit sejak proposal dikirim.**

Jika tidak ada penyelesaian dalam waktu 30 menit:

```text
Trade Proposal
↓
30 Menit
↓
Expired
↓
Tidak ada transfer aset
```

Proposal yang sudah Expired tidak dapat di-Accept.

---

# 8. Recipient Response

Player penerima proposal memiliki tiga pilihan:

```text
[ ACCEPT ]
[ DECLINE ]
[ NEGOSIASI ]
```

---

## 8.1 Accept

Jika Recipient memilih **Accept**:

```text
Accept
↓
Final Validation
↓
Valid?
↓
Transfer Asset
↓
Trade Complete
```

Transfer hanya dilakukan setelah Final Validation berhasil.

---

## 8.2 Decline

Jika Recipient memilih **Decline**:

```text
Decline
↓
Trade Cancelled
```

Tidak ada aset yang berpindah.

---

# 9. Negotiation / Counter Offer

Recipient dapat memilih:

**[ NEGOSIASI ]**

Negotiation menghasilkan **maksimal 1 Counter Offer**.

Tidak ada negosiasi tanpa batas.

Flow:

```text
Original Proposal
↓
Player B memilih Negosiasi
↓
Counter Offer #1
↓
Player A menerima Counter Offer
```

Setelah Counter Offer dikirim, Player A dapat:

```text
[ ACCEPT ]
[ DECLINE ]
```

Tidak tersedia Counter Offer kedua.

---

# 10. Counter Offer Rules

Saat membuat Counter Offer:

* Player B hanya dapat menentukan aset yang **dimiliki Player B sendiri**.
* Player B dapat mengubah jumlah aset yang dia tawarkan selama tetap berada dalam batas 1–3 aset.
* Aset yang ditawarkan Player A **tetap sama**.
* Player B tidak dapat mengubah sisi Player A.

Contoh:

### Original Proposal

```text
Player A
└── Crown #1

Player B
├── Property L5
├── Property L4
└── Property L4
```

Player B memilih Negosiasi dan mengubah sisi miliknya:

```text
Player A
└── Crown #1

Player B
├── Property L5
└── Property L4
```

Kemudian:

```text
[ SEND COUNTER OFFER ]
```

Player A menjadi pihak yang merespons.

---

# 11. Multiple Incoming Trade

Player dapat menerima beberapa Trade Proposal sekaligus.

Contoh:

```text
Player B

├── Proposal ← Player A
├── Proposal ← Player C
└── Proposal ← Player D
```

Tidak ada batas jumlah **Incoming Trade Proposal**.

---

# 12. Multiple Proposal & Asset Conflict

Proposal tidak mengunci aset secara fisik.

Karena Player dapat memiliki beberapa proposal sekaligus, aset yang sama secara teori dapat muncul dalam beberapa proposal.

Contoh:

```text
Player A
└── Crown #1

Proposal → Player B
Proposal → Player C
```

Tidak ada masalah pada tahap Proposal.

Namun ketika salah satu proposal di-Accept, sistem melakukan **Final Validation**.

Proposal lain yang menggunakan aset yang sudah tidak tersedia akan gagal saat divalidasi.

---

# 13. Asset Validation

Trade Proposal **tidak melakukan reservation/locking terhadap aset**.

Saat Accept dilakukan, server melakukan Final Validation.

Validasi utama:

```text
Asset ID
+
Current Ownership
```

Sistem memastikan setiap aset yang akan ditransfer:

1. Masih ada.
2. Masih dimiliki Player yang seharusnya.
3. Masih memenuhi kondisi transaksi.

---

## Asset Sudah Tidak Dimiliki

Contoh:

```text
Proposal
Player A offers Crown #1
↓
Crown #1 kemudian ditrade ke Player C
↓
Player B menekan Accept
```

Final Validation:

```text
Apakah Player A masih memiliki Crown #1?
↓
Tidak
```

Maka:

```text
Trade Proposal
↓
Invalid
↓
Tidak ada transfer
```

UI menampilkan informasi seperti:

> **Trade Proposal No Longer Valid**

Dengan alasan bahwa satu atau lebih aset dalam proposal sudah tidak tersedia.

---

# 14. Property Level Change

Perubahan Level Property **tidak membatalkan proposal** selama Property yang sama masih dimiliki Player.

Contoh:

```text
Proposal:
Player A → Property L3
↓
Property tersebut di-upgrade
↓
Property menjadi L4
```

Proposal tetap valid karena identitas aset Property tetap sama.

Validasi menggunakan:

```text
Property Asset ID
+
Current Ownership
```

Bukan berdasarkan Level sebagai identitas aset.

---

# 15. Cancel Trade

Initiator dapat membatalkan Trade Proposal selama proposal masih berstatus **Pending**.

Flow:

```text
Pending Proposal
↓
Initiator memilih Cancel
↓
Trade Cancelled
```

Tidak ada aset yang berpindah.

---

# 16. Disconnect

Jika salah satu pihak disconnect dari game:

```text
Player Disconnect
↓
Semua Trade Proposal yang melibatkan Player tersebut
↓
Automatically Cancelled
```

Tidak ada Trade Proposal yang tetap aktif ketika salah satu pihak sudah disconnect.

Tidak ada transfer aset akibat disconnect.

---

# 17. Game State

Trade dapat digunakan ketika Game State mengizinkan interaksi Player Screen.

Namun proses otomatis yang membutuhkan kontrol Player dapat mengunci interaksi Trade sementara.

Contoh proses yang dapat mengunci Trade interaction:

* Roll
* Movement
* Landing Resolution
* Property Animation
* Jail Process
* Transport
* Proses otomatis lainnya

Contoh:

```text
Player A sedang Movement
↓
Trade interaction sementara terkunci
```

Namun **Trade Proposal yang sudah dikirim tidak otomatis dibatalkan** hanya karena Player sedang menjalankan proses game.

Setelah proses selesai:

```text
Movement selesai
↓
Player Screen kembali tersedia
↓
Trade Proposal dapat diakses kembali
```

---

# 18. Trade Tidak Terikat Turn

Trade bersifat asynchronous.

Player tidak harus menunggu Turn sendiri untuk:

* Membuat Trade.
* Menerima Trade.
* Membaca proposal.
* Accept.
* Decline.
* Negosiasi.

Namun akses terhadap UI dapat sementara dikunci oleh Game State ketika sistem sedang menjalankan proses otomatis.

---

# 19. Complete Trade Flow

```text
PLAYER A
   ↓
Player Screen
   ↓
Trade
   ↓
Pilih Player B
   ↓
Susun Trade Proposal
   │
   ├── 1–3 Asset Player A
   └── 1–3 Asset Player B
   ↓
Send Offer
   ↓
Proposal Pending
   │
   ├── Cancel
   │
   ├── Expired setelah 30 menit
   │
   ├── Player Disconnect
   │
   └── Player B Response
           │
           ├── Decline
           │      ↓
           │   Cancelled
           │
           ├── Negosiasi
           │      ↓
           │   Counter Offer #1
           │      ↓
           │   Player A
           │      ├── Accept
           │      └── Decline
           │
           └── Accept
                  ↓
             Final Validation
                  ↓
             Asset Ownership Check
                  ↓
                Valid?
               /     \
             Yes      No
              ↓        ↓
         Transfer    Invalid
              ↓
        Trade Complete
```

---

# 20. Trade State

Secara konseptual Trade Proposal memiliki beberapa state:

```text
Pending
   │
   ├── Accept → Validation → Complete
   │
   ├── Decline → Cancelled
   │
   ├── Cancel → Cancelled
   │
   ├── Expire → Expired
   │
   ├── Disconnect → Cancelled
   │
   ├── Invalid → Invalid
   │
   └── Negosiasi
          ↓
      Counter Offer #1
          │
          ├── Accept → Validation → Complete
          └── Decline → Cancelled
```

---

# 21. Core Design Principles

### Ownership

> Hanya aset yang benar-benar dimiliki Player yang dapat ditawarkan.

### No Asset Lock

> Proposal tidak mengunci aset secara fisik.

### Final Validation

> Semua transaksi harus divalidasi ulang tepat sebelum transfer.

### Reciprocity

> Kedua pihak wajib memberikan minimal 1 aset.

### Maximum 3

> Tidak ada pihak yang dapat memberikan lebih dari 3 aset dalam satu proposal.

### No Rels

> Rels bukan bagian dari Trade System.

### Limited Negotiation

> Setiap proposal hanya dapat menghasilkan maksimal 1 Counter Offer.

### Asynchronous

> Trade tidak terikat dengan Turn.

### Safe Transfer

> Tidak ada perubahan ownership sebelum Final Validation berhasil.

---

# 22. Final Example

### Original Proposal

```text
PLAYER A

Offers:
└── Crown #1

        ↕

PLAYER B

Offers:
├── Property L5
├── Property L4
└── Property L4
```

Player B memilih:

**Negosiasi**

Counter Offer:

```text
PLAYER A

Offers:
└── Crown #1

        ↕

PLAYER B

Offers:
├── Property L5
└── Property L4
```

Player A kemudian memilih:

**Accept**

Server melakukan:

```text
Final Validation
↓
Crown #1 masih milik Player A?
↓
Property L5 masih milik Player B?
↓
Property L4 masih milik Player B?
↓
Semua valid
↓
Transfer Ownership
↓
Trade Complete
```

Jika salah satu aset sudah tidak dimiliki pihak yang seharusnya:

```text
Final Validation
↓
Invalid
↓
Tidak ada transfer
↓
Trade Proposal No Longer Valid
```

---

# 23. Status Progress 15

**Trade System — COMPLETE / LOCKED 🔒**

Fondasi sistem, aturan aset, proposal, negosiasi, expiration, cancellation, disconnect, Game State, dan Final Validation sudah ditentukan.

Tahap berikutnya dapat masuk ke **Trade UI / UX**, dengan aturan sistem di atas sebagai dasar implementasi.

**Progress 15 sekarang bisa kita anggap selesai.** Langkah berikutnya paling pas adalah membedah **UI/UX Trade System** berdasarkan rules yang sudah terkunci ini.