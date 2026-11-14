# Relopoli — Development Workflow

**Status: LOCKED WORKFLOW v1.0**  
**Approved:** 2026-11-14

Dokumen ini menetapkan alur standar untuk merancang, mendokumentasikan, mengimplementasikan, dan menguji Relopoli. Workflow ini mengatur cara kerja proyek, bukan menggantikan gameplay rules atau architecture decisions.

## Prinsip kerja

1. GitHub repository `Fajriansyah21/Relopoli` pada branch `main` menjadi sumber dokumentasi proyek yang dapat ditelusuri.
2. Dokumen kanonis dan keputusan berstatus LOCKED tidak boleh diubah diam-diam.
3. Perubahan terhadap aturan LOCKED harus dibahas, disetujui, lalu dicatat sebelum implementasi yang bergantung padanya.
4. Kerjakan satu fitur atau lingkup yang jelas pada satu waktu.
5. Bedakan status rancangan, implementasi, dan hasil pengujian. Dokumen yang lengkap bukan bukti bahwa kode sudah berjalan.
6. Setiap perubahan penting harus memiliki jejak commit dan catatan progres.
7. Jangan melewati blocker penting atau menyatakan tahap selesai tanpa memenuhi exit criteria.

## Enam tahap standar

### 1. Planning

**Tujuan:** menentukan pekerjaan yang akan dilakukan dan batas lingkupnya.

Aktivitas:
- Menentukan fitur, sistem, UI, map area, atau technical task.
- Menetapkan tujuan, scope, dependency, dan hasil yang diharapkan.
- Mengidentifikasi dokumen sumber yang relevan.
- Mencatat risiko dan blocker awal.

**Output:** scope pekerjaan yang jelas dan daftar sumber acuan.

**Exit criteria:** pekerjaan cukup spesifik untuk dianalisis; dependency dan batas lingkup diketahui.

### 2. Specification

**Tujuan:** menyusun rancangan sebelum implementasi.

Aktivitas:
- Membaca dokumen kanonis dan spesifikasi terkait.
- Merinci flow, state, aturan, UI behavior, data, server/client boundary, dan failure cases yang relevan.
- Memeriksa konsistensi dengan Master Source of Truth, Master Flow, Edge Case Audit, serta Architecture Decision Log.
- Menandai informasi yang belum ditetapkan sebagai TBD, bukan mengisinya dengan asumsi.

**Output:** spesifikasi fitur atau perubahan yang dapat direview.

**Exit criteria:** behavior, batas sistem, dependency, dan hal yang belum diketahui tertulis jelas.

### 3. Review & Approval

**Tujuan:** memastikan rancangan dipahami dan disetujui sebelum dikunci.

Aktivitas:
- Meninjau kelengkapan, konsistensi, edge cases, exploit/race conditions, dan dampak lintas sistem.
- Membahas proposal penting satu per satu agar keputusan dan alasannya mudah ditelusuri.
- Memisahkan fakta sumber, rekomendasi, asumsi, dan pertanyaan terbuka.
- Meminta persetujuan eksplisit untuk keputusan yang mengubah atau menambah kontrak penting.

**Output:** rancangan yang disetujui, revisi yang diminta, atau daftar pertanyaan terbuka.

**Exit criteria:** keputusan yang diperlukan sudah disetujui; item yang belum disetujui tidak diperlakukan sebagai LOCKED.

### 4. Documentation

**Tujuan:** mencatat hasil yang disetujui ke repository.

Aktivitas:
- Memperbarui dokumen kanonis yang tepat, bukan membuat salinan aturan tanpa kebutuhan.
- Memperbarui indeks, Development Log, dan Changelog bila relevan.
- Mempertahankan dokumen historis dan menandai supersession bila aturan diganti.
- Memverifikasi hasil commit dan tautan antar dokumen.

**Output:** dokumentasi GitHub yang sinkron dan dapat ditelusuri.

**Exit criteria:** perubahan tersimpan di GitHub, file terkait diverifikasi, dan status dokumentasi jelas.

### 5. Implementation

**Tujuan:** mengubah spesifikasi yang sudah disetujui menjadi project Roblox yang berjalan.

Aktivitas:
- Menyiapkan atau memperbarui script, module, config, Remote contract, UI, dan asset pada folder yang sesuai.
- Menjaga server authority, validasi input, mutation boundaries, dan ownership tanggung jawab sistem.
- Mengimplementasikan dalam unit kecil yang bisa diperiksa.
- Mencatat file, dependency, dan perubahan yang dibuat.
- Tidak menganggap code generation atau code review sebagai bukti runtime correctness.

**Output:** implementasi yang siap diuji di Roblox Studio.

**Exit criteria:** pekerjaan implementasi selesai untuk scope yang ditentukan, dapat dibuka/dijalankan pada environment target, dan tidak memiliki blocker implementasi yang diketahui.

### 6. Testing & Validation

**Tujuan:** membuktikan implementasi memenuhi spesifikasi dan tetap aman pada kondisi normal maupun gagal.

Aktivitas:
- Menjalankan test cases di Roblox Studio dan environment yang relevan.
- Menguji normal flow, boundary values, invalid requests, concurrency/race conditions, duplicate requests, disconnects, retries, dan failure recovery sesuai risiko fitur.
- Memeriksa log, state akhir, side effects, dan bukti hasil.
- Memperbaiki temuan lalu mengulang pengujian yang terdampak.
- Memperbarui status Development Log berdasarkan bukti aktual.

**Output:** hasil pengujian, daftar defect, bukti validasi, dan status fitur.

**Exit criteria:** acceptance criteria scope tersebut lulus; defect yang tersisa dicatat dan disetujui sebagai known issue atau blocker.

## Status pekerjaan

Gunakan status secara konsisten:

| Status | Arti |
|---|---|
| Draft | Masih berupa ide atau rancangan awal |
| Review | Sedang diperiksa dan belum disetujui final |
| Locked | Keputusan/rancangan disetujui sebagai acuan |
| In Progress | Implementasi sedang berlangsung |
| Implemented | Kode/asset sudah dibuat, belum otomatis berarti lulus test |
| Tested | Acceptance criteria yang ditentukan telah diuji dan lulus |
| Blocked | Tidak dapat dilanjutkan karena dependency, keputusan, atau defect penting |

Status LOCKED berlaku untuk keputusan atau spesifikasi. Status Implemented dan Tested berlaku untuk hasil pengerjaan. Jangan mencampur ketiganya.

## Peran AI dan developer

- **ChatGPT:** partner berpikir untuk planning, analisis sumber, specification, review, dokumentasi, dan pemeriksaan konsistensi.
- **Codex / coding assistant:** membantu membaca repository, menulis atau mengubah kode, melakukan refactor, dan membantu debugging sesuai instruksi.
- **Developer:** pemilik keputusan produk, pemberi approval, pengelola Roblox Studio, dan pihak yang menjalankan atau mengonfirmasi pengujian pada environment target.

AI tidak boleh mengklaim bahwa implementasi atau test berhasil tanpa bukti yang benar-benar tersedia.

## Aturan perubahan dan pelaporan

Untuk setiap lingkup kerja, catat setidaknya:
- nama fitur atau task;
- tahap workflow saat ini;
- dokumen sumber dan file yang berubah;
- keputusan/approval yang relevan;
- commit GitHub;
- hasil implementasi dan test bila sudah ada;
- blocker, known issues, dan next step.

Jika pengujian belum dilakukan, tulis **Not Tested**. Jika kemampuan platform atau primitive teknis belum dibuktikan, tulis **Unverified** dan buat prototype/validation task.

## Template ringkas task

```text
Task:
Scope:
Current Stage: Planning / Specification / Review / Documentation / Implementation / Testing
Source Documents:
Approved Decisions:
Expected Output:
Acceptance Criteria:
Implementation Evidence:
Test Evidence:
Status:
Blockers / Known Issues:
Next Step:
```

## Hubungan dengan dokumen lain

- [Game Design](GAME_DESIGN.md): gambaran produk dan gameplay.
- [Game Systems](GAME_SYSTEMS.md): indeks spesifikasi sistem.
- [Map Design](MAP_DESIGN.md): rancangan board dan dunia.
- [Development Log](DEVELOPMENT_LOG.md): progres dan status pekerjaan.
- [Master Source of Truth](MASTER_SOURCE_OF_TRUTH.md): aturan gameplay kanonis.
- [Architecture Index](ARCHITECTURE_INDEX.md): keputusan dan review arsitektur.

Perubahan workflow ini sendiri harus direview dan disetujui sebelum versi berikutnya menggantikan v1.0.
