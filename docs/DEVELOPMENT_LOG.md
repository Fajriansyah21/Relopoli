# Relopoli — Development Log

Dokumen ini adalah indeks progres dan catatan status proyek. Dokumen ini tidak mengubah isi historis progress dan tidak menyatakan fitur sudah terimplementasi hanya karena spesifikasinya tersedia.

## 1. Aturan pencatatan

Setiap update pengembangan sebaiknya mencatat:
- tanggal dan area kerja;
- dokumen atau sistem yang disentuh;
- keputusan baru atau perubahan yang disetujui;
- status: Draft, Review, Locked, In Progress, Implemented, atau Tested;
- bukti implementasi/pengujian jika statusnya Implemented atau Tested;
- risiko, blocker, dan langkah berikutnya.

Keputusan gameplay dan arsitektur tidak boleh diubah diam-diam. Perubahan harus dapat ditelusuri ke dokumen kanonis dan riwayat Git.

## 2. Progress design yang tersedia

| Progress | Area | Dokumen |
|---|---|---|
| 01 | Economy & Property history | [Progress 01](systems/PROGRESS_01_ECONOMY_AND_PROPERTY_HISTORY.md) |
| 02 | Reward | [Progress 02](systems/PROGRESS_02_REWARD.md) |
| 03 | Transport | [Progress 03](systems/PROGRESS_03_TRANSPORT.md) |
| 04 | Start | [Progress 04](systems/PROGRESS_04_START.md) |
| 05 | Movement | [Progress 05](systems/PROGRESS_05_MOVEMENT.md) |
| 06 | Roll | [Progress 06](systems/PROGRESS_06_ROLL.md) |
| 07 | Economy | [Progress 07](systems/PROGRESS_07_ECONOMY.md) |
| 08 | Property | [Progress 08](systems/PROGRESS_08_PROPERTY.md) |
| 09 | Jail | [Progress 09](systems/PROGRESS_09_JAIL.md) |
| 10 | Progress 10 source record | [Progress 10](progress/PROGRESS_10.md) |
| 12 | Ownership visual | [Progress 12](ui/PROGRESS_12_OWNERSHIP_VISUAL.md) |
| 13 | Player Screen | [Progress 13](ui/PROGRESS_13_PLAYER_SCREEN.md) |
| 14 | Assets Panel | [Progress 14](ui/PROGRESS_14_ASSETS_PANEL.md) |
| 15 | Trade | [Progress 15](systems/PROGRESS_15_TRADE.md) |
| 16 | Transaction | [Progress 16](systems/PROGRESS_16_TRANSACTION.md) |
| 17 | News | [Progress 17](systems/PROGRESS_17_NEWS.md) |
| 18 | Crown | [Progress 18](systems/PROGRESS_18_CROWN.md) |
| 19 | Master Flow & integration | [Progress 19](progress/PROGRESS_19_MASTER_FLOW.md) |
| 20 | Edge Case & Exploit Audit | [Progress 20](audit/PROGRESS_20_EDGE_CASE_EXPLOIT_AUDIT.md) |

Progress 11 tidak tercantum karena tidak ada dokumen sumber Progress 11 dalam paket dokumentasi yang saat ini tersedia. Jangan mengisi celah tersebut dengan asumsi.

## 3. Architecture review

Architecture review telah menghasilkan **79 keputusan LOCKED** dan menandai RF-01–RF-11 serta CI-01–CI-24 sebagai addressed pada tingkat kontrak dokumentasi.

Pintu masuk:
- [Architecture Index](ARCHITECTURE_INDEX.md)
- [Architecture Review Summary](ARCHITECTURE_REVIEW_SUMMARY.md)
- [Architecture Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md)
- [Architecture Consolidation Review](ARCHITECTURE_CONSOLIDATION_REVIEW.md)

**Implementation readiness: NOT YET.** Prototype Roblox Studio, failure-injection, acceptance tests, dan pengukuran performa masih harus dilakukan. Status desain LOCKED bukan bukti fitur selesai dibuat.

## 4. Current project phase

**Phase: Design consolidation and implementation preparation.**

Fokus berikutnya:
1. Menjaga seluruh spesifikasi gameplay dan UI tetap konsisten dengan Master Source of Truth.
2. Menyelesaikan blockout board dan city layout berdasarkan Map Design.
3. Membuat prototype arsitektur inti di Roblox Studio, dimulai dari State Manager, mutation pipeline, dan Turn Controller sesuai dependency order.
4. Memvalidasi Remote contracts, server authority, dan failure boundaries.
5. Mencatat bukti pengujian sebelum mengubah status fitur menjadi Tested.

## 5. Update log

Tambahkan entri terbaru di bagian paling atas setelah header ini.

### 2026-11-14 — Core Gameplay Prototype Scope v1.0 locked

- Scope Core Gameplay Prototype disetujui dan dikunci sebagai batas implementasi.
- Cakupan meliputi multiplayer empat pemain, board logis 40 tile, Turn Controller, Physical Dice, Movement, Start Reward, Minimal Balance, enam Landing Resolution handlers, Triple Double, Disconnect, dan Reset/Death Recovery.
- Property/Crown dibatasi pada Detection & Display; News/Reward/Transport/Jail menggunakan Temporary Handler/Stub sesuai guardrails.
- Fitur di luar scope dilarang masuk tanpa persetujuan eksplisit.
- Open Items dipindahkan ke Specification Stage; belum ada implementasi yang diklaim selesai.
- Dokumen kanonis: [Core Gameplay Prototype Scope v1.0](CORE_GAMEPLAY_PROTOTYPE_SCOPE.md).

### 2026-11-14 — Documentation structure organized

- Menambahkan empat dokumen navigasi utama: Game Design, Game Systems, Map Design, dan Development Log.
- Menambahkan scaffold folder Roblox source dan asset.
- Mempertahankan dokumen progress, system, UI, visual, audit, dan architecture review lama sebagai sumber detail.
- Tidak ada klaim bahwa folder source sudah berisi implementasi Roblox.

### 2026-11-14 — Development Workflow v1.0 approved

- Workflow enam tahap disetujui: Planning, Specification, Review & Approval, Documentation, Implementation, dan Testing & Validation.
- Menambahkan `docs/WORKFLOW.md` sebagai acuan proses kerja.
- README diarahkan ke workflow agar mudah ditemukan.
- Status implementasi dan testing wajib dipisahkan dari status keputusan/rancangan.
