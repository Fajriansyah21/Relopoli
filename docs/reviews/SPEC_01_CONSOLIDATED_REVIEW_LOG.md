# Specification 01 — Consolidated Review Log

**Repository:** `Fajriansyah21/Relopoli`  
**Specification:** [Turn Controller & Resolution Chain](../specifications/SPEC_01_TURN_CONTROLLER_RESOLUTION_CHAIN.md)  
**Review scope:** TC-01 through TC-60 only  
**Review status:** In progress  
**Approved findings:** #1 through #11  
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



### Finding #6 — Turn Start Authorization vs Turn Ownership

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-13A, TC-56, TC-59

**Keputusan yang disetujui:**

1. Pemeriksaan otorisasi Turn Start diselesaikan sebelum pemain dicatat sebagai pemilik Turn yang sedang dipersiapkan.
2. Penetapan pemain sebagai pemilik Turn yang sedang dipersiapkan tidak berarti Turn telah aktif dan tidak memberikan hak gameplay.
3. Turn Initialization tetap dilakukan sebelum Turn Activation.
4. Turn baru aktif setelah seluruh Initialization wajib berhasil dan diverifikasi sesuai TC-59.
5. News Phase hanya dimulai melalui transisi TC-60 setelah Turn berhasil diaktifkan.

**Perubahan dokumentasi:** TC-56 poin 6 diselaraskan dengan TC-13A, TC-59, dan TC-60. Tidak ada decision ID baru yang ditambahkan.


### Finding #7 — Duplicate Turn Start vs Prepared Turn Lifecycle

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-13A, TC-56, TC-57, TC-58, TC-59

**Keputusan yang disetujui:**

1. Satu giliran hanya memiliki satu proses Turn Start yang sah.
2. Sebelum menerima proses Turn Start baru, Turn Controller wajib memvalidasi apakah masih ada proses Turn Start atau Turn yang sedang dipersiapkan, menjalani Initialization, telah aktif, atau telah selesai untuk identitas Turn terkait.
3. Permintaan Turn Start duplikat tidak membuat TurnID atau ParentTurnChainID tambahan.
4. Initialization hanya boleh berhasil satu kali untuk setiap Turn.
5. Reset Double Counter dan Initialization lainnya tidak boleh diulang akibat permintaan duplikat.
6. Turn Start yang berhasil tidak boleh diaktifkan kembali.
7. Permintaan dari Chain atau Match yang tidak berlaku ditolak tanpa side effect.
8. Jika status proses sebelumnya tidak dapat dipastikan, proses tidak boleh diulang berdasarkan asumsi. Chain menjadi FAILED jika keamanan State tidak dapat diverifikasi.
9. Mekanisme teknis pencegahan duplikasi tetap TBD.

**Perubahan dokumentasi:** TC-57 poin 2 diperjelas untuk mencakup proses Turn Start dan Turn yang masih dipersiapkan, sedang menjalani Initialization, telah aktif, maupun telah selesai. Tidak ada decision ID baru yang ditambahkan.

### Finding #8 — Player Eligibility vs Disconnect and Turn Handoff

**Status:** Approved and incorporated into Specification 01, with Prototype Scope documentation prerequisite

**Kontrak terkait:** TC-24, TC-26, TC-28, TC-32, TC-33, TC-54, TC-55, TC-56

**Keputusan yang disetujui:**

1. Turn Controller menggunakan state authoritative server terbaru untuk memvalidasi kelayakan pemain, baik saat seleksi maupun tepat sebelum otorisasi Turn Start.
2. Pemain yang menjadi tidak eligible sebelum otorisasi tidak dicatat sebagai pemilik Turn yang sedang dipersiapkan dan tidak menjalani Initialization; Turn Controller melewatinya dan memvalidasi pemain berikutnya menurut urutan awal.
3. Eliminasi atau disconnect tidak mengacak atau membangun ulang urutan awal roster. Pemain yang tidak eligible dilewati.
4. Disconnect pemain nonaktif diproses terpisah dan tidak menghentikan atau me-reset Parent Turn Chain pemain aktif.
5. Jika kelayakan pemain atau integritas roster tidak dapat diverifikasi, Turn baru tidak dipaksakan dan kegagalan ditangani sesuai kontrak.
6. Rejoin tidak memulihkan status aktif atau hak gameplay secara otomatis.
7. Konflik Prototype Scope v1.0 bagian 2.10 yang menyebut Turn Order dibangun kembali berdasarkan pemain aktif harus diselesaikan melalui workflow revisi dokumen LOCKED dan approval resmi. Prototype Scope tidak diubah sebagai bagian dari Finding #8.

**Perubahan dokumentasi:** TC-32, TC-55, dan TC-56 diselaraskan untuk menegaskan urutan roster awal, validasi ulang menggunakan state authoritative terbaru, dan penanganan pemain yang menjadi tidak eligible sebelum otorisasi. TC-26 dan TC-54 tetap menjadi dasar perlindungan Chain aktif serta integritas roster. Tidak ada decision ID baru yang ditambahkan.

### Finding #9 — Turn Completion Commit Boundary vs Late/Concurrent Result

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-23, TC-24, TC-25, TC-29, TC-30, TC-51, TC-56, TC-57

**Keputusan yang disetujui:**

1. Pemeriksaan hasil terminal dan penyelesaian Turn mengikuti sequencing server berdasarkan state authoritative terbaru.
2. Result Priority tetap GAME_END > PLAYER_ELIMINATED > TURN_END > EXTRA_ROLL > CONTINUE.
3. Hasil terminal dengan prioritas lebih tinggi yang berlaku sebelum Parent Turn Chain ditetapkan COMPLETED mengalahkan handoff normal.
4. Setelah Parent Turn Chain ditetapkan COMPLETED, hasil atau respons terlambat maupun duplikat dari Chain tersebut ditolak tanpa side effect; Chain tidak dibuka kembali.
5. Handoff normal hanya dilakukan setelah Chain sebelumnya benar-benar COMPLETED. Pemain berikutnya harus divalidasi sesuai TC-55 dan otorisasi Turn Start mengikuti TC-56.
6. Tidak ada Chain lama yang dibuka kembali atau Turn baru yang dibuat akibat hasil duplikat.

**Perubahan dokumentasi:** TC-23 diperjelas untuk menetapkan batas penyelesaian Parent Turn Chain dan prasyarat handoff. TC-30 diperjelas untuk menyelaraskan arbitration event dengan penetapan COMPLETED dan penolakan event setelah Chain ditutup. Tidak ada decision ID baru yang ditambahkan.

**Batas teknis:** Database transaction, queue, retry, dan mekanisme teknis sequencing tetap TBD.

### Finding #10 — Turn Identity Creation vs Turn Start Authorization

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-12A, TC-13A, TC-23, TC-51, TC-56, TC-57

**Keputusan yang disetujui:**

1. Parent Turn Chain sebelumnya harus ditetapkan COMPLETED sebelum handoff normal.
2. Turn Controller memilih kandidat berikutnya sesuai urutan match dan memvalidasi eligibility sesuai TC-55.
3. Setelah kandidat dipilih, Turn Controller membuat TurnID dan ParentTurnChainID untuk Turn yang sedang dipersiapkan sesuai TC-13A dan TC-51.
4. Turn Start authorization sesuai TC-56 dilakukan terhadap identitas Turn yang sedang dipersiapkan, sebelum pemain dicatat sebagai pemilik Turn dan sebelum Turn Initialization.
5. Jika kandidat tidak lagi eligible saat validasi ulang, kandidat tidak dicatat sebagai pemilik Turn dan tidak menjalani Initialization; Turn Controller memeriksa kandidat berikutnya sesuai TC-55.
6. Pembuatan identitas Turn tidak mengaktifkan Turn dan tidak memberikan hak gameplay.
7. Setelah otorisasi berhasil, Turn Initialization berjalan sesuai TC-13A, kemudian Turn Activation mengikuti TC-59 dan transisi News Phase mengikuti TC-60.

**Perubahan dokumentasi:** TC-23 poin 8 diperjelas agar urutan handoff selaras dengan TC-13A, TC-51, dan TC-56. Tidak ada decision ID baru yang ditambahkan.

**Batas teknis:** Detail generator ID, penyimpanan, dan scheduling tetap TBD.
### Finding #11 — Prepared Turn Identity Invalidated When Candidate Becomes Ineligible

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-23, TC-51, TC-55, TC-56

**Keputusan yang disetujui:**

1. Jika kandidat menjadi tidak eligible saat otorisasi Turn Start, kandidat tidak dicatat sebagai pemilik Turn yang sedang dipersiapkan dan tidak menjalani Turn Initialization.
2. TurnID dan Parent Turn Chain identity yang telah dibuat untuk kandidat tersebut tidak berlaku untuk memulai Turn.
3. Identitas tersebut tidak boleh diaktifkan, menjalankan Resolution, atau digunakan kembali.
4. Kondisi ini merupakan hasil validasi eligibility, bukan kegagalan teknis, sehingga tidak otomatis membuat Chain berstatus FAILED.
5. Turn Controller melanjutkan pemeriksaan kandidat berikutnya sesuai TC-55 dan membuat identitas baru untuk kandidat berikutnya.
6. Detail representasi, pencatatan, dan penyimpanan identitas yang tidak digunakan tetap TBD.

**Perubahan dokumentasi:** TC-23 poin 8 dan TC-51 telah diperjelas untuk menetapkan lifecycle identitas Turn yang dibuat bagi kandidat yang kemudian tidak eligible. Tidak ada decision ID baru yang ditambahkan.

**Batas teknis:** Representasi dan persistence identitas yang tidak digunakan tetap TBD.

## Review Progress

| Finding | Topic | Decision | Documentation note |
|---|---|---|---|
| #1 | Turn Identity vs Turn Activation | Approved | Cross-contract alignment to be checked during consolidation |
| #2 | Initialization Atomicity vs Partial State Persistence | Approved | Technical storage/recovery details remain TBD |
| #3 | Match Termination vs Prototype Scope | Approved with prerequisite | Locked Prototype Scope revision and approval required |
| #4 | Turn Activation vs News Phase Transition | Approved | TC-59 and TC-60 updated |
| #5 | Turn Identity, Initialization, and Activation Alignment | Approved | TC-13A, TC-14A, and TC-51 updated |
| #6 | Turn Start Authorization vs Turn Ownership | Approved | TC-56 point 6 updated |
| #7 | Duplicate Turn Start vs Prepared Turn Lifecycle | Approved | TC-57 point 2 updated |
| #8 | Player Eligibility vs Disconnect and Turn Handoff | Approved with documentation prerequisite | TC-32, TC-55, and TC-56 updated; Prototype Scope v1.0 revision remains pending |
| #9 | Turn Completion Commit Boundary vs Late/Concurrent Result | Approved | TC-23 and TC-30 updated; technical sequencing details remain TBD |
| #10 | Turn Identity Creation vs Turn Start Authorization | Approved | TC-23 point 8 aligned with TC-13A, TC-51, and TC-56 |
| #11 | Prepared Turn Identity Invalidated When Candidate Becomes Ineligible | Approved | TC-23 point 8 and TC-51 clarified; identity cannot be reused |

**Next step:** Continue consolidated review with Finding #12, using the current GitHub version of Specification 01 and relevant canonical source documents. Do not introduce new decision IDs.
