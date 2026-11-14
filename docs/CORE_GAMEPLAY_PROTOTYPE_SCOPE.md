# Relopoli Core Gameplay Prototype
## Prototype Scope v1.0

**Status:** LOCKED  
**Approval date:** 2026-11-14  
**Workstream:** A. Core Gameplay Prototype  
**Target environment:** Roblox Studio, 1 Server + 4 Clients  
**Development stage:** Planning

## 1. Objective

Membangun prototype fondasi gameplay Relopoli untuk membuktikan bahwa empat pemain dapat menjalankan satu siklus permainan secara bergantian dengan sistem Roll, Movement, Start Reward, Landing Resolution, dan Turn Controller yang konsisten.

Prototype berfokus pada pembuktian alur gameplay dan kestabilan multiplayer, bukan penyelesaian seluruh fitur permainan.

## 2. Approved Prototype Scope

### 2.1 Multiplayer Foundation
- Satu server dengan empat pemain.
- Match dimulai dengan empat pemain.
- Urutan pemain ditentukan berdasarkan urutan bergabung sebelum match dimulai.
- Pemain yang bergabung setelah match dimulai tidak masuk ke match aktif.
- Turn berjalan otomatis: Player 1 → Player 2 → Player 3 → Player 4 → Player 1.
- Setiap pemain harus dapat menyelesaikan satu giliran penuh.

### 2.2 Board
- Seluruh 40 tile logis, Tile 0 sampai Tile 39.
- Visual board boleh disederhanakan.
- Identitas, urutan, dan hubungan antar-tile harus konsisten dengan board yang telah ditetapkan.
- Tampilan map final tidak diperlukan.

### 2.3 Turn Controller
Turn Controller menjadi pemilik alur gameplay.

Alur normal:
1. Turn Start.
2. News Phase.
3. Roll.
4. Dice Resolution.
5. Movement.
6. Movement Complete.
7. Start Detection dan First Lap Check.
8. Start Reward.
9. Landing Resolution.
10. Temporary Handler atau UI yang diperlukan.
11. Victory Check.
12. Extra Roll Check.
13. Turn End.

News Phase tetap menjadi bagian dari Turn Controller, tetapi belum menjalankan efek kartu. Untuk prototype, News Phase otomatis melanjutkan permainan ke Roll.

### 2.4 Physical Dice Roll
- Menggunakan dua Physical Dice dengan animasi roll.
- Server menunggu sampai kedua dice berhenti.
- Server membaca sisi atas menggunakan Raycast.
- Kedua nilai harus valid sebelum Roll dianggap selesai.
- Total dice, Double, dan Triple Double diperiksa oleh server.
- Client tidak boleh mengirim nilai dice sebagai hasil yang dipercaya server.

**Invalid Dice Handling**
1. Tunggu kedua dice berhenti.
2. Baca kedua sisi atas menggunakan Raycast.
3. Validasi kedua nilai.
4. Jika invalid, lakukan validasi ulang.
5. Jika tetap invalid, server me-reset dice dan otomatis melakukan roll ulang.
6. Retry tidak memiliki batas percobaan buatan.

Roll baru dianggap valid setelah kedua nilai dice berhasil dibaca dan divalidasi. Percobaan invalid tidak boleh mengubah Double Counter, menghasilkan destination, memulai Movement, mengonsumsi giliran, atau menghasilkan efek gameplay.

### 2.5 Movement Engine
- Menggunakan satu Movement Engine bersama.
- Movement mengikuti jalur board.
- Normal Movement menggunakan hasil Roll yang valid.
- Destination ditentukan oleh server.
- Landing Resolution hanya dijalankan pada destination.
- Tile yang dilewati tidak menjalankan Landing Resolution.
- Movement berjalan otomatis dan memiliki status penyelesaian yang dapat divalidasi.

### 2.6 Start System
Start System menjadi salah satu fitur yang benar-benar berfungsi dalam prototype.

| Kondisi | Reward |
|---|---:|
| Pass Start | 20.000 Rels |
| Landing Start | 30.000 Rels |
| First Lap | 100.000 Rels total |

- First Lap dilacak secara individual untuk setiap pemain.
- Reward First Lap sebesar 100.000 Rels menggantikan reward Pass Start atau Landing Start pada Movement tersebut. Reward tidak ditumpuk dengan reward normal.
- Setelah First Lap selesai, reward Start normal berlaku kembali.
- Landing Start tetap terdeteksi, tetapi Start Upgrade belum diimplementasikan.
- Reward diproses setelah Movement selesai dan sebelum Landing Resolution.

### 2.7 Minimal Balance System
- Starting Capital: 250.000 Rels.
- Balance dikelola server.
- Reward Start memperbarui Balance.
- Semua perubahan Balance harus menggunakan kelipatan 500.
- Balance tidak boleh negatif; Balance 0 diperbolehkan.
- UI hanya menampilkan Balance.
- Tidak ada mekanisme pengeluaran uang dalam prototype.

### 2.8 Landing Resolution
Landing Resolution harus mengenali keenam kategori tile dari Master Flow.

| Kategori | Batas implementasi |
|---|---|
| Property | Detection dan Display informasi |
| Crown | Detection dan Display informasi |
| News | Temporary Handler / Stub |
| Reward | Temporary Handler / Stub |
| Transport | Temporary Handler / Stub |
| Jail | Temporary Handler / Stub |

Property dan Crown tidak menjalankan transaksi atau perubahan kepemilikan.

Temporary Handler untuk News, Reward, Transport, dan Jail hanya boleh:
- Menerima destination dan kategori tile.
- Memvalidasi kecocokan kategori dan handler.
- Mencatat atau mengembalikan hasil routing.
- Mengembalikan kontrol ke Resolution Chain.

Temporary Handler tidak boleh mengubah Balance, Ownership, Property Level, Crown Status, Modifier, Turn Order, Double Counter, atau Victory State.

**Pengecualian:** Triple Double dapat mengubah Jail State dan mengakhiri giliran sesuai aturan Triple Double. Hal ini bukan bagian dari Jail Landing Handler.

### 2.9 Triple Double
- Double Counter dilacak oleh server.
- Double pertama dan kedua mengikuti alur normal.
- Double ketiga berturut-turut langsung mengirim pemain ke Jail.
- Pemain tidak menjalankan Movement dari hasil Double ketiga.
- Landing Resolution tidak dijalankan.
- Jail State pemain dicatat.
- Giliran pemain berakhir.
- Jail Exit Mechanics belum termasuk prototype.

### 2.10 Disconnect Handling
Jika pemain disconnect:
- Pemain dihapus dari daftar pemain aktif dan tidak menerima giliran berikutnya.
- Jika pemain yang sedang aktif disconnect, Resolution yang sedang berjalan dihentikan dengan aman.
- Pending UI dibersihkan.
- Turn Order dibangun kembali berdasarkan pemain aktif.
- Global Victory Check dijalankan.

| Pemain aktif | Hasil |
|---|---|
| 2 atau lebih | Game berlanjut |
| 1 | Game State menjadi ENDED, pemain tersisa menang |
| 0 | Game State menjadi ABORTED, tidak ada pemenang |

Kemenangan satu pemain dalam prototype hanya menggunakan aturan Last Player Standing.

### 2.11 Character Reset / Death Recovery
Jika karakter Reset atau mati saat Movement berlangsung:
1. Movement yang sedang berjalan dibatalkan.
2. Karakter dikembalikan ke tile valid terakhir yang tercatat sebelum Movement dimulai.
3. Server mempertahankan Roll Result dan destination yang sudah sah.
4. Movement dilanjutkan menuju destination yang sama tanpa Roll ulang.
5. Start Reward dan Landing Resolution hanya diproses setelah Movement berhasil selesai.
6. Reward dan Landing Resolution tidak boleh dieksekusi dua kali.

Turn tetap menjadi milik pemain yang sama. Server tetap menjadi sumber kebenaran untuk posisi dan status gameplay.

## 3. Explicitly Out of Scope

### Economy dan Property
- Property Purchase, Rent, Property Upgrade, Property Ownership Management, Property Level System.
- Bankruptcy dan Rescue.
- Transaksi pembelian atau pembayaran.
- Balance Ledger dan Transaction History.

### Crown
- Crown Purchase, Crown Ownership, Crown Reward Mechanics, Crown Victory.

### News
- News Card Effects, Stored News, News Double Dice Mechanics, News Modifier.

### Reward dan Transport
- Full Reward Mechanics.
- Transport Fast Travel, Transport Privilege, Transport Modifier.

### Jail
- Jail Payment, Jail Exit Mechanics, Jail Turn Penalty Mechanics.

### Multiplayer dan Game Systems
- Trade System, Transaction System, Full Victory Conditions.
- Set Victory, L5 Victory, full Game-End UI, Admin Gameplay Tools.

### Presentation
- Final Map Art, Final UI Design, Final Animations, Final Assets dan Visual Polish.

## 4. Technical Principles
1. **Server Authoritative:** server menjadi sumber kebenaran untuk state dan hasil gameplay.
2. **Sequential State Changes:** perubahan gameplay mengikuti urutan Resolution Chain.
3. **Atomic Operations:** operasi yang harus konsisten tidak boleh menghasilkan state setengah jadi.
4. **Invalid Action = Zero Side Effect:** input tidak valid tidak boleh mengubah state.
5. **No Duplicate Execution:** Movement, Reward, dan Landing Resolution tidak boleh diproses dua kali.
6. **Explicit State:** setiap fase gameplay harus memiliki status yang dapat diperiksa.
7. **No Silent Rule Changes:** Codex tidak boleh mengubah keputusan gameplay yang sudah dikunci.
8. **No Scope Expansion:** fitur di luar dokumen ini tidak boleh ditambahkan tanpa persetujuan.
9. **Unknowns Stay Unknown:** detail yang belum diputuskan harus ditandai TBD, bukan diisi berdasarkan asumsi.
10. **Game-End Hard Stop:** setelah Game State berakhir, proses gameplay baru tidak boleh dimulai.

## 5. Prototype Acceptance Criteria

### Multiplayer
- Empat pemain dapat masuk ke match.
- Turn berjalan sesuai urutan.
- Setiap pemain dapat menyelesaikan satu giliran penuh.
- Setelah Player 4, giliran kembali ke Player 1.
- Tidak ada giliran yang terlewat atau dijalankan dua kali.

### Roll dan Movement
- Kedua Physical Dice dapat menghasilkan nilai valid.
- Invalid Dice ditangani melalui retry otomatis.
- Invalid attempt tidak mengubah state gameplay.
- Movement mengikuti destination yang dihitung server.
- Landing Resolution hanya terjadi pada destination.

### Start dan Balance
- Starting Capital setiap pemain benar.
- Pass Start memberikan 20.000 Rels.
- Landing Start memberikan 30.000 Rels.
- First Lap memberikan 100.000 Rels total.
- Reward tidak terduplikasi.
- Balance tidak negatif dan selalu menggunakan kelipatan 500.

### Landing Resolution
- Keenam kategori tile dapat dikenali.
- Property dan Crown menampilkan informasi.
- News, Reward, Transport, dan Jail menjalankan stub sesuai batas.
- Stub tidak mengubah state yang dilarang.

### Triple Double
- Double Counter bekerja sesuai aturan.
- Double ketiga langsung mengirim pemain ke Jail.
- Tidak ada Movement atau Landing Resolution dari Double ketiga.
- Turn berakhir dengan benar.

### Recovery dan Disconnect
- Reset/Death tidak menghilangkan Roll Result yang valid.
- Movement dapat dilanjutkan ke destination yang sama.
- Reward dan Landing Resolution tidak terduplikasi.
- Disconnect tidak membuat Turn Controller macet.
- Last Player Standing menghasilkan Game State ENDED.
- Tidak ada pemain aktif menghasilkan Game State ABORTED.

## 6. Codex Implementation Guardrails

Codex hanya boleh mengimplementasikan fitur yang secara eksplisit tercantum dalam Prototype Scope ini.

**Allowed**
- Membuat struktur script dan module yang diperlukan.
- Mengimplementasikan sistem yang masuk scope.
- Membuat konfigurasi dan data structure minimum.
- Membuat UI sederhana untuk kebutuhan pengujian.
- Membuat logging dan debug output.
- Menambahkan validasi internal untuk menjaga konsistensi state.
- Memperbaiki bug yang berkaitan langsung dengan scope.

**Prohibited**
- Membuat sistem lengkap hanya karena sistem tersebut disebut dalam Master Flow.
- Mengimplementasikan fitur Out of Scope.
- Membuat mekanik gameplay baru atau mengubah aturan yang sudah dikunci.
- Mengganti Physical Dice dengan simulasi angka.
- Menggunakan client sebagai sumber kebenaran gameplay.
- Menambahkan dependency atau framework besar tanpa persetujuan.
- Melakukan refactor luas yang tidak diperlukan untuk scope.
- Menganggap stub sebagai izin untuk membangun sistem lengkap.

**Stop-and-Ask Rule**

Codex wajib berhenti dan meminta keputusan apabila implementasi membutuhkan aturan gameplay yang belum ditentukan, terdapat konflik antar-dokumen, dibutuhkan fitur di luar scope, ada keputusan arsitektur berdampak luas, atau implementasi berpotensi mengubah keputusan LOCKED. Codex tidak boleh menyelesaikan ketidakjelasan dengan asumsi sendiri.

## 7. Definition of Done
- Seluruh Acceptance Criteria telah diuji.
- Pengujian dilakukan menggunakan Roblox Studio Server + 4 Clients.
- Hasil pengujian memiliki bukti yang dapat diperiksa.
- Tidak ada blocker kritis yang belum diselesaikan.
- Tidak ada fitur di luar scope yang ikut terimplementasi.
- Progress dan hasil pengujian dicatat dalam Development Log.
- Perubahan kode dan dokumentasi memiliki commit yang sesuai.

Status Implemented dan Tested harus dibedakan. Kode yang selesai dibuat belum otomatis dianggap berhasil diuji.

## 8. Open Items for Specification Stage
Hal berikut belum menjadi keputusan implementasi detail dan harus dibahas pada tahap Specification:
- Struktur data runtime untuk Match, Player, Turn, dan Resolution State.
- Kontrak API antar-Module dan Service.
- State transition dan validasi setiap fase Turn Controller.
- Detail teknis server-side Physical Dice dan Raycast.
- Mekanisme sinkronisasi posisi karakter dan tile.
- Idempotency key atau mekanisme setara untuk mencegah eksekusi ganda.
- Detail pemulihan Movement setelah Reset/Death.
- Detail aman untuk menghentikan Resolution saat Disconnect.
- Mekanisme pengujian dan logging.
- Struktur folder dan penempatan script final sesuai arsitektur proyek.

Open Items tidak boleh diisi dengan asumsi saat implementasi dimulai.

## 9. Approval Gate
Dokumen ini telah disetujui dan berstatus **LOCKED** sebagai batas implementasi Core Gameplay Prototype v1.0.

Tahap berikutnya:
1. Planning Stage dievaluasi untuk diselesaikan.
2. Development berlanjut ke Specification Stage.
3. Detail teknis disusun sebelum Review & Approval.
4. Implementasi baru dimulai setelah workflow gate terpenuhi.
