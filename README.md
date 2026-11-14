# RELOPOLI

Repository utama rancangan dan pengembangan game multiplayer board-game 3D **Relopoli**.

## Mulai di sini

Kalau baru membuka repository ini, ikuti urutan berikut:

1. [Game Design](docs/GAME_DESIGN.md) untuk memahami konsep dan gameplay loop.
2. [Game Systems](docs/GAME_SYSTEMS.md) untuk menemukan spesifikasi setiap sistem.
3. [Map Design](docs/MAP_DESIGN.md) untuk memahami board, distrik, dan visual kota.
4. [Development Log](docs/DEVELOPMENT_LOG.md) untuk melihat progres dan status pekerjaan.
5. [Architecture Index](docs/ARCHITECTURE_INDEX.md) untuk keputusan teknis, validasi, dan aturan dokumentasi.

**Sumber aturan gameplay utama:** [Master Source of Truth](docs/MASTER_SOURCE_OF_TRUTH.md).

## Struktur repository

```text
RELOPOLI/
│
├── docs/
│   ├── GAME_DESIGN.md
│   ├── GAME_SYSTEMS.md
│   ├── MAP_DESIGN.md
│   ├── DEVELOPMENT_LOG.md
│   ├── MASTER_SOURCE_OF_TRUTH.md
│   ├── ARCHITECTURE_INDEX.md
│   ├── ARCHITECTURE_REVIEW_DECISIONS.md
│   ├── ARCHITECTURE_CONSOLIDATION_REVIEW.md
│   ├── ARCHITECTURE_REVIEW_SUMMARY.md
│   ├── systems/
│   ├── progress/
│   ├── ui/
│   ├── visual/
│   └── audit/
│
├── src/
│   ├── ReplicatedStorage/
│   │   ├── Modules/
│   │   ├── Configs/
│   │   └── Remotes/
│   ├── ServerScriptService/
│   │   ├── Services/
│   │   └── Systems/
│   ├── StarterPlayer/
│   │   └── StarterPlayerScripts/
│   └── StarterGui/
│       └── UI/
│
├── assets/
│   ├── Models/
│   ├── Textures/
│   ├── Icons/
│   └── References/
│
├── design/
└── README.md
```

## Fungsi tiap folder

| Folder | Isi |
|---|---|
| `docs/` | Rancangan game, aturan, spesifikasi sistem, UI, visual, audit, dan development log |
| `src/ReplicatedStorage/` | Modul dan konfigurasi shared serta kontrak Remote |
| `src/ServerScriptService/` | Service dan sistem gameplay yang berjalan di server |
| `src/StarterPlayer/` | Input dan presentasi sisi client |
| `src/StarterGui/` | UI client |
| `assets/` | Model, texture, icon, dan referensi visual |
| `design/` | Referensi desain terstruktur seperti katalog Property |

Folder `src/` dan `assets/` saat ini adalah **scaffold**, bukan klaim bahwa implementasi atau asset final sudah tersedia. README kecil di setiap subfolder menjelaskan batas tanggung jawabnya.

## Aturan source of truth

- Gameplay rules mengikuti [Master Source of Truth](docs/MASTER_SOURCE_OF_TRUTH.md) dan dokumen detail sistem yang dirujuknya.
- Turn integration mengikuti [Progress 19 — Master Flow](docs/progress/PROGRESS_19_MASTER_FLOW.md).
- Edge case dan exploit mengikuti [Progress 20 — Audit](docs/audit/PROGRESS_20_EDGE_CASE_EXPLOIT_AUDIT.md).
- Kontrak teknis mengikuti [Architecture Decision Log](docs/ARCHITECTURE_REVIEW_DECISIONS.md).
- Dokumen progress lama dipertahankan sebagai sejarah, bukan otomatis menjadi aturan terbaru.
- Jika ada konflik, ikuti source hierarchy pada Master Source of Truth dan keputusan eksplisit terbaru yang sudah LOCKED.

## Status proyek

**Design consolidation / implementation preparation.** Architecture Decisions 1–79 sudah LOCKED pada tingkat dokumentasi. Roblox Studio prototypes, acceptance tests, failure-injection, dan performance validation masih harus dilakukan. Implementation readiness tetap **NOT YET**.
