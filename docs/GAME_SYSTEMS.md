# Relopoli — Game Systems Directory

Dokumen ini adalah peta navigasi sistem. Gunakan dokumen sumber yang ditautkan untuk aturan lengkap. Jangan menyalin atau mengubah aturan mekanik hanya dari ringkasan ini.

## 1. Orchestration dan aturan global

| Sistem / topik | Dokumen utama | Cakupan |
|---|---|---|
| Master gameplay rules | [Master Source of Truth](MASTER_SOURCE_OF_TRUTH.md) | Aturan final lintas sistem dan source hierarchy |
| Turn Flow | [Progress 19 — Master Flow](progress/PROGRESS_19_MASTER_FLOW.md) | Turn Controller, Resolution Chain, Turn End, integrasi sistem |
| Exploit dan edge case | [Progress 20 — Edge Case & Exploit Audit](audit/PROGRESS_20_EDGE_CASE_EXPLOIT_AUDIT.md) | Validasi, race condition, disconnect, duplicate request, hardening |
| Architecture decisions | [Architecture Decision Log](ARCHITECTURE_REVIEW_DECISIONS.md) | Kontrak arsitektur yang disetujui, Decisions 1–79 |
| Architecture validation | [Consolidation Review](ARCHITECTURE_CONSOLIDATION_REVIEW.md) | Feasibility, dependency order, acceptance test |

## 2. Gameplay systems

| Sistem | Dokumen detail |
|---|---|
| Reward / Start | [Progress 02 — Reward](systems/PROGRESS_02_REWARD.md), [Progress 04 — Start](systems/PROGRESS_04_START.md) |
| Transport | [Progress 03 — Transport](systems/PROGRESS_03_TRANSPORT.md) |
| Movement | [Progress 05 — Movement](systems/PROGRESS_05_MOVEMENT.md) |
| Roll dan Dice | [Progress 06 — Roll](systems/PROGRESS_06_ROLL.md) |
| Economy dan Bankruptcy | [Progress 07 — Economy](systems/PROGRESS_07_ECONOMY.md) |
| Property | [Progress 08 — Property](systems/PROGRESS_08_PROPERTY.md), [Property Catalog Reference](../design/PROPERTY_CATALOG_REFERENCE.md) |
| Jail | [Progress 09 — Jail](systems/PROGRESS_09_JAIL.md) |
| News | [Progress 17 — News](systems/PROGRESS_17_NEWS.md) |
| Crown | [Progress 18 — Crown](systems/PROGRESS_18_CROWN.md) |
| Trade | [Progress 15 — Trade](systems/PROGRESS_15_TRADE.md) |
| Transaction | [Progress 16 — Transaction](systems/PROGRESS_16_TRANSACTION.md) |

Dokumen historis tambahan: [Progress 01 — Economy & Property History](systems/PROGRESS_01_ECONOMY_AND_PROPERTY_HISTORY.md).

## 3. UI dan player experience

| Area | Dokumen detail |
|---|---|
| Ownership visual | [Progress 12 — Ownership Visual](ui/PROGRESS_12_OWNERSHIP_VISUAL.md) |
| Player Screen | [Progress 13 — Player Screen](ui/PROGRESS_13_PLAYER_SCREEN.md) |
| Assets Panel | [Progress 14 — Assets Panel](ui/PROGRESS_14_ASSETS_PANEL.md) |
| Settings | [Settings UI](ui/SETTINGS_UI.md) |

News UI Flow juga memiliki dokumen sumber tersendiri dan harus dibaca bersama aturan News pada Master Source of Truth.

## 4. Aturan dependency penting

- Turn Controller mengatur urutan dan kelanjutan giliran.
- Movement Engine digunakan oleh perpindahan normal maupun perpindahan khusus yang ditentukan aturan.
- Landing Resolution memproses tile berdasarkan posisi resmi server.
- Domain systems menghitung mekanik dan mengajukan hasil; mutation pipeline menjaga state.
- Victory Check dan Game-End gate berlaku setelah perubahan state yang relevan.
- Trade dan Transaction tetap mengikuti validasi final terhadap state dan ownership terbaru.

## 5. Cara membaca dokumen sistem

1. Mulai dari [Game Design](GAME_DESIGN.md) untuk gambaran produk.
2. Baca bagian sistem di tabel sesuai fitur yang sedang dikerjakan.
3. Periksa [Master Flow](progress/PROGRESS_19_MASTER_FLOW.md) untuk integrasi lintas sistem.
4. Periksa [Edge Case Audit](audit/PROGRESS_20_EDGE_CASE_EXPLOIT_AUDIT.md) sebelum menyatakan alur aman.
5. Periksa Architecture Decision Log dan Consolidation Review sebelum mengubah kontrak teknis.

Jika ringkasan ini berbeda dengan dokumen kanonis, ikuti source hierarchy di Master Source of Truth.
