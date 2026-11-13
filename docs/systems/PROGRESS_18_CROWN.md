Siap. Ini **rekap final Progress Crown System** dalam Markdown, dengan keputusan yang sudah kita kunci selama brainstorming.

````markdown
# Progress Crown System — Final

## 1. Status

**Status:** LOCKED / FINAL

Crown merupakan landmark sekaligus strategic asset yang terdapat di setiap District. Crown dapat dimiliki, dibeli, diperdagangkan, ditransaksikan, menghasilkan Crown Reward, dan menjadi salah satu kondisi kemenangan utama.

---

# 2. Crown di Board

Terdapat **4 Crown**, masing-masing satu untuk setiap District:

| District | Crown | Tile |
|---|---|---:|
| D1 | **The Verdant Crown** | **7** |
| D2 | **The Radiant Crown** | **16** |
| D3 | **The Stellar Crown** | **24** |
| D4 | **The Imperial Crown** | **33** |

Setiap Crown memiliki Tile khusus pada Board.

---

# 3. Crown Ownership

Crown memiliki tiga kondisi utama:

### Unowned

- Crown tidak memiliki Owner.
- Crown dapat dibeli ketika Player mendarat di Crown.
- Crown berada dalam kondisi **Clean**.

### Owned by Self

Jika Player mendarat di Crown miliknya sendiri:

- Player menerima **Crown Reward**.
- Tidak ada Rent.

### Owned by Other Player

Jika Player mendarat di Crown milik Player lain:

- Tidak terjadi apa-apa.
- Tidak ada Rent.
- Tidak ada Reward.
- Tidak ada Purchase.
- Tidak ada interaksi khusus.
- Turn berlanjut seperti biasa.

---

# 4. Crown Value

Crown Value ditentukan berdasarkan **Value L5 Property termahal di District tersebut +15%**.

Formula:

```text
Crown Value = Highest Property Value L5 × 1.15
````

Nominal ekonomi menggunakan kelipatan **500 Rels**.

| District | Highest Property Value L5 |      Crown Value |
| -------- | ------------------------: | ---------------: |
| D1       |                    64,000 |  **73,500 Rels** |
| D2       |                   102,000 | **117,500 Rels** |
| D3       |                   135,500 | **156,000 Rels** |
| D4       |                   174,000 | **200,000 Rels** |

### Final Crown Value

* D1 → **73,500 Rels**
* D2 → **117,500 Rels**
* D3 → **156,000 Rels**
* D4 → **200,000 Rels**

---

# 5. Crown Purchase

Crown dapat dibeli ketika Player mendarat pada **Unowned Crown**.

Flow mengikuti pola **Buy Property UI**.

### Purchase Flow

```text
Player mendarat di Unowned Crown
        ↓
Crown Purchase UI
        ↓
Player memilih Buy / Cancel
        ↓
Validasi Balance
        ↓
Pembayaran berhasil
        ↓
Ownership Crown berpindah ke Player
        ↓
Crown Victory Check
```

Jika Balance tidak mencukupi:

* Purchase tidak dapat dilakukan.

### Crown Purchase UI

UI menampilkan:

* Crown Name
* District
* Crown Value
* Balance Player
* Buy
* Cancel

Tidak menampilkan Crown Reward maupun detail Prosperity/Disruption.

---

# 6. Crown Reward

Crown tidak menghasilkan Rent.

Sebagai gantinya, Owner mendapatkan **Crown Reward ketika mendarat di Crown miliknya sendiri**.

### Formula

```text
Crown Reward =
Jumlah Property yang dimiliki Owner
di District Crown × 20,000 Rels
```

| Property di District |     Crown Reward |
| -------------------: | ---------------: |
|                    0 |           0 Rels |
|                    1 |      20,000 Rels |
|                    2 |      40,000 Rels |
|                    3 |      60,000 Rels |
|                    4 |      80,000 Rels |
|                    5 |     100,000 Rels |
|                    6 |     120,000 Rels |
|                    7 | **140,000 Rels** |

### Maximum Crown Reward

**140,000 Rels**

---

# 7. Crown Reward Ownership Scaling

Crown tidak menyimpan jumlah Property atau nilai Reward sebelumnya.

Reward selalu dihitung **secara real-time ketika Owner mendarat di Crown**.

Contoh:

Player memiliki Crown D1 dan 5 Property D1:

```text
5 × 20,000 = 100,000 Rels
```

Jika kemudian satu Property D1 berpindah ke Player lain:

```text
4 × 20,000 = 80,000 Rels
```

Crown Reward berikutnya menjadi **80,000 Rels**.

Dengan demikian:

* Property bertambah → Reward meningkat.
* Property berkurang → Reward menurun.
* Tidak ada Reward yang disimpan oleh Crown.

---

# 8. Crown Reward Feedback

Ketika Owner mendapatkan Crown Reward:

### Reward Popup

Menampilkan jumlah Reward yang diterima.

### Floating Reward

Jumlah Reward juga muncul sebagai floating number pada Board.

Contoh:

```text
+100,000 Rels
```

Keduanya digunakan bersamaan.

---

# 9. Crown Prosperity

**Crown Prosperity** berasal dari Luck News.

Ketika Crown Prosperity aktif:

* Sistem memilih **1 Crown milik Player secara acak**.
* Crown tersebut mendapatkan bonus **+2,000 Rels** pada Crown Reward.
* Durasi: **3 ronde**.
* Jika efek Prosperity kembali mengenai Crown yang sama, durasinya **refresh**, bukan stack.
* Jika Player tidak memiliki Crown, Player mendapatkan **15,000 Rels** sebagai pengganti.

### Prosperity Calculation

Contoh:

```text
Normal Crown Reward = 80,000
Prosperity Bonus = +2,000

Final Reward = 82,000 Rels
```

### Prosperity Feedback

Feedback mengikuti sistem UI **Luck News**.

Crown yang terkena Prosperity mendapatkan **Prosperity Status Icon** selama efek aktif.

---

# 10. Crown Disruption

Ketika **Crown Disruption** aktif:

* Semua Crown yang dimiliki Player terkena Disruption.
* Crown tetap menjadi milik Player.
* Crown tetap dihitung untuk Crown Victory.
* Setiap Crown yang terkena Disruption memiliki **1 Crown Reward berikutnya = 0 Rels**.

### Saat Owner mendarat di Crown yang Disrupted

```text
Landing
   ↓
Crown Reward = 0 Rels
   ↓
Reward Popup + Floating Reward
   ↓
Disruption selesai
   ↓
Crown kembali normal
```

Status Disruption **langsung hilang setelah Crown digunakan**.

Crown Prosperity tidak dihapus atau dijeda oleh Disruption.

### Disruption Feedback

Feedback mengikuti sistem UI **Luck News**.

Crown yang terkena Disruption mendapatkan **Disruption Status Icon**.

---

# 11. Crown Transfer

Crown dapat berpindah ownership melalui:

* Trade
* Transaction

Crown sepenuhnya mengikuti Asset System.

Ketika ownership Crown berpindah:

```text
Ownership berubah
        ↓
Semua status Crown di-reset
        ↓
Crown menjadi Clean
        ↓
Owner baru mendapatkan Crown dalam kondisi normal
```

### Status yang di-reset

* Crown Prosperity → dihapus
* Crown Disruption → dihapus
* Status Crown lainnya → di-reset

Crown tidak membawa modifier atau status dari Owner sebelumnya.

---

# 12. Crown Reward Setelah Transfer

Crown Reward tidak dibawa dari Owner sebelumnya.

Setelah transfer:

* Crown menjadi Clean.
* Reward dihitung berdasarkan jumlah Property District yang dimiliki **Owner baru**.
* Perhitungan dilakukan ketika Owner baru mendarat di Crown.

Contoh:

Player A:

```text
Crown D1 + 6 Property D1
→ 120,000 Rels
```

Crown ditransfer ke Player B.

Player B:

```text
Crown D1 + 2 Property D1
→ 40,000 Rels
```

---

# 13. Crown Destroyed

Ketika Crown **Destroyed**:

* Ownership Player dicabut.
* Crown menjadi **Unowned**.
* Semua status/modifier dihapus.
* Crown menjadi **Clean**.
* Crown tetap berada di Tile-nya.
* Crown dapat dibeli kembali oleh Player lain.

Flow:

```text
Crown Owned
    ↓
Crown Destroyed
    ↓
Ownership dicabut
    ↓
Unowned + Clean
    ↓
Dapat dibeli kembali
```

---

# 14. Crown Liquidation

Ketika Crown dilikuidasi:

* Player menerima **100% Crown Value**.
* Tidak ada potongan.
* Setelah liquidation selesai, Crown dianggap **Destroyed**.
* Ownership dicabut.
* Crown menjadi **Unowned + Clean**.
* Crown dapat dibeli kembali.

| District | Crown Value | Liquidation Value |
| -------- | ----------: | ----------------: |
| D1       |      73,500 |   **73,500 Rels** |
| D2       |     117,500 |  **117,500 Rels** |
| D3       |     156,000 |  **156,000 Rels** |
| D4       |     200,000 |  **200,000 Rels** |

Formula:

```text
Liquidation Value = 100% Crown Value
```

---

# 15. Crown Victory

Crown merupakan salah satu kondisi kemenangan utama.

Player langsung dinyatakan **menang** ketika Player memiliki kepemilikan atas **seluruh 4 Crown**.

Keempat Crown harus dimiliki oleh Player yang sama:

1. The Verdant Crown
2. The Radiant Crown
3. The Stellar Crown
4. The Imperial Crown

### Victory Requirement

```text
4/4 Crown milik Player
→ WIN
```

Jika hanya:

```text
3/4 → Belum menang
2/4 → Belum menang
1/4 → Belum menang
```

Jika ada **satu saja Crown yang bukan milik Player**, Player belum menang.

Begitu Crown keempat berhasil menjadi milik Player:

```text
Ownership Crown ke-4 berhasil
        ↓
4 Crown dimiliki Player yang sama
        ↓
🏆 LANGSUNG MENANG
```

Tidak perlu menunggu akhir Turn.

---

# 16. Crown & Trade / Transaction

Crown mengikuti **Asset System**.

Crown:

* Dapat dimasukkan ke Trade.
* Dapat dipindahkan melalui Transaction.
* Tidak memiliki pembatasan khusus dibanding asset lainnya.
* Ownership berpindah setelah proses berhasil.
* Setelah transfer, Crown menjadi **Clean**.

### Transaction Minimum

Untuk Crown, aturan Transaction yang sudah ada tetap berlaku:

```text
Minimum Transaction Price =
3 × Crown Value
```

Nominal dibulatkan ke **500 Rels**.

---

# 17. Crown Status Setelah Purchase

Setiap Crown yang dibeli dalam kondisi **Unowned + Clean** menjadi:

```text
Owned + Clean
```

Crown tidak membawa status lama.

Setelah purchase:

* Tidak ada Prosperity.
* Tidak ada Disruption.
* Crown Reward menggunakan formula normal.
* Jika Crown sebelumnya Destroyed, Crown sudah kembali dalam kondisi Unowned + Clean.

---

# 18. Crown Visual Ownership

Crown mempertahankan **visual dan warna District**.

Ownership ditunjukkan menggunakan:

### Owner Aura / Glow

* Player 1 → Merah
* Player 2 → Biru
* Player 3 → Hijau
* Player 4 → Kuning

Warna District Crown **tidak berubah** ketika ownership berubah.

### Owner Name

Ketika Crown dimiliki:

* Nama Roblox Player ditampilkan pada Crown.
* Nama berubah otomatis ketika ownership berpindah.
* Saat Crown Unowned → Owner Name tidak ditampilkan.

### Status Icon

Jika Crown memiliki status:

* Prosperity → Prosperity Icon
* Disruption → Disruption Icon

Status Icon hanya muncul selama status aktif.

---

# 19. Crown Ownership Transition

Ketika ownership berubah:

1. Aura Owner lama menghilang.
2. Crown melakukan transisi singkat.
3. Aura Player baru muncul.
4. Owner Name diperbarui.

Tidak ada animasi Claim khusus.

### Destroyed / Liquidated

Menggunakan pola transisi yang sama:

1. Aura Owner menghilang.
2. Crown melakukan transisi singkat.
3. Owner Name menghilang.
4. Crown kembali menjadi **Unowned + Clean**.

---

# 20. Crown Info UI

Crown memiliki informasi dasar:

* **Crown Name**
* **District**
* **Owner**
* **Crown Value**

Crown tidak memiliki UI informasi tambahan untuk:

* Crown Reward
* Prosperity
* Disruption

---

# 21. Crown Board Interaction

Crown **tidak dapat diklik/tap langsung pada Board**.

Crown hanya menjadi bagian dari Board.

Informasi Crown diakses melalui UI sistem yang relevan, terutama:

```text
Assets Panel → Crowns
```

Tidak ada Context Menu khusus dari Tile Crown.

---

# 22. Ringkasan Crown Gameplay

### Unowned Crown

```text
Player Landing
      ↓
Crown Purchase UI
      ↓
Buy / Cancel
      ↓
Validasi Balance
      ↓
Purchase
      ↓
Owned + Clean
```

### Own Crown

```text
Player Landing
      ↓
Hitung Property di District
      ↓
Crown Reward
      ↓
Balance bertambah
      ↓
Reward Popup + Floating Reward
```

### Other Player's Crown

```text
Player Landing
      ↓
Tidak terjadi apa-apa
      ↓
Turn lanjut
```

### Disrupted Crown

```text
Player Landing
      ↓
Reward = 0
      ↓
Popup + Floating Reward
      ↓
Disruption selesai
      ↓
Crown kembali normal
```

### Crown Transfer

```text
Trade / Transaction
      ↓
Ownership berpindah
      ↓
Status Crown di-reset
      ↓
Clean
```

### Crown Liquidation

```text
Liquidation
      ↓
Player menerima 100% Crown Value
      ↓
Crown Destroyed
      ↓
Ownership dicabut
      ↓
Unowned + Clean
```

### Crown Victory

```text
Player mendapatkan Crown ke-4
      ↓
Semua 4 Crown milik Player yang sama
      ↓
🏆 WIN
```

---

# 23. Final Crown Rules

| Sistem                   | Final Rule                            |
| ------------------------ | ------------------------------------- |
| Jumlah Crown             | **4 Crown**                           |
| Crown per District       | **1**                                 |
| Crown Value              | Highest Property L5 + **15%**         |
| D1 Crown Value           | **73,500 Rels**                       |
| D2 Crown Value           | **117,500 Rels**                      |
| D3 Crown Value           | **156,000 Rels**                      |
| D4 Crown Value           | **200,000 Rels**                      |
| Crown Rent               | **Tidak ada**                         |
| Crown Reward             | **20,000 × jumlah Property District** |
| Maximum Crown Reward     | **140,000 Rels**                      |
| Prosperity               | **+2,000 Rels selama 3 ronde**        |
| Prosperity Target        | **1 Crown acak**                      |
| No Crown saat Prosperity | **+15,000 Rels**                      |
| Disruption               | **Reward berikutnya = 0**             |
| Disruption Duration      | **Sampai Crown digunakan**            |
| Transfer Status          | **Reset → Clean**                     |
| Liquidation              | **100% Crown Value**                  |
| Destroyed                | **Unowned + Clean**                   |
| Crown Purchase           | **Saat landing di Unowned Crown**     |
| Crown Owned by Other     | **Tidak terjadi apa-apa**             |
| Trade                    | **Allowed**                           |
| Transaction              | **Allowed**                           |
| Transaction Minimum      | **3× Crown Value**                    |
| Crown Victory            | **Memiliki seluruh 4 Crown**          |
| Victory Trigger          | **Langsung saat Crown ke-4 dimiliki** |
| Ownership Visual         | **Player Aura + Roblox Player Name**  |
| Status Visual            | **Status Icon**                       |
| Board Click              | **Tidak tersedia**                    |

---

## Crown System Status

**CROWN SYSTEM — COMPLETE / LOCKED 🔒👑**

Tidak ada lagi perubahan mekanik Crown yang diperlukan pada tahap brainstorming ini. Detail visual kecil seperti audio, animasi tambahan, atau polish UI dapat dikerjakan pada tahap implementasi tanpa mengubah core gameplay rules.

```
```