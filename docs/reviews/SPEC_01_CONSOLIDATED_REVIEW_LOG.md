# Specification 01 — Consolidated Review Log

**Repository:** `Fajriansyah21/Relopoli`  
**Specification:** [Turn Controller & Resolution Chain](../specifications/SPEC_01_TURN_CONTROLLER_RESOLUTION_CHAIN.md)  
**Review scope:** TC-01 through TC-60 only  
**Review status:** In progress  
**Approved findings:** #1 through #5  
**Specification status:** DRAFT  
**Implementation status:** Not Implemented / Not Tested

Dokumen ini menjadi catatan keputusan selama Consolidated Review Specification 01. Tujuannya menjaga kesinambungan pembahasan, mencegah keputusan yang sudah disetujui hilang atau berubah makna, dan membedakan keputusan desain dari perubahan dokumentasi maupun implementasi.

## Review Guardrails

1. Review dibatasi pada kontrak TC-01 sampai TC-60 yang sudah ada.
2. Tidak menambahkan TC-61 atau decision ID baru selama review ini.
3. Persetujuan suatu finding berarti arah penyelesaian desainnya disetujui, bukan berarti implementasi sudah dilakukan atau diuji.
4. Perubahan pada dokumen LOCKED yang terdampak tetap harus mengikuti proses revisi dan approval dokumen tersebut.
5. Specification 01 tetap berstatus DRAFT sampai seluruh consolidated review selesai dan ada approval final secara eksplisit.
6. Jangan memulai implementasi berdasarkan Specification 01 sebelum status dan approval finalnya ditetapkan.

## Approved Findings

### Finding #1 — Turn Identity vs Turn Activation

**Status:** Approved

**Kontrak terkait:** TC-13A, TC-51, TC-56, TC-58, TC-59

**Keputusan yang disetujui:**

Pisahkan tiga konsep yang sebelumnya berpotensi tercampur:

1. **Turn Selection & Identity Creation:** Turn Controller memilih pemain yang eligible dan membuat TurnID serta ParentTurnChainID. Pembuatan identitas belum berarti Turn aktif.
2. **Turn Initialization:** proses inisialisasi wajib dijalankan dan diverifikasi. Sebelum aktivasi, pemain belum memiliki hak melakukan aksi gameplay untuk Turn tersebut.
3. **Turn Activation:** Turn baru aktif setelah seluruh Initialization berhasil dan diverifikasi.

Jika Initialization gagal, identitas Turn tetap tersedia untuk diagnosis, tetapi Turn tidak menjadi aktif. Parent Turn Chain menjadi FAILED dan tidak ada perpindahan otomatis ke pemain berikutnya.

Identitas Turn, otorisasi pemain, dan hak gameplay adalah konsep yang berbeda dan tidak boleh dianggap saling menyiratkan.

**Catatan penerapan:** Penyelarasan lintas kontrak terkait perlu diperiksa saat finalisasi Specification 01. Jangan mengubah aturan identitas atau aktivasi secara diam-diam.

### Finding #2 — Turn Initialization Atomicity vs Partial State Persistence

**Status:** Approved

**Kontrak terkait:** TC-04A, TC-09A, TC-13A, TC-58, TC-59

**Keputusan yang disetujui:**

1. Setiap Initialization Operation diproses secara individual dan harus atomic pada batas operasinya.
2. Turn Activation hanya boleh terjadi setelah seluruh Initialization Operation wajib berhasil dan diverifikasi.
3. Jika terjadi kegagalan parsial, perubahan dari operasi yang sudah berhasil tetap dipertahankan.
4. Operasi yang sudah berhasil tidak diulang otomatis.
5. Parent Turn Chain menjadi FAILED; Turn tetap tidak aktif dan tidak ada perpindahan otomatis ke pemain berikutnya.
6. Recovery hanya boleh dilakukan setelah state diverifikasi dan prosedur pemulihan dinyatakan aman.

**Batas keputusan:** Ini tidak berarti seluruh Initialization harus menjadi satu transaksi database atomik. Mekanisme storage, rollback, retry, dan recovery teknis tetap TBD.

### Finding #3 — Match Termination vs Prototype Scope v1.0

**Status:** Approved with documentation prerequisite

**Kontrak terkait:** TC-03A, TC-25, TC-31  
**Dokumen terdampak:** [Core Gameplay Prototype Scope v1.0](../CORE_GAMEPLAY_PROTOTYPE_SCOPE.md)

**Keputusan yang disetujui:**

1. Arah keputusan TC-31 dipertahankan: Game State hanya RUNNING atau ENDED.
2. Jika tidak ada pemain aktif tersisa, Match berakhir dengan Game State ENDED dan tanpa pemenang.
3. Prototype Scope v1.0 saat ini masih menyebut ABORTED untuk kondisi nol pemain aktif.
4. Karena Prototype Scope v1.0 berstatus LOCKED, perubahan tersebut tidak boleh diterapkan secara diam-diam.

**Prasyarat:** Prototype Scope v1.0 dan dokumen terkait harus direvisi melalui workflow dokumentasi dan memperoleh approval resmi sebelum perubahan ini diterapkan atau dijadikan dasar implementasi. Sampai prasyarat tersebut terpenuhi, konflik dokumentasi ini tetap terbuka sebagai dependency.

### Finding #4 — Turn Activation vs News Phase Transition

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-13A, TC-59, TC-60

**Keputusan yang disetujui:**

- **TC-59** hanya mengatur keberhasilan Turn Activation, status Turn aktif, hak gameplay pemain, dan kegagalan aktivasi.
- **TC-60** menjadi satu-satunya kontrak yang mengatur transisi Turn Activation menuju News Phase.
- Turn Controller tetap menjadi pihak yang mengeksekusi transisi tersebut.
- News Phase hanya dimulai satu kali, setelah Turn berhasil diaktifkan.
- Perlindungan terhadap transisi duplikat dan kegagalan transisi tetap menjadi bagian dari TC-60.

**Perubahan dokumentasi:** TC-59 poin 6 dan TC-60 poin 4 telah diselaraskan dalam Specification 01. Perubahan dicatat pada commit `90c79b16d1629f266f31be5706ba40ee0f0b4133`.

### Finding #5 — Turn Identity, Initialization, and Activation Alignment

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-12A, TC-13A, TC-14A, TC-51, TC-56, TC-59, TC-60

**Keputusan yang disetujui:**

1. TurnID dan ParentTurnChainID dibuat setelah pemain ditentukan, sebelum Turn Initialization. Pembuatan identitas tidak berarti Turn telah aktif atau Initialization telah berhasil.
2. Setelah pemeriksaan otorisasi Turn Start sesuai TC-56 berhasil, Turn Controller mencatat pemain terpilih sebagai pemilik Turn yang sedang dipersiapkan. Penetapan ini tidak mengaktifkan Turn dan tidak memberikan hak gameplay.
3. Turn Initialization dilakukan sebelum Turn Activation. Setelah seluruh Initialization berhasil dan diverifikasi, Turn dapat diaktifkan sesuai TC-59.
4. News Phase hanya dimulai melalui transisi TC-60 setelah Turn berhasil diaktifkan.
5. TC-51 mencatat lifecycle identitas Turn sejak identitas ditetapkan, bukan sejak Initialization berhasil.

**Perubahan dokumentasi:** TC-13A, TC-14A, dan TC-51 poin 2 telah diselaraskan dalam Specification 01. TC-59 tetap menjadi kontrak Turn Activation dan TC-60 tetap menjadi satu-satunya kontrak transisi menuju News Phase.

## Review Progress

| Finding | Topic | Decision | Documentation note |
|---|---|---|---|
| #1 | Turn Identity vs Turn Activation | Approved | Cross-contract alignment to be checked during consolidation |
| #2 | Initialization Atomicity vs Partial State Persistence | Approved | Technical storage/recovery details remain TBD |
| #3 | Match Termination vs Prototype Scope | Approved with prerequisite | Locked Prototype Scope revision and approval required |
| #4 | Turn Activation vs News Phase Transition | Approved | TC-59 and TC-60 updated |
| #5 | Turn Identity, Initialization, and Activation Alignment | Approved | TC-13A, TC-14A, and TC-51 updated |

**Next step:** Continue consolidated review with Finding #6, using the current GitHub version of Specification 01, Master Source of Truth, Prototype Scope, and Progress 20 as source documents. Do not introduce new decision IDs.
