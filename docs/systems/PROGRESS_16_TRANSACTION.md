Siap. Ini rekap final **Transaction System** dalam Markdown, dengan keputusan yang sudah kita kunci dan dibuat siap dimasukkan ke source/Claude.

# Relopoli — Transaction System

## 1. Overview

**Transaction** adalah sistem untuk melakukan pertukaran:

> **Asset ↔ Rels**

Transaction terutama digunakan untuk membeli **Property** atau **Crown** milik Player lain menggunakan Rels.

Transaction bersifat **asynchronous** dan tidak terikat pada giliran Player.

Transaction menggunakan pola proposal dan negosiasi yang mirip dengan **Trade System**, tetapi memiliki aturan khusus untuk:

* Harga
* Minimum Price
* Balance
* Asset ↔ Rels
* Property Level
* Crown

---

# 2. Initiator

Transaction selalu dimulai oleh **Buyer**.

Flow:

```text
Player Screen
↓
Transaction
↓
Select Player
↓
Select Asset
↓
Set Price
↓
Send Offer
```

Buyer menentukan:

1. Target Player
2. Asset yang ingin dibeli
3. Initial Offer Price

---

# 3. Asset yang Bisa Ditawarkan

### Property

Property milik Player lain dapat dibeli melalui Transaction.

### Crown

Crown dapat dibeli melalui Transaction **jika Crown tersebut sudah dimiliki Player lain**.

Crown yang masih **Unowned tidak dapat dibeli melalui Transaction**.

Jika Buyer sudah memiliki Crown tersebut:

> Crown tetap ditampilkan tetapi **disabled — "Already Owned"**.

---

# 4. Property Minimum Price

Minimum Price Property:

> **Current Property Value**

Buyer tidak boleh memberikan Initial Offer di bawah Minimum Price.

Contoh:

```text
Property Value = 75,000 Rels

Minimum Price = 75,000 Rels

75,000 ✓
80,000 ✓
100,000 ✓
70,000 ✕
```

Minimum Price selalu mengikuti **Current Property Value**.

Jika Value berubah selama Transaction masih pending, Minimum Price ikut diperbarui.

---

# 5. Crown Minimum Price

Crown memiliki aturan khusus.

Minimum Price:

> **3 × Crown Value**

Hasil dibulatkan ke kelipatan **500 Rels**.

Contoh:

```text
Crown Value = 100,000

Minimum Price = 300,000 Rels
```

UI hanya menampilkan:

> **Minimum Price: 300,000 Rels**

Formula `3 × Crown Value` tidak perlu ditampilkan kepada Player.

---

# 6. Price Input

Buyer menggunakan:

> **Manual Input + Stepper**

Aturan:

* Harga harus ≥ Minimum Price.
* Harga harus kelipatan 500 Rels.
* Tidak ada Maximum Price.
* Buyer dapat menawarkan harga berapa pun selama memenuhi Minimum Price dan memiliki Balance yang cukup ketika Offer dibuat.

Contoh:

```text
−   75,000   +
```

Tombol `−` tidak boleh membawa harga di bawah Minimum Price.

---

# 7. Initial Offer

Buyer menentukan harga awal secara bebas selama memenuhi:

```text
Offer Price ≥ Minimum Price
```

Saat Offer dibuat:

> Buyer harus memiliki Balance yang cukup untuk membayar Initial Offer.

Namun:

> **Rels tidak di-reserve.**

Buyer tetap dapat menggunakan Rels setelah Offer dibuat.

---

# 8. Negotiation

Seller memiliki tiga pilihan:

```text
Accept
Decline
Negotiate
```

Transaction mengikuti pola negosiasi Trade.

---

# 9. Counter Offer

Transaction memiliki maksimal:

> **1 Counter Offer**

Seller dapat menentukan Counter Price secara bebas selama:

```text
Counter Price ≥ Minimum Price
```

Counter Price boleh:

* Lebih rendah dari Initial Offer
* Sama dengan Initial Offer
* Lebih tinggi dari Initial Offer

Seller tidak dapat melakukan Counter kedua.

Setelah Seller membuat Counter:

```text
Seller
↓
Counter Offer
↓
Buyer
↓
Accept / Decline
```

Buyer tidak dapat melakukan Counter balik.

---

# 10. Balance Validation

Balance menggunakan dua tahap validation.

### Offer Creation

Saat Buyer membuat Initial Offer:

> Buyer harus memiliki Rels yang cukup.

Namun Rels **tidak di-reserve**.

Contoh:

```text
Balance = 100K
Offer = 80K
↓
Offer dibuat
↓
Buyer menghabiskan 50K
↓
Balance = 50K
```

Offer tetap aktif.

### Live Validation

UI terus mengecek Balance terbaru.

Jika:

```text
Current Balance < Transaction Price
```

maka:

> **Accept disabled**

Jika Buyer mendapatkan Rels kembali dan Balance kembali mencukupi sebelum expiration:

> Accept dapat aktif kembali.

---

# 11. Final Validation

Saat Buyer menekan **Accept**, Server melakukan:

> **Final Validation**

UI validation tidak dianggap cukup.

Final Validation memastikan seluruh kondisi Transaction masih valid sebelum transaksi dieksekusi.

---

# 12. Final Validation Failure

Jika Final Validation gagal:

> **Transaction langsung berakhir.**

Tidak ada retry pada proposal yang sama.

UI harus menampilkan **alasan spesifik**.

Contoh:

```text
Buyer does not have enough Rels.
```

```text
Property is no longer owned by this Player.
```

```text
Transaction has expired.
```

```text
Asset is no longer available.
```

---

# 13. Atomic Transaction

Jika Final Validation berhasil, Transaction dieksekusi secara **atomic**.

Perubahan:

```text
Buyer Balance
      ↓
Buyer - Price

Seller Balance
      ↓
Seller + Price

Asset Ownership
      ↓
Seller → Buyer
```

Semua perubahan harus berhasil sebagai **satu operasi**.

Tidak boleh terjadi partial transaction.

Contoh kondisi yang tidak diperbolehkan:

```text
Buyer sudah membayar
tetapi Asset belum berpindah.
```

atau:

```text
Asset sudah berpindah
tetapi Seller belum menerima Rels.
```

---

# 14. Property Ownership Transfer

Saat Property berhasil ditransaksikan:

* Ownership → Buyer
* Property Level tetap sama
* Property tetap Asset yang sama
* District tetap sama
* Artwork tetap sama
* Property Modifier tetap mengikuti Property

Ownership visual berubah menjadi Player baru.

---

# 15. Crown Ownership Transfer

Saat Crown berhasil ditransaksikan:

* Ownership → Buyer
* Crown tetap Crown yang sama
* Crown status tetap mengikuti Crown
* Crown Modifier tetap mengikuti Crown

Jika Crown memiliki:

* Prosperity
* Disruption
* Timer/status lainnya

status tersebut tetap aktif sesuai kondisi terbaru saat transfer.

---

# 16. Crown Victory

Setelah Crown berpindah:

> **Crown Victory dihitung ulang berdasarkan current Crown ownership.**

Artinya Victory tidak dianggap permanen hanya karena Player pernah memiliki Crown.

Ownership Crown saat ini menjadi dasar perhitungan.

---

# 17. Pending Transaction — Property State Changes

Pending Transaction Property memiliki aturan berikut.

| Perubahan                 | Transaction     |
| ------------------------- | --------------- |
| Ownership berubah         | **Invalid**     |
| Property Level berubah    | **Invalid**     |
| Property Modifier berubah | **Tetap Valid** |
| Set berubah               | **Tetap Valid** |
| Set Complete → Break      | **Tetap Valid** |
| Set Break → Complete      | **Tetap Valid** |

### Property Level

Jika Property mengalami Upgrade ketika Transaction pending:

```text
L3
↓
Upgrade
↓
L4
```

Transaction langsung:

> **Invalid**

Property Level merupakan bagian penting dari validitas pending Transaction.

---

# 18. Pending Transaction — Property Modifier

Perubahan Modifier tidak membatalkan Transaction.

Contoh:

```text
Transaction dibuat
↓
Property Modifier berubah
↓
Transaction tetap valid
```

Jika Transaction akhirnya berhasil:

> Buyer menerima Property dengan **Modifier terbaru**.

---

# 19. Pending Transaction — Set

Perubahan Set tidak membatalkan Transaction.

Set dapat berubah karena perubahan ownership Property lain.

Contoh:

```text
Set Complete
↓
Property lain berpindah
↓
Set Break
```

Transaction Property yang sedang pending:

> **Tetap valid**

Selama Asset memenuhi aturan validitas lainnya.

---

# 20. Pending Transaction — Crown Status

Perubahan Crown Status tidak membatalkan Transaction.

Perubahan yang tidak meng-invalidasi:

* Prosperity aktif
* Prosperity timer berubah
* Prosperity berakhir
* Disruption aktif
* Disruption berakhir
* Status Crown lainnya

Selama Crown masih merupakan Crown yang sama dan Ownership tetap sesuai:

> Transaction tetap valid.

Buyer menerima Crown dengan **status terbaru saat Transaction berhasil**.

---

# 21. Asset Identity

Untuk Property, validitas pending Transaction terutama bergantung pada:

```text
Asset ID
+
Ownership
+
Property Level
```

Modifier dan Set bukan bagian dari invalidation identity.

Untuk Crown:

```text
Crown ID
+
Ownership
```

Crown Status/Modifier tidak membatalkan Transaction.

---

# 22. Multiple Pending Transactions

Transaction tidak menggunakan Asset Lock.

Artinya:

> Asset yang sama dapat muncul dalam beberapa Transaction aktif sekaligus.

Contoh:

```text
Player A → Property X
Player B → Property X
Player C → Property X
```

Semua proposal dapat tetap aktif.

Jika salah satu Transaction berhasil dan Ownership berubah:

> Semua Transaction aktif lainnya untuk Asset ID tersebut langsung menjadi **Invalid**.

Tidak perlu menunggu Player lain menekan Accept.

---

# 23. Expiration

Transaction memiliki batas waktu:

> **30 menit**

Setelah 30 menit:

```text
Pending
↓
Expired
```

Transaction yang sudah Expired:

* Tidak dapat diterima
* Tidak dapat dinegosiasikan
* Tidak dapat dieksekusi

---

# 24. Cancellation

### Buyer

Buyer dapat melakukan:

> **Cancel**

Cancel langsung mengakhiri Transaction.

### Seller

Seller dapat melakukan:

> **Decline**

Decline langsung mengakhiri Transaction.

Setelah Transaction berakhir:

> Buyer dapat langsung membuat Transaction baru.

Tidak ada cooldown.

Tidak ada kewajiban menunggu perubahan harga.

---

# 25. Transaction Status

Transaction menggunakan status berikut:

| Status        | Deskripsi                              |
| ------------- | -------------------------------------- |
| **Pending**   | Offer aktif dan menunggu respons       |
| **Countered** | Seller telah membuat Counter Offer     |
| **Completed** | Transaction berhasil                   |
| **Declined**  | Transaction ditolak                    |
| **Cancelled** | Transaction dibatalkan oleh Buyer      |
| **Expired**   | Batas waktu 30 menit habis             |
| **Invalid**   | Asset/State tidak lagi memenuhi syarat |

---

# 26. Complete State

Setelah Accept berhasil:

```text
Final Validation
↓
Atomic Transaction
↓
Transaction Complete State
↓
Auto Close
```

Tidak ada confirmation kedua setelah Accept.

---

# 27. UI Flow Final

```text
PLAYER SCREEN
      ↓
TRANSACTION
      ↓
SELECT PLAYER
      ↓
SELECT ASSET
      ↓
SET PRICE
      ↓
SEND OFFER
      ↓
SELLER RECEIVES
      ↓
 ┌─────────────────┐
 │ Accept          │
 │ Decline         │
 │ Negotiate       │
 └─────────────────┘
      ↓
   Negotiate
      ↓
  Counter Offer
      ↓
     BUYER
      ↓
 ┌─────────────────┐
 │ Accept          │
 │ Decline         │
 └─────────────────┘
      ↓
Final Validation
      ↓
Atomic Transaction
      ↓
Transaction Complete
      ↓
Auto Close
```

---

# 28. Transaction vs Trade

Transaction menggunakan banyak pola dasar dari Trade:

* Asynchronous
* Proposal-based
* Accept / Decline / Negotiate
* Maksimal 1 Counter
* 30-minute expiration
* Tidak ada Asset Lock
* Final Validation
* Proposal dapat menjadi Invalid
* Multiple proposal dapat aktif

Perbedaan utama:

| Trade                                                              | Transaction                                  |
| ------------------------------------------------------------------ | -------------------------------------------- |
| Asset ↔ Asset                                                      | Asset ↔ Rels                                 |
| Kedua pihak menawarkan Asset                                       | Buyer menawarkan Rels                        |
| Maksimal 3 Asset per sisi                                          | **1 Asset**                                  |
| Tidak menggunakan Minimum Price                                    | **Menggunakan Minimum Price**                |
| Tidak bergantung pada Balance pembelian                            | **Balance sangat penting**                   |
| Property Level tidak membatalkan selama Asset ID + Ownership tetap | **Property Level Change → Invalid**          |
| Crown mengikuti aturan Trade yang berlaku                          | **Crown memiliki aturan Transaction khusus** |

---

# 29. Core Principle

Transaction harus tetap sederhana:

> **Buyer memilih Asset milik Player lain → menentukan harga ≥ Minimum Price → Seller menerima, menolak, atau melakukan satu Counter → Buyer menerima/menolak Counter → Final Validation → Atomic Transfer.**

### Property

```text
Property
↔
Rels

Minimum Price = Current Property Value
```

### Crown

```text
Owned Crown
↔
Rels

Minimum Price = 3 × Crown Value
```

Crown Unowned tidak dapat dibeli melalui Transaction.

---

# 30. Final Status

**Transaction System — FINAL**

Seluruh aturan utama telah dikunci:

* Initiator
* Target Player
* Asset Selection
* Property Transaction
* Crown Transaction
* Minimum Price
* Price Input
* Initial Offer
* Counter Offer
* Balance
* Live Validation
* Final Validation
* Atomic Execution
* Ownership Transfer
* Property Level
* Property Modifier
* Set
* Crown Status
* Crown Victory
* Multiple Pending Transaction
* Asset Invalidation
* Expiration
* Cancel
* Decline
* Transaction Status
* Complete State
* UI Flow

**Transaction tidak perlu lagi dipecah menjadi brainstorming kecil seperti sebelumnya. Sistem sudah siap masuk ke tahap implementasi.**

Ini sudah cocok dijadikan **source of truth Transaction System** dan disejajarkan dengan rekap **Trade System** sebelumnya.