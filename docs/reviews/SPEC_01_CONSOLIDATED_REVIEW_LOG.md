# Specification 01 — Consolidated Review Log

**Repository:** `Fajriansyah21/Relopoli`  
**Specification:** [Turn Controller & Resolution Chain](../specifications/SPEC_01_TURN_CONTROLLER_RESOLUTION_CHAIN.md)  
**Review scope:** TC-01 through TC-60 only  
**Review status:** In progress  
**Approved findings:** #1 through #36  
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

**Status:** Approved and incorporated into Prototype Scope v1.0

**Kontrak terkait:** TC-03A, TC-25, TC-31  
**Dokumen terdampak:** [Core Gameplay Prototype Scope v1.0](../CORE_GAMEPLAY_PROTOTYPE_SCOPE.md)

**Keputusan yang disetujui:**

1. Arah keputusan TC-31 dipertahankan: Game State hanya RUNNING atau ENDED.
2. Jika tidak ada pemain aktif tersisa, Match berakhir dengan Game State ENDED dan tanpa pemenang.
3. Prototype Scope v1.0 sebelumnya menyebut ABORTED untuk kondisi nol pemain aktif.
4. Karena Prototype Scope v1.0 berstatus LOCKED, perubahan tersebut tidak boleh diterapkan secara diam-diam.

**Perubahan dokumentasi:** Prototype Scope v1.0 bagian 2.10 dan Acceptance Criteria bagian 5 telah diselaraskan dengan TC-31. Nol pemain aktif menghasilkan Game State ENDED tanpa pemenang; Match Outcome dan alasan berakhir dicatat terpisah. Revisi disetujui secara eksplisit sebelum diterapkan. Dependency dokumentasi Finding #3 selesai.

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

**Status:** Approved and incorporated into Specification 01 and Prototype Scope v1.0

**Kontrak terkait:** TC-24, TC-26, TC-28, TC-32, TC-33, TC-54, TC-55, TC-56

**Keputusan yang disetujui:**

1. Turn Controller menggunakan state authoritative server terbaru untuk memvalidasi kelayakan pemain, baik saat seleksi maupun tepat sebelum otorisasi Turn Start.
2. Pemain yang menjadi tidak eligible sebelum otorisasi tidak dicatat sebagai pemilik Turn yang sedang dipersiapkan dan tidak menjalani Initialization; Turn Controller melewatinya dan memvalidasi pemain berikutnya menurut urutan awal.
3. Eliminasi atau disconnect tidak mengacak atau membangun ulang urutan awal roster. Pemain yang tidak eligible dilewati.
4. Disconnect pemain nonaktif diproses terpisah dan tidak menghentikan atau me-reset Parent Turn Chain pemain aktif.
5. Jika kelayakan pemain atau integritas roster tidak dapat diverifikasi, Turn baru tidak dipaksakan dan kegagalan ditangani sesuai kontrak.
6. Rejoin tidak memulihkan status aktif atau hak gameplay secara otomatis.
7. Konflik Prototype Scope v1.0 bagian 2.10 yang sebelumnya menyebut Turn Order dibangun kembali berdasarkan pemain aktif telah diselesaikan melalui revisi dokumen LOCKED yang disetujui.

**Perubahan dokumentasi:** TC-32, TC-55, dan TC-56 diselaraskan untuk menegaskan urutan roster awal, validasi ulang menggunakan state authoritative terbaru, dan penanganan pemain yang menjadi tidak eligible sebelum otorisasi. TC-26 dan TC-54 tetap menjadi dasar perlindungan Chain aktif serta integritas roster. Tidak ada decision ID baru yang ditambahkan. Prototype Scope v1.0 bagian 2.1 dan 2.10 kini menegaskan urutan awal, skip pemain tidak eligible tanpa membangun ulang roster, dan tidak memulihkan hak gameplay otomatis saat rejoin. Prasyarat dokumentasi Finding #8 selesai.

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

### Finding #12 — Prepared Identity vs Parent Turn Chain Lifecycle

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-04A, TC-06B, TC-13A, TC-51, TC-56

**Keputusan yang disetujui:**

1. TurnID dan ParentTurnChainID dapat dibuat sebelum otorisasi Turn Start selesai.
2. Pembuatan identitas saja belum berarti Parent Turn Chain telah dimulai atau memasuki lifecycle status TC-04A.
3. Jika kandidat menjadi tidak eligible saat otorisasi, identitas terkait dinyatakan tidak berlaku dan tidak memasuki lifecycle Parent Turn Chain karena Chain belum dimulai.
4. Identitas tersebut tidak boleh diaktifkan, menjalankan Resolution, menerima aksi, atau digunakan kembali.
5. Kandidat berikutnya harus menggunakan identitas baru.
6. Kondisi ini bukan kegagalan teknis dan tidak otomatis membuat Chain berstatus FAILED.
7. Detail representasi, pencatatan, dan penyimpanan identitas yang tidak digunakan tetap TBD.

**Perubahan dokumentasi:** TC-04A diperjelas untuk membedakan pembuatan identitas dari dimulainya Parent Turn Chain. TC-51 diperjelas untuk menetapkan bahwa identitas yang tidak berlaku sebelum Chain dimulai tidak memasuki lifecycle status TC-04A. Penomoran TC-51 juga dirapikan. Tidak ada decision ID baru yang ditambahkan.

**Batas teknis:** Representasi dan persistence identitas yang tidak digunakan tetap TBD.

### Finding #13 — Parent Turn Chain Lifecycle During Turn Initialization

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-04A, TC-06B, TC-13A, TC-56, TC-57, TC-58, TC-59

**Keputusan yang disetujui:**

1. Sebelum otorisasi TC-56 berhasil, TurnID dan ParentTurnChainID hanya merupakan identitas Turn yang sedang dipersiapkan; Parent Turn Chain belum memasuki lifecycle.
2. Setelah otorisasi berhasil dan Turn Controller mencatat pemain terpilih sebagai pemilik Turn yang sedang dipersiapkan, Parent Turn Chain resmi dimulai dan memasuki lifecycle.
3. Parent Turn Chain dimulai sebelum Turn Initialization.
4. Status ACTIVE mencakup proses Turn Initialization dan pelaksanaan Resolution normal. Status ACTIVE tidak berarti pemain telah memperoleh hak gameplay.
5. Jika Initialization gagal, Parent Turn Chain menjadi FAILED sesuai TC-58.
6. Turn baru dapat diaktifkan setelah seluruh Initialization berhasil dan diverifikasi sesuai TC-59.
7. Tidak ada status Chain atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-04A memperjelas cakupan status ACTIVE; TC-06B menetapkan titik dimulainya lifecycle Parent Turn Chain; TC-13A mengikat dimulainya Chain pada keberhasilan otorisasi dan pencatatan pemain sebagai pemilik Turn yang dipersiapkan.

**Batas teknis:** Detail implementasi status dan sequencing tetap mengikuti bagian TBD Specification 01.

### Finding #14 — Turn Start Authorization Failure Before Parent Turn Chain Lifecycle

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-04A, TC-13A, TC-51, TC-56, TC-57, TC-58, TC-59

**Keputusan yang disetujui:**

1. Jika kegagalan teknis atau ketidakmampuan memverifikasi state terjadi sebelum otorisasi Turn Start berhasil dan sebelum Parent Turn Chain dimulai, proses Turn Start dinyatakan gagal.
2. Kegagalan sebelum Chain dimulai tidak menetapkan status lifecycle Parent Turn Chain, karena Chain belum memasuki lifecycle.
3. Jika kegagalan terjadi setelah otorisasi berhasil dan Parent Turn Chain resmi dimulai, Chain ditetapkan FAILED.
4. Ketidakpastian pada proses Turn Start sebelum Chain dimulai tidak boleh disamakan dengan kegagalan Chain yang telah memasuki lifecycle.
5. Kegagalan sebelum Chain dimulai tidak boleh mengaktifkan Turn, menjalankan Initialization, atau memberikan hak gameplay.
6. Tidak ada status Chain atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-04A memperjelas perlakuan kegagalan sebelum dan sesudah lifecycle dimulai. TC-51 poin 14, TC-56 poin 8, dan TC-57 poin 8 diselaraskan agar status FAILED hanya diterapkan kepada Parent Turn Chain yang telah memasuki lifecycle.

**Batas teknis:** Representasi status proses Turn Start yang gagal sebelum Chain dimulai tetap TBD; tidak ditambahkan status lifecycle Chain baru.

### Finding #15 — Concurrent Event Arbitration vs Pre-Lifecycle Failure

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-04A, TC-30, TC-56, TC-57

**Keputusan yang disetujui:**

1. Jika urutan atau validitas state tidak dapat dipastikan setelah Parent Turn Chain memasuki lifecycle, Chain menjadi FAILED.
2. Jika ketidakmampuan verifikasi terjadi sebelum Chain dimulai, proses Turn Start dinyatakan gagal tanpa menetapkan status lifecycle Chain.
3. Batas pemberian status FAILED pada TC-30 harus konsisten dengan TC-04A, TC-56, dan TC-57.
4. Tidak ada status Chain atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-30 poin 10 diperjelas untuk membedakan kegagalan verifikasi setelah Parent Turn Chain memasuki lifecycle dari kegagalan proses Turn Start sebelum Chain dimulai.

**Batas teknis:** Detail sequencing, queue, dan arbitration teknis tetap TBD.

### Finding #16 — Turn Activation State Unverifiable vs Chain Failure

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-04A, TC-11A, TC-13A, TC-59, TC-60

**Keputusan yang disetujui:**

1. Jika status aktivasi tidak dapat diverifikasi setelah Parent Turn Chain dimulai, Turn Controller tidak menerima aksi gameplay.
2. Parent Turn Chain ditetapkan FAILED sesuai TC-04A.
3. Turn tidak dianggap aktif dan tidak melanjutkan ke News Phase atau Roll.
4. Tidak ada status Chain atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-59 poin 10 diperjelas untuk menetapkan konsekuensi kegagalan verifikasi status aktivasi setelah Parent Turn Chain memasuki lifecycle.

**Batas teknis:** Detail commit, penyimpanan, dan atomic publication tetap TBD.

### Finding #17 — News Phase Transition State Unverifiable

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-04A, TC-11A, TC-59, TC-60

**Keputusan yang disetujui:**

1. Jika transisi News Phase gagal secara teknis atau status keberhasilannya tidak dapat diverifikasi setelah Parent Turn Chain dimulai, Parent Turn Chain ditetapkan FAILED sesuai TC-04A.
2. Turn Controller tidak mengulang transisi berdasarkan asumsi.
3. Turn Controller tidak menerima aksi gameplay dan tidak melanjutkan ke Roll.
4. Tidak ada status Chain atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-60 poin 8 diperjelas untuk mencakup kegagalan teknis maupun status transisi News Phase yang tidak dapat diverifikasi setelah Parent Turn Chain dimulai.

**Batas teknis:** Detail commit dan mekanisme verifikasi transisi tetap TBD.

### Finding #20 — Active Player Disconnect During Movement

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-17A, TC-18A, TC-24, TC-28, TC-30

**Keputusan yang disetujui:**

1. Jika pemain aktif disconnect ketika Movement berlangsung, server menghentikan Movement secara aman.
2. Posisi karakter dikembalikan atau dipertahankan pada tile terakhir yang telah dikonfirmasi server sebagai posisi authoritative dan aman; posisi animasi atau sementara Client tidak menjadi acuan.
3. Movement yang dihentikan sebelum Movement Complete tidak dianggap selesai.
4. Start Detection, Start Reward, dan Landing Resolution yang belum dimulai dibatalkan.
5. Player Leave/Elimination harus divalidasi terlebih dahulu.
6. Setelah eliminasi tervalidasi, Parent Turn Chain menjadi ABORTED melalui jalur terminal TC-24 dan TC-28.
7. Movement yang sudah dihentikan tidak dijalankan ulang.
8. Global Victory Check menggunakan state authoritative terbaru.
9. Jika Match tetap RUNNING, pemain berikutnya dipilih sesuai urutan awal.
10. Disconnect bukan kegagalan teknis Movement yang otomatis menghasilkan FAILED dan tidak menggunakan Character Reset Recovery TC-27.
11. Tidak ada status Chain atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-17A dan TC-18A diperjelas untuk membedakan disconnect ketika Movement berlangsung dari kegagalan teknis Movement serta membatalkan proses setelah Movement yang belum dimulai. TC-24 dan TC-28 diperluas untuk mengatur penghentian Movement, posisi authoritative yang aman, dan jalur ABORTED setelah eliminasi tervalidasi.

**Batas teknis:** Detail mekanisme penghentian Movement dan penetapan tile terakhir yang aman tetap mengikuti implementasi Movement Engine serta bagian TBD; tidak ditambahkan mekanisme Recovery baru.

### Finding #19 — Active Player Disconnect After Turn Activation but Before News Phase

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-24, TC-28, TC-59, TC-60

**Keputusan yang disetujui:**

1. Jika pemain aktif disconnect setelah Turn Activation berhasil tetapi sebelum News Phase dimulai, Turn Controller menghentikan penerimaan aksi gameplay baru dari pemain tersebut.
2. Server menjalankan Player Leave/Elimination dan memvalidasi status pemain.
3. Setelah eliminasi tervalidasi, Parent Turn Chain ditetapkan ABORTED melalui jalur terminal TC-24 dan TC-28.
4. News Phase dan Roll tidak boleh dimulai.
5. Global Victory Check dijalankan menggunakan state authoritative terbaru.
6. Jika Match tetap RUNNING, Turn Controller memilih pemain berikutnya sesuai urutan awal dan menjalankan prosedur Turn Start normal.
7. Kondisi ini bukan kegagalan teknis Turn Activation atau transisi News Phase dan tidak otomatis menghasilkan FAILED.
8. Tidak ada status Chain atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-28 diperluas untuk mencakup disconnect setelah Turn Activation berhasil tetapi sebelum News Phase dimulai. TC-24 menetapkan penghentian Chain sebagai ABORTED setelah eliminasi tervalidasi. TC-60 menegaskan bahwa News Phase dan Roll tidak dimulai pada kondisi tersebut.

**Batas teknis:** Detail deteksi disconnect, validasi Player Leave/Elimination, dan sequencing transisi tetap mengikuti kontrak terkait serta bagian TBD.

### Finding #18 — Active Player Disconnect During Turn Initialization

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-04A, TC-13A, TC-24, TC-28, TC-30, TC-34, TC-55, TC-58, TC-59

**Keputusan yang disetujui:**

1. Jika pemain disconnect setelah Parent Turn Chain dimulai tetapi sebelum Turn Activation, server menghentikan penerimaan aksi baru dan menjalankan Player Leave/Elimination.
2. Setelah Player Leave/Elimination tervalidasi, Parent Turn Chain menjadi ABORTED melalui jalur terminal TC-24 dan TC-28.
3. Turn tidak diaktifkan; News Phase dan Roll tidak dimulai.
4. Initialization yang sudah berhasil diproses dipertahankan dan tidak diulang atau di-rollback secara otomatis.
5. Initialization yang belum dijalankan dibatalkan.
6. Global Victory Check dijalankan menggunakan state terbaru.
7. Jika Match tetap RUNNING, Turn Controller memilih pemain berikutnya sesuai urutan awal dan prosedur Turn Start yang berlaku.
8. Disconnect bukan kegagalan teknis Initialization yang otomatis menghasilkan FAILED.
9. Operasi atomic yang sudah dimulai diselesaikan sampai batas aman sesuai TC-30.
10. Tidak ada status Chain atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-28 diperluas untuk mencakup disconnect selama Turn Initialization sebelum Turn Activation. TC-24, TC-34, TC-58, dan TC-59 diselaraskan untuk membedakan Player Leave/Elimination dari kegagalan teknis Initialization serta mencegah Turn Activation setelah disconnect.

**Batas teknis:** Detail pembatalan Initialization yang sedang berjalan, cleanup, dan sequencing operasi atomic tetap mengikuti kontrak terkait dan bagian TBD.

### Finding #21 — Active Player Disconnect During Resolution

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-24, TC-28, TC-30

**Keputusan yang disetujui:**

1. Disconnect pemain aktif selama Resolution diproses sebagai Player Leave/Elimination, bukan otomatis sebagai kegagalan teknis Resolution.
2. Turn Controller menghentikan penerimaan aksi gameplay baru dari pemain tersebut.
3. Atomic Operation yang sudah dimulai diselesaikan sampai batas aman sesuai TC-30.
4. Resolution lanjutan yang belum dimulai dibatalkan.
5. Setelah Player Leave/Elimination tervalidasi, Parent Turn Chain menjadi ABORTED melalui TC-24 dan TC-28.
6. State Change atau Resolution Operation yang sudah berhasil diproses tetap dipertahankan dan tidak dijalankan ulang atau di-rollback secara otomatis.
7. Kegagalan teknis independen atau state yang tidak dapat diverifikasi tetap ditangani sesuai aturan FAILED yang berlaku; disconnect tidak menghapus jalur kegagalan tersebut.
8. Tidak ada status Chain atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-24 poin 13 menegaskan jalur ABORTED ketika Player Leave/Elimination terjadi selama Resolution. TC-28 poin 8, 9, dan 13 diperjelas untuk mengatur penghentian Resolution, batas aman Atomic Operation, persistensi State Change yang telah berhasil, serta pembedaan disconnect dari kegagalan teknis independen. TC-30 poin 12 mengikat penanganan disconnect selama Resolution dengan sequencing server dan aturan FAILED yang berlaku.

**Batas teknis:** Detail deteksi disconnect, penghentian Resolution, penyelesaian Atomic Operation sampai batas aman, dan sequencing tetap mengikuti kontrak terkait serta bagian TBD.

### Finding #22 — First Lap Reward vs Normal Start Reward

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-18A

**Keputusan yang disetujui:**

1. First Lap hanya diberikan satu kali untuk setiap pemain.
2. Jika pemain menyelesaikan First Lap melalui Movement yang melewati atau mendarat di Start, reward yang diberikan adalah 100.000 Rels total.
3. Reward First Lap menggantikan reward Pass Start 20.000 Rels atau Landing Start 30.000 Rels pada Movement yang sama.
4. Reward First Lap tidak ditambahkan di atas reward normal Start.
5. Setelah First Lap selesai, reward Pass Start dan Landing Start kembali mengikuti aturan normal.
6. Tidak ada perubahan nominal reward atau penambahan decision ID.

**Perubahan dokumentasi:** TC-18A poin 4 diperjelas bahwa First Lap sebesar 100K menggantikan reward Pass Start atau Landing Start pada Movement yang sama dan tidak ditumpuk. TC-18A poin 5 menegaskan bahwa reward normal Start kembali berlaku setelah First Lap selesai. Perubahan ini menyelaraskan Specification 01 dengan Prototype Scope v1.0 bagian 2.6.

**Batas teknis:** Mekanisme pencatatan First Lap dan pemrosesan reward tetap mengikuti kontrak Start System serta detail implementasi yang belum ditetapkan.

### Finding #23 — Active Player Disconnect During Start Detection / Start Reward

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-18A, TC-24, TC-28, TC-30

**Keputusan yang disetujui:**

1. Jika pemain disconnect ketika Start Detection atau Start Reward belum dimulai setelah Movement Complete, pekerjaan yang belum dimulai dibatalkan.
2. Jika Atomic Operation Start Reward sudah dimulai, operasi diselesaikan sampai batas aman sesuai TC-30.
3. Reward yang berhasil diproses tetap dipertahankan dan tidak diberikan ulang atau di-rollback secara otomatis.
4. Landing Resolution yang belum dimulai dibatalkan.
5. Player Leave/Elimination divalidasi terlebih dahulu.
6. Setelah eliminasi tervalidasi, Parent Turn Chain menjadi ABORTED sesuai TC-24 dan TC-28.
7. Global Victory Check menggunakan state authoritative terbaru.
8. Disconnect bukan kegagalan teknis Start System yang otomatis menghasilkan FAILED.
9. Kegagalan teknis independen atau state yang tidak dapat diverifikasi tetap mengikuti aturan FAILED.
10. Tidak ada status Chain atau decision ID baru.

**Perubahan dokumentasi:** TC-18A diperluas untuk mengatur disconnect setelah Movement Complete selama Start Detection atau Start Reward. TC-24 menambahkan konsekuensi ABORTED setelah eliminasi tervalidasi. TC-28 memperluas cakupan disconnect dan menetapkan pembatalan pekerjaan yang belum dimulai, penyelesaian Atomic Operation Start Reward sampai batas aman, persistensi reward yang berhasil, serta pembatalan Landing Resolution yang belum dimulai. TC-30 menyelaraskan sequencing dan batas aman Atomic Operation dengan aturan tersebut.

**Batas teknis:** Detail deteksi disconnect, pembatalan Start Detection, penyelesaian Atomic Operation Start Reward, dan sequencing tetap mengikuti kontrak terkait serta bagian TBD.

### Finding #24 — Active Player Disconnect During Roll / Dice Resolution

**Status:** Approved and incorporated into Specification 01

**Kontrak terkait:** TC-15A, TC-16A, TC-24, TC-28, TC-29, TC-30

**Keputusan yang disetujui:**

1. Jika pemain aktif disconnect ketika Physical Dice masih bergulir dan hasil Roll belum valid, proses Roll dibatalkan.
2. Roll yang dibatalkan tidak menghasilkan Dice Resolution, Double Counter, Movement, atau efek gameplay.
3. Jika hasil Roll sudah divalidasi server, hasil tersebut tidak dibuat ulang atau digunakan untuk memulai Roll tambahan.
4. Jika Dice Resolution belum dimulai, proses tersebut dan Movement dibatalkan.
5. Jika Dice Resolution sudah dimulai, proses diselesaikan sampai batas aman sesuai TC-30.
6. Perubahan Double Counter yang telah berhasil diproses dipertahankan dan tidak dijalankan ulang atau di-rollback secara otomatis.
7. Movement yang belum dimulai dibatalkan dan Turn tidak melanjutkan gameplay setelah pemain disconnect.
8. Player Leave/Elimination harus divalidasi terlebih dahulu. Setelah tervalidasi, Parent Turn Chain menjadi ABORTED melalui TC-24 dan TC-28.
9. Global Victory Check menggunakan state authoritative terbaru. Jika Match tetap RUNNING, pemain berikutnya dipilih sesuai urutan match.
10. Disconnect bukan kegagalan teknis Roll atau Dice Resolution yang otomatis menghasilkan FAILED. Kegagalan teknis independen atau state yang tidak dapat diverifikasi tetap mengikuti aturan FAILED.
11. Tidak ada status Chain atau decision ID baru.

**Perubahan dokumentasi:** TC-15A membedakan disconnect sebelum dan sesudah hasil Roll valid. TC-16A mengatur penghentian Dice Resolution dan persistensi Double Counter. TC-24 menambahkan jalur ABORTED ketika Player Leave/Elimination terjadi selama Roll atau Dice Resolution. TC-28 memperluas cakupan disconnect dan menetapkan pembatalan Roll/Dice Resolution yang belum dimulai, penyelesaian proses yang sudah dimulai sampai batas aman, serta pembatalan Movement. TC-30 menyelaraskan sequencing dan batas aman operasi. TC-29 tetap menjadi perlindungan terhadap aksi Roll yang stale atau duplikat.

**Batas teknis:** Detail pembatalan Physical Dice, validasi hasil Roll, penyelesaian Dice Resolution, dan sequencing tetap mengikuti kontrak terkait serta bagian TBD.

### Finding #25 — Active Player Disconnect During News Phase / News Card

**Status:** Approved

**Kontrak terkait:** TC-14A, TC-24, TC-28, TC-30

**Keputusan yang disetujui:**

1. Jika pemain aktif disconnect selama News Phase, Turn Controller menghentikan penerimaan aksi gameplay baru dari pemain tersebut.
2. News Card yang sedang terbuka segera dibersihkan tanpa menunggu respons OK.
3. News effect yang telah berhasil diproses tetap dipertahankan dan tidak dijalankan ulang atau di-rollback secara otomatis.
4. News Resolution atau pekerjaan lanjutan yang belum dimulai dibatalkan.
5. Atomic Operation yang telah dimulai diselesaikan sampai batas aman sesuai TC-30.
6. Player Leave/Elimination harus divalidasi terlebih dahulu. Setelah tervalidasi, Parent Turn Chain menjadi ABORTED melalui TC-24 dan TC-28.
7. Global Victory Check menggunakan state authoritative terbaru.
8. Jika Match tetap RUNNING, Turn Controller melanjutkan ke pemain aktif berikutnya sesuai urutan match.
9. Jika pemain nonaktif disconnect, News Card dan News Resolution milik pemain aktif tetap berjalan tanpa interupsi, kecuali disconnect menyebabkan GAME_END.
10. Disconnect bukan kegagalan teknis News System yang otomatis menghasilkan FAILED. Kegagalan teknis independen atau state yang tidak dapat diverifikasi tetap mengikuti aturan FAILED.
11. Tidak ada status Chain atau decision ID baru.

**Perubahan dokumentasi:** TC-14A menambahkan penanganan disconnect selama News Phase, cleanup News Card, persistensi News effect, pembatalan pekerjaan yang belum dimulai, serta perlindungan ketika pemain nonaktif disconnect. TC-24 menambahkan jalur ABORTED setelah Player Leave/Elimination tervalidasi selama News Phase. TC-28 memperluas cakupan disconnect dan menetapkan cleanup News Card tanpa menunggu OK, penyelesaian Atomic Operation sampai batas aman, serta pembedaan disconnect pemain aktif dan nonaktif. TC-30 menyelaraskan sequencing dan batas aman Atomic Operation serta mempertahankan jalur FAILED untuk kegagalan teknis independen.

**Batas teknis:** Detail deteksi disconnect, cleanup News Card, validasi Player Leave/Elimination, penyelesaian Atomic Operation, dan sequencing tetap mengikuti kontrak terkait serta bagian TBD.


### Finding #26 — Game End vs Winner State Finalization

**Status:** Approved

**Kontrak terkait:** TC-21A, TC-25, TC-31

**Keputusan yang disetujui:**

1. Jika Global Victory Check menghasilkan GAME_END, hasilnya harus menyertakan identitas pemenang atau himpunan pemenang yang telah divalidasi berdasarkan Win Condition yang terpenuhi.
2. Turn Controller menggunakan identitas pemenang dari hasil Global Victory Check dan tidak menyimpulkan atau menebak pemenang sendiri.
3. Jika tepat satu pemain aktif tersisa, pemain tersebut ditetapkan memiliki Player State WINNER sebagai hasil Last Player Standing.
4. Jika tidak ada pemain aktif tersisa, Match berakhir tanpa pemenang dan tidak ada pemain yang ditetapkan memiliki Player State WINNER.
5. Penetapan pemenang dan Player State WINNER, jika ada, harus selesai sebelum informasi hasil Match diserahkan kepada UI.
6. Tidak ada perubahan Game State, Win Condition, atau decision ID baru.

**Perubahan dokumentasi:** TC-21A menegaskan bahwa hasil GAME_END membawa identitas pemenang atau himpunan pemenang yang telah divalidasi. TC-31 menetapkan transisi Player State WINNER untuk Last Player Standing, menegaskan bahwa hasil tanpa pemenang tidak menetapkan Player State WINNER kepada siapa pun, dan mengharuskan finalisasi hasil pemenang sebelum informasi Match diserahkan kepada UI sesuai TC-25.

**Batas teknis:** Mekanisme penyimpanan dan publikasi hasil pemenang tetap mengikuti implementasi Global Victory Check dan detail teknis yang belum ditetapkan.


### Finding #27 — Global Victory Check Outside Parent Turn Chain

**Status:** Approved

**Kontrak terkait:** TC-02A, TC-21A, TC-25, TC-26

**Keputusan yang disetujui:**

1. Global Victory Check berlaku untuk seluruh State Change yang dapat memengaruhi Win Condition, baik yang terjadi di dalam maupun di luar Parent Turn Chain.
2. Sistem yang menyelesaikan State Change di luar Parent Turn Chain meminta Global Victory Check setelah Atomic Operation terkait selesai.
3. Seluruh sistem menggunakan mekanisme Global Victory Check yang sama; sistem individual tidak membuat pemeriksaan Victory lokal sebagai pengganti pemeriksaan global.
4. Jika pemeriksaan yang diminta dari luar Parent Turn Chain menghasilkan GAME_END, hasil diteruskan kepada Turn Controller untuk menjalankan konsekuensi Game End sesuai TC-25.
5. Sistem peminta tidak memperoleh authority untuk menetapkan hasil Victory, menghentikan Match, atau mengambil alih Turn Controller secara independen.
6. Tidak ada TC atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-21A diperluas untuk menetapkan cakupan Global Victory Check di dalam dan di luar Parent Turn Chain, kewajiban meminta pemeriksaan setelah Atomic Operation eksternal selesai, penggunaan satu mekanisme global, serta penerusan hasil GAME_END kepada Turn Controller.

**Batas teknis:** Mekanisme pemanggilan, koordinasi, dan sequencing teknis untuk Global Victory Check dari operasi asynchronous tetap mengikuti detail implementasi dan bagian TBD; tidak ditambahkan authority baru kepada sistem pemanggil.

## Review Progress

| Finding | Topic | Decision | Documentation note |
|---|---|---|---|
| #1 | Turn Identity vs Turn Activation | Approved | Cross-contract alignment to be checked during consolidation |
| #2 | Initialization Atomicity vs Partial State Persistence | Approved | Technical storage/recovery details remain TBD |
| #3 | Match Termination vs Prototype Scope | Approved; prerequisite completed | Prototype Scope v1.0 sections 2.10 and 5 updated to ENDED without a winner for zero active players |
| #4 | Turn Activation vs News Phase Transition | Approved | TC-59 and TC-60 updated |
| #5 | Turn Identity, Initialization, and Activation Alignment | Approved | TC-13A, TC-14A, and TC-51 updated |
| #6 | Turn Start Authorization vs Turn Ownership | Approved | TC-56 point 6 updated |
| #7 | Duplicate Turn Start vs Prepared Turn Lifecycle | Approved | TC-57 point 2 updated |
| #8 | Player Eligibility vs Disconnect and Turn Handoff | Approved; prerequisite completed | TC-32, TC-55, and TC-56 updated; Prototype Scope v1.0 sections 2.1 and 2.10 aligned with initial roster order and eligibility skipping |
| #9 | Turn Completion Commit Boundary vs Late/Concurrent Result | Approved | TC-23 and TC-30 updated; technical sequencing details remain TBD |
| #10 | Turn Identity Creation vs Turn Start Authorization | Approved | TC-23 point 8 aligned with TC-13A, TC-51, and TC-56 |
| #11 | Prepared Turn Identity Invalidated When Candidate Becomes Ineligible | Approved | TC-23 point 8 and TC-51 clarified; identity cannot be reused |
| #12 | Prepared Identity vs Parent Turn Chain Lifecycle | Approved | TC-04A and TC-51 distinguish identity creation from Chain lifecycle start |
| #13 | Parent Turn Chain Lifecycle During Turn Initialization | Approved | TC-04A, TC-06B, and TC-13A define lifecycle start after successful authorization and before Initialization |
| #14 | Turn Start Authorization Failure Before Parent Turn Chain Lifecycle | Approved | TC-04A, TC-51, TC-56, and TC-57 distinguish pre-lifecycle process failure from Chain FAILED |
| #15 | Concurrent Event Arbitration vs Pre-Lifecycle Failure | Approved | TC-30 point 10 aligned with the pre-lifecycle failure boundary in TC-04A, TC-56, and TC-57 |
| #16 | Turn Activation State Unverifiable vs Chain Failure | Approved | TC-59 point 10 aligned with TC-04A failure handling after Chain lifecycle start |
| #17 | News Phase Transition State Unverifiable | Approved | TC-60 point 8 aligned with TC-04A failure handling; no assumed retry or gameplay continuation |
| #18 | Active Player Disconnect During Turn Initialization | Approved | TC-28 extended; TC-24, TC-34, TC-58, and TC-59 distinguish Player Leave/Elimination from technical Initialization failure |
| #19 | Active Player Disconnect After Turn Activation but Before News Phase | Approved | TC-28, TC-24, and TC-60 define ABORTED handling; News Phase and Roll do not start |
| #20 | Active Player Disconnect During Movement | Approved | TC-17A, TC-18A, TC-24, and TC-28 define safe Movement stop, authoritative safe tile, and ABORTED handling |
| #21 | Active Player Disconnect During Resolution | Approved | TC-24, TC-28, and TC-30 define safe Atomic Operation boundary, ABORTED handling, and distinction from independent technical failure |
| #22 | First Lap Reward vs Normal Start Reward | Approved | TC-18A clarifies that the 100K First Lap reward replaces, rather than stacks with, the normal Start reward |
| #23 | Active Player Disconnect During Start Detection / Start Reward | Approved | TC-18A, TC-24, TC-28, and TC-30 define safe reward completion, reward retention, ABORTED handling, and cancellation of unstarted Landing Resolution |
| #24 | Active Player Disconnect During Roll / Dice Resolution | Approved | TC-15A, TC-16A, TC-24, TC-28, and TC-30 define cancellation before valid Roll, safe Dice Resolution completion, Double Counter retention, and ABORTED handling |
| #25 | Active Player Disconnect During News Phase / News Card | Approved | TC-14A, TC-24, TC-28, and TC-30 define News Card cleanup, retention of processed effects, cancellation of unstarted work, and active vs non-active disconnect handling |
| #26 | Game End vs Winner State Finalization | Approved | TC-21A and TC-31 define validated winner identity, Player State WINNER assignment for Last Player Standing, no winner assignment when zero active players remain, and finalization before UI handoff |
| #27 | Global Victory Check Outside Parent Turn Chain | Approved | TC-21A applies the shared Global Victory Check to relevant State Changes inside and outside Parent Turn Chain and routes external GAME_END results through Turn Controller / TC-25 |
| #28 | Global Victory Check Before the Next Relevant State Change | Approved | TC-02A and TC-21A require the shared Global Victory Check to finish before the next relevant State Change commits; GAME_END blocks subsequent State Changes |
| #29 | Global Sequential State Change Across Gameplay Systems | Approved | TC-02A, TC-09A, and TC-30 establish one global server processing order for all gameplay State Changes, atomic completion, and Final Validation against the latest authoritative state; Global Victory Check remains scoped by TC-21A |
| #30 | Pending Trade / Transaction During Party Disconnect | Approved | TC-26 clarifies cancellation of pending proposals on party disconnect, completion of started atomic operations, and no rollback of completed operations |
| #31 | Global Victory Check Scope in Global State Sequencing | Approved | Master Source of Truth sections 18–19 and Progress 20 section 2 clarify that all gameplay State Changes remain globally sequential, while Global Victory Check is required only for State Changes that can affect Win Condition |
| #32 | Specification 01 Consolidated Review Status Metadata | Approved | Specification 01 header now reflects the approved findings through #32, matching this review log; no gameplay contract or decision ID changed |
| #33 | Final Bankruptcy with Zero Active Players | Approved | Progress 20 Audit #1 point 10 now distinguishes remaining active players from zero active players; zero active players ends the Match without a winner or a new Turn, consistent with TC-31 |
| #34 | Forced Break and Frozen Turn Handoff | Approved | TC-23, Master Source of Truth section 3, and Progress 20 Audit #8 Case 3 define Frozen Turn as a Turn Controller-controlled skip of exactly one next eligible player's scheduled turn; no Turn/Chain/phase/status processing occurs, the player remains ACTIVE with assets intact, and Game End overrides the skip |
| #35 | Frozen Turn and Pending Turn-Based Effects | Approved | TC-23, Master Source of Truth section 3, and Progress 20 Audit #8 Case 3 clarify that Frozen Turn does not consume pending next-normal-turn effects, decrement owner-turn-based durations, use pending Fast Travel, or change attempt-based counters such as Jail Attempt Counter |

**Next step:** Continue consolidated review with Finding #36, using the current GitHub version of Specification 01 and relevant canonical source documents. Do not introduce new decision IDs.



### Finding #30 — Pending Trade / Transaction During Party Disconnect

**Status:** Approved

**Kontrak terkait:** TC-02A, TC-26, TC-30

**Keputusan yang disetujui:**

1. Jika salah satu pihak dalam Pending Trade atau Pending Transaction disconnect sebelum operasi selesai, proposal tersebut dibatalkan.
2. Proposal yang dibatalkan tidak dapat diterima, dinegosiasikan, atau dieksekusi kembali.
3. Jika Atomic Operation Trade atau Transaction telah dimulai sebelum disconnect terdeteksi, operasi tersebut diselesaikan secara utuh sesuai TC-02A dan TC-30.
4. Proposal yang masih pending dan belum memulai Atomic Operation dibatalkan.
5. Operasi Trade atau Transaction yang sudah Completed tidak di-rollback akibat disconnect.
6. Pembatalan proposal dan penyelesaian operasi yang sudah dimulai tidak memberikan authority Turn Controller kepada sistem Trade atau Transaction.
7. Tidak ada TC atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-26 diperjelas untuk menetapkan pembatalan Pending Trade dan Pending Transaction ketika salah satu pihak disconnect sebelum operasi selesai, larangan menggunakan kembali proposal yang dibatalkan, penyelesaian Atomic Operation yang telah dimulai secara utuh sesuai TC-02A dan TC-30, serta larangan rollback terhadap operasi yang sudah Completed.

**Batas teknis:** Detail deteksi disconnect, koordinasi pembatalan proposal, dan batas dimulainya Atomic Operation tetap mengikuti implementasi serta mekanisme sequencing yang belum ditetapkan. Approval ini merupakan persetujuan desain/dokumentasi, bukan persetujuan implementasi atau pengujian.

### Finding #29 — Global Sequential State Change Across Gameplay Systems

**Status:** Approved

**Kontrak terkait:** TC-02A, TC-09A, TC-21A, TC-30

**Keputusan yang disetujui:**

1. Seluruh gameplay State Change, baik yang terjadi di dalam Parent Turn Chain maupun yang berasal dari sistem asynchronous di luar Chain, mengikuti satu urutan pemrosesan server secara global.
2. State Change berikutnya hanya boleh mulai diproses setelah State Change sebelumnya menyelesaikan Atomic Operation secara utuh.
3. Final Validation setiap State Change harus menggunakan state authoritative terbaru setelah seluruh State Change yang mendahuluinya dalam urutan global selesai diproses; preconditions yang dapat berubah divalidasi kembali sebelum commit.
4. Sequential Resolution Execution di dalam Parent Turn Chain merupakan bagian dari urutan pemrosesan State Change global dan tidak membentuk jalur sequencing terpisah.
5. Global Victory Check tetap diwajibkan hanya untuk State Change yang dapat memengaruhi Win Condition, sesuai TC-21A. Pemeriksaan tersebut harus selesai sebelum State Change relevan berikutnya boleh melakukan commit.
6. Jika Global Victory Check menghasilkan GAME_END, State Change berikutnya ditolak dan konsekuensi Game End dijalankan melalui Turn Controller sesuai TC-25.
7. Aturan sequencing global tidak memberikan authority Turn Controller kepada sistem gameplay atau asynchronous.
8. Mekanisme teknis sequencing, queue, dan arbitration tetap TBD.
9. Tidak ada TC atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-02A menetapkan satu urutan pemrosesan global untuk seluruh gameplay State Change, kewajiban Atomic Operation selesai sebelum State Change berikutnya dimulai, dan Final Validation terhadap state authoritative terbaru. TC-09A menyelaraskan sequential execution Parent Turn Chain dengan urutan global tersebut. TC-30 memperjelas cakupan sequencing global serta mempertahankan detail mekanisme teknis sebagai TBD. TC-21A tetap menjadi acuan cakupan dan timing Global Victory Check untuk State Change yang dapat memengaruhi Win Condition.

**Batas teknis:** Implementasi queue, arbitration, fairness, dan mekanisme sequencing lintas sistem belum ditetapkan. Approval ini merupakan persetujuan desain/dokumentasi, bukan persetujuan implementasi atau pengujian.

### Finding #28 — Global Victory Check Before the Next Relevant State Change

**Status:** Approved

**Kontrak terkait:** TC-02A, TC-21A, TC-30

**Keputusan yang disetujui:**

1. Gameplay State Change yang dapat memengaruhi Win Condition diproses secara berurutan, termasuk operasi asynchronous di luar Parent Turn Chain.
2. Setelah Atomic Operation selesai, Global Victory Check untuk State Change tersebut harus selesai sebelum State Change relevan berikutnya boleh melakukan commit.
3. Jika Global Victory Check menghasilkan CONTINUE, State Change relevan berikutnya dapat diproses setelah validasi terhadap state authoritative terbaru.
4. Jika Global Victory Check menghasilkan GAME_END, State Change berikutnya ditolak dan konsekuensi Game End dijalankan melalui Turn Controller sesuai TC-25.
5. Atomic Operation tetap diselesaikan secara utuh sebelum Global Victory Check dijalankan.
6. Seluruh sistem menggunakan satu mekanisme Global Victory Check; tidak ada pemeriksaan lokal sebagai pengganti pemeriksaan global.
7. Tidak ada TC atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** TC-02A dan TC-21A diperjelas untuk mewajibkan penyelesaian Global Victory Check sebelum commit State Change relevan berikutnya. Hasil CONTINUE mengizinkan proses berikutnya setelah validasi state terbaru; GAME_END menolak State Change berikutnya dan diteruskan melalui Turn Controller / TC-25.

### Finding #31 — Global Victory Check Scope in Global State Sequencing

**Status:** Approved

**Dokumen terkait:** Master Source of Truth sections 18–19; Progress 20 section 2.2–2.3

**Keputusan yang disetujui:**

1. Seluruh gameplay State Change, baik di dalam Parent Turn Chain maupun dari sistem asynchronous di luar Chain, tetap mengikuti satu urutan pemrosesan server secara global.
2. State Change berikutnya hanya mulai diproses setelah Atomic Operation sebelumnya selesai secara utuh.
3. Final Validation menggunakan state authoritative terbaru sesuai urutan pemrosesan server.
4. Global Victory Check tidak diwajibkan untuk setiap State Change. Pemeriksaan hanya wajib setelah Atomic Operation yang dapat memengaruhi Win Condition selesai.
5. Jika Global Victory Check diperlukan, pemeriksaan harus selesai sebelum State Change relevan berikutnya melakukan commit.
6. Jika hasilnya CONTINUE, pemrosesan dapat berlanjut setelah validasi terhadap state authoritative terbaru. Jika hasilnya GAME_END, State Change berikutnya ditolak dan konsekuensi Game End dijalankan melalui Turn Controller.
7. State Change yang tidak dapat memengaruhi Win Condition tetap mengikuti urutan global, tetapi tidak memerlukan Global Victory Check tersendiri.
8. Tidak ada TC atau decision ID baru yang ditambahkan.

**Perubahan dokumentasi:** Master Source of Truth bagian 18 diperjelas untuk membedakan global sequential processing dari cakupan Global Victory Check. Bagian 19, Standard Action Pipeline, diperbarui agar Global Victory Check menjadi langkah kondisional berdasarkan dampak State Change terhadap Win Condition. Progress 20 bagian 2.2 dan 2.3 diselaraskan dengan batasan yang sama.

**Batas teknis:** Penentuan teknis apakah suatu State Change dapat memengaruhi Win Condition harus mengikuti kontrak domain dan implementasi authoritative. Mekanisme sequencing global tetap mengikuti batas TBD yang telah ditetapkan. Approval ini merupakan persetujuan desain/dokumentasi, bukan persetujuan implementasi atau pengujian.


### Finding #32 — Specification 01 Consolidated Review Status Metadata

**Status:** Approved

**Dokumen terkait:** Specification 01 header; Consolidated Review Log

**Keputusan yang disetujui:**

1. Metadata Consolidated Review pada header Specification 01 harus mencerminkan jumlah Finding yang telah disetujui dalam Consolidated Review Log.
2. Setelah Finding #32 disetujui, header Specification 01 mencatat bahwa Findings #1 through #32 telah approved dan review masih berlangsung.
3. Review Log mencatat Finding #32 sebagai Approved dan langkah berikutnya adalah Finding #33.
4. Perubahan ini hanya menyelaraskan metadata progres dokumentasi. Tidak ada perubahan pada kontrak TC-01 sampai TC-60 dan tidak ada decision ID baru.
5. Specification 01 tetap berstatus DRAFT; Implementation Status tetap Not Implemented / Not Tested.

**Perubahan dokumentasi:** Metadata Consolidated Review pada header Specification 01 diperbarui dari Findings #1 through #29 menjadi Findings #1 through #32. Header dan daftar Approved Findings pada Consolidated Review Log diselaraskan, dan langkah berikutnya diperbarui menjadi Finding #33.

**Batas:** Persetujuan ini hanya menyangkut konsistensi metadata review. Ini bukan approval final Specification 01, bukan perubahan kontrak gameplay, dan bukan persetujuan implementasi atau pengujian.


### Finding #33 — Final Bankruptcy with Zero Active Players

**Status:** Approved

**Dokumen terkait:** Progress 20 Audit #1, point 10; TC-31

**Keputusan yang disetujui:**

1. Setelah Final Bankruptcy, Global Victory Check tetap dijalankan.
2. Jika Global Victory Check tidak menemukan Win Condition dan masih terdapat pemain aktif, Turn Controller dapat melanjutkan ke pemain aktif berikutnya sesuai Master Flow.
3. Jika tidak ada pemain aktif tersisa, Match berakhir dengan Game State ENDED tanpa pemenang.
4. Dalam kondisi nol pemain aktif, tidak ada Turn baru yang dibuat atau dijalankan.
5. Aturan ini menyelaraskan Progress 20 Audit #1 dengan TC-31. Tidak ada perubahan pada TC-01 sampai TC-60 dan tidak ada decision ID baru.

**Perubahan dokumentasi:** Progress 20 Audit #1 point 10 diperjelas agar kelanjutan ke pemain aktif berikutnya hanya berlaku jika masih ada pemain aktif. Jika tidak ada pemain aktif tersisa, Match berakhir dengan Game State ENDED tanpa pemenang dan tanpa Turn baru sesuai TC-31.

**Batas:** Perubahan ini merupakan revisi dokumentasi yang disetujui pada dokumen Progress 20 yang berstatus LOCKED. Approval ini bukan persetujuan implementasi atau pengujian.



### Finding #34 — Forced Break and Frozen Turn Handoff

**Status:** Approved and incorporated into canonical documentation

**Kontrak terkait:** TC-23; Progress 20 Audit #8, Case 3

**Keputusan yang disetujui:**

1. Forced Break menghasilkan `TURN_END` dan membatalkan Extra Roll yang belum dijalankan.
2. Frozen Turn baru berlaku setelah Turn saat ini benar-benar selesai, termasuk penyelesaian Deferred Turn End jika News Card atau Blocking UI masih wajib diselesaikan.
3. Frozen Turn adalah mekanisme handoff/skip yang dikendalikan Turn Controller, bukan Resolution normal atau Turn baru yang dijalankan sebagian.
4. Turn Controller memeriksa Game State terlebih dahulu. Jika Game State ENDED, Game End mengalahkan Frozen Turn.
5. Jika Match masih RUNNING, satu giliran terjadwal pemain eligible berikutnya dilewati menurut urutan roster dan validasi eligibility TC-55. Kandidat yang tidak lagi eligible dilewati tanpa mengonsumsi Frozen Turn; skip berlaku kepada kandidat eligible berikutnya.
6. Giliran yang dilewati tidak membuat TurnID atau ParentTurnChainID, tidak memulai Parent Turn Chain, dan tidak menjalankan Turn Initialization, Turn Activation, News Phase, Roll, Dice Resolution, Movement, Fast Travel, aktivitas giliran, atau pemrosesan status berbasis giliran.
7. Pemain yang dilewati tetap ACTIVE, mempertahankan Balance dan seluruh aset, serta tetap berada pada posisi yang sama dalam urutan roster.
8. Satu Frozen Turn dikonsumsi tepat satu kali setelah satu pemain eligible berhasil dilewati. Frozen Turn tidak ditumpuk atau dibawa ke pemain berikutnya.
9. Setelah skip dikonsumsi, Turn Controller melanjutkan handoff normal kepada pemain eligible berikutnya.
10. Tidak ada TC atau decision ID baru yang ditambahkan. Specification 01 tetap DRAFT; status implementasi tetap Not Implemented / Not Tested.

**Perubahan dokumentasi:** TC-23 diperluas untuk menetapkan timing Frozen Turn setelah Turn End benar-benar committed, prioritas Game End, seleksi pemain eligible menurut TC-55, skip tanpa TurnID/ParentTurnChainID maupun Parent Turn Chain, tidak adanya seluruh fase dan pemrosesan status berbasis giliran, persistensi Player State dan aset, serta konsumsi tepat satu kali. Master Source of Truth bagian 3 dan Progress 20 Audit #8 Case 3 diselaraskan dengan kontrak tersebut. Metadata Specification 01, Review Log, Development Log, dan Changelog diperbarui.

**Batas:** Approval ini merupakan persetujuan desain dan dokumentasi, bukan persetujuan implementasi atau pengujian. Progress 20 tetap berstatus LOCKED; revisi terbatas pada Audit #8 Case 3 yang secara eksplisit disetujui melalui Finding #34.

### Finding #35 — Frozen Turn and Pending Turn-Based Effects

**Status:** Approved and incorporated into canonical documentation

**Kontrak terkait:** TC-23; Master Source of Truth section 3; Progress 20 Audit #8, Case 3

**Keputusan yang disetujui:**

1. Frozen Turn merupakan giliran terjadwal yang dilewati, bukan giliran normal pemain yang dijalankan.
2. Efek, privilege, atau durasi yang dihitung berdasarkan giliran normal milik pemain yang dilewati tidak berkurang dan tidak dikonsumsi oleh Frozen Turn.
3. Efek atau privilege yang dijadwalkan aktif pada giliran normal pemain berikutnya tetap pending selama Frozen Turn dan baru diproses ketika giliran normal pemain tersebut benar-benar dimulai.
4. Durasi Reward yang dihitung berdasarkan jumlah giliran pemilik tidak berkurang selama Frozen Turn; penghitungannya berlanjut pada giliran normal pemilik sesuai aturan Reward.
5. Fast Travel privilege yang masih menunggu penggunaan tetap tersedia. Fast Travel UI dan penggunaannya tidak dijalankan selama Frozen Turn, tetapi dilanjutkan pada giliran normal pemain tersebut.
6. Jail Attempt Counter dan counter berbasis percobaan lainnya tidak berubah hanya karena Frozen Turn. Counter hanya berubah ketika peristiwa gameplay yang menjadi dasar penghitungannya benar-benar terjadi. Jail Attempt Counter bertambah hanya setelah pemain benar-benar melakukan percobaan Double di Jail dan hasilnya Non-Double.
7. Setelah Frozen Turn selesai, efek, privilege, durasi, dan counter dilanjutkan menurut aturan sistem masing-masing pada giliran normal pemain.
8. Tidak ada TC atau decision ID baru yang ditambahkan. Specification 01 tetap DRAFT; status implementasi tetap Not Implemented / Not Tested.

**Perubahan dokumentasi:** TC-23 diperluas untuk menetapkan persistensi efek dan privilege yang menunggu, tidak berkurangnya durasi Reward berbasis giliran pemilik, penundaan aktivasi efek sampai giliran normal pemain, serta tidak berubahnya counter berbasis percobaan selama Frozen Turn. Master Source of Truth bagian Frozen Turn dan Progress 20 Audit #8 Case 3 diselaraskan. Metadata Specification 01, Review Log, Development Log, dan Changelog diperbarui.

**Batas:** Approval ini merupakan persetujuan desain dan dokumentasi, bukan persetujuan implementasi atau pengujian. Progress 20 tetap berstatus LOCKED; revisi terbatas pada Audit #8 Case 3 yang secara eksplisit disetujui melalui Finding #35.

### Finding #37 — Cancel Pending Frozen Turn When Parent Turn Chain Aborts

**Status:** Approved and incorporated into canonical documentation

**Kontrak terkait:** TC-23; TC-24; TC-06A; Master Source of Truth Frozen Turn section; Progress 20 Audit #8, Case 3

**Keputusan yang disetujui:**

1. Frozen Turn yang telah dicatat sebagai konsekuensi Forced Break hanya dapat diterapkan setelah Parent Turn Chain pemicunya benar-benar ditetapkan COMPLETED.
2. Jika Parent Turn Chain berakhir ABORTED sebelum mencapai COMPLETED, kewajiban Frozen Turn yang masih pending dibatalkan.
3. Frozen Turn tidak dibawa ke handoff setelah Player Elimination atau hasil terminal lain yang mengakhiri Chain melalui jalur ABORTED.
4. Hasil terminal yang mengakhiri Chain melalui ABORTED mengalahkan kewajiban Frozen Turn yang masih pending. Aturan ini tidak mengubah prioritas Game End atau kontrak Frozen Turn setelah Turn berhasil COMPLETED.
5. Tidak ada TC atau decision ID baru yang ditambahkan. Specification 01 tetap DRAFT; status implementasi tetap Not Implemented / Not Tested.

**Perubahan dokumentasi:** TC-23 diperjelas untuk membatalkan Frozen Turn pending ketika Parent Turn Chain berakhir ABORTED sebelum COMPLETED. Master Source of Truth bagian Frozen Turn dan Progress 20 Audit #8 Case 3 diselaraskan.

**Batas:** Approval ini merupakan persetujuan desain dan dokumentasi, bukan persetujuan implementasi atau pengujian. Progress 20 tetap LOCKED; revisi terbatas pada aturan Frozen Turn di Audit #8 Case 3 yang secara eksplisit disetujui melalui Finding #37.
